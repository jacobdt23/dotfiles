#include "BluetoothController.hpp"
#include <QRegularExpression>
#include <QtConcurrent>

BluetoothController::BluetoothController(QObject *parent)
    : QObject(parent)
{
    connect(&m_pollTimer, &QTimer::timeout, this, &BluetoothController::refresh);
    m_pollTimer.start(3500);
    refresh();
}

void BluetoothController::refresh()
{
    parseAdapterInfo();
    parsePairedDevices();
}

void BluetoothController::parseAdapterInfo()
{
    QProcess proc;
    proc.start("bluetoothctl", {"show"});
    if (!proc.waitForFinished(1500)) return;

    QString out = QString::fromUtf8(proc.readAllStandardOutput());
    bool newEnabled = out.contains("Powered: yes");
    bool newDisc = out.contains("Discoverable: yes");

    QString newName = "Bluetooth Controller";
    for (const QString &line : out.split('\n')) {
        if (line.contains("Name:")) {
            newName = line.section("Name:", 1).trimmed();
            break;
        }
    }

    if (m_enabled != newEnabled) {
        m_enabled = newEnabled;
        emit enabledChanged();
    }
    if (m_discoverable != newDisc) {
        m_discoverable = newDisc;
        emit discoverableChanged();
    }
    if (m_adapterName != newName) {
        m_adapterName = newName;
        emit adapterNameChanged();
    }
}

void BluetoothController::parsePairedDevices()
{
    QProcess proc;
    proc.start("bluetoothctl", {"devices"});
    if (!proc.waitForFinished(1500)) return;

    QString out = QString::fromUtf8(proc.readAllStandardOutput());
    QVariantList newDevices;

    const QStringList lines = out.split('\n', Qt::SkipEmptyParts);
    for (const QString &line : lines) {
        if (!line.startsWith("Device")) continue;

        QStringList parts = line.split(' ');
        if (parts.size() >= 3) {
            QString mac = parts.at(1);
            QString name = line.section(' ', 2).trimmed();

            QProcess infoProc;
            infoProc.start("bluetoothctl", {"info", mac});
            bool connected = false;
            QString battery = "";
            if (infoProc.waitForFinished(1000)) {
                QString infoOut = QString::fromUtf8(infoProc.readAllStandardOutput());
                connected = infoOut.contains("Connected: yes");
                if (infoOut.contains("Battery Percentage:")) {
                    QRegularExpression re(R"(Battery Percentage:\s*(\S+))");
                    QRegularExpressionMatch match = re.match(infoOut);
                    if (match.hasMatch()) {
                        battery = match.captured(1);
                    }
                }
            }

            QVariantMap dev;
            dev["mac"] = mac;
            dev["name"] = name;
            dev["connected"] = connected;
            dev["battery"] = battery;
            newDevices.append(dev);
        }
    }

    if (m_pairedDevices != newDevices) {
        m_pairedDevices = newDevices;
        emit pairedDevicesChanged();
    }
}

void BluetoothController::togglePower(bool on)
{
    QProcess::startDetached("bluetoothctl", {"power", on ? "on" : "off"});
    QTimer::singleShot(500, this, &BluetoothController::refresh);
}

void BluetoothController::toggleDiscoverable(bool on)
{
    QProcess::startDetached("bluetoothctl", {"discoverable", on ? "on" : "off"});
    QTimer::singleShot(500, this, &BluetoothController::refresh);
}

void BluetoothController::startScan()
{
    if (m_scanning) return;
    m_scanning = true;
    m_nearbyDevices.clear();
    emit scanningChanged();
    emit nearbyDevicesChanged();

    if (!m_scanProcess) {
        m_scanProcess = new QProcess(this);
        connect(m_scanProcess, &QProcess::readyReadStandardOutput, this, &BluetoothController::onScanProcessOutput);
        connect(m_scanProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &BluetoothController::onScanFinished);
    }
    m_scanProcess->start("bluetoothctl", {"--timeout", "15", "scan", "on"});
}

void BluetoothController::stopScan()
{
    if (!m_scanning) return;
    if (m_scanProcess && m_scanProcess->state() != QProcess::NotRunning) {
        m_scanProcess->terminate();
    }
    QProcess::startDetached("bluetoothctl", {"scan", "off"});
    m_scanning = false;
    emit scanningChanged();
}

void BluetoothController::onScanProcessOutput()
{
    if (!m_scanProcess) return;
    QString out = QString::fromUtf8(m_scanProcess->readAllStandardOutput());
    bool changed = false;

    for (const QString &line : out.split('\n')) {
        if (line.contains("Device")) {
            QStringList tokens = line.trimmed().split(' ');
            int devIdx = tokens.indexOf("Device");
            if (devIdx >= 0 && devIdx + 2 < tokens.size()) {
                QString mac = tokens.at(devIdx + 1);
                QString name = tokens.mid(devIdx + 2).join(' ');

                bool alreadyKnown = false;
                for (const auto &item : m_pairedDevices) {
                    if (item.toMap().value("mac").toString() == mac) {
                        alreadyKnown = true;
                        break;
                    }
                }
                for (const auto &item : m_nearbyDevices) {
                    if (item.toMap().value("mac").toString() == mac) {
                        alreadyKnown = true;
                        break;
                    }
                }

                if (!alreadyKnown && !name.isEmpty() && !name.contains(':')) {
                    QVariantMap dev;
                    dev["mac"] = mac;
                    dev["name"] = name;
                    m_nearbyDevices.append(dev);
                    changed = true;
                }
            }
        }
    }

    if (changed) {
        emit nearbyDevicesChanged();
    }
}

void BluetoothController::onScanFinished()
{
    m_scanning = false;
    emit scanningChanged();
}

void BluetoothController::connectDevice(const QString &mac)
{
    QProcess::startDetached("bluetoothctl", {"connect", mac});
    QTimer::singleShot(2500, this, &BluetoothController::refresh);
}

void BluetoothController::disconnectDevice(const QString &mac)
{
    QProcess::startDetached("bluetoothctl", {"disconnect", mac});
    QTimer::singleShot(1000, this, &BluetoothController::refresh);
}

void BluetoothController::removeDevice(const QString &mac)
{
    QProcess::startDetached("bluetoothctl", {"remove", mac});
    QTimer::singleShot(800, this, &BluetoothController::refresh);
}

void BluetoothController::pairDevice(const QString &mac)
{
    QtConcurrent::run([this, mac]() {
        QProcess::execute("bluetoothctl", {"pair", mac});
        QProcess::execute("bluetoothctl", {"trust", mac});
        QProcess::execute("bluetoothctl", {"connect", mac});
        QMetaObject::invokeMethod(this, "refresh", Qt::QueuedConnection);
    });
}
