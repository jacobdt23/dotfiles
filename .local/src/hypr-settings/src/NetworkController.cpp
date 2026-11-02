#include "NetworkController.hpp"
#include <QProcess>
#include <QtConcurrent>
#include <QSet>

NetworkController::NetworkController(QObject *parent)
    : QObject(parent)
{
    connect(&m_timer, &QTimer::timeout, this, &NetworkController::refresh);
    m_timer.start(5000);
    refresh();
}

void NetworkController::refresh()
{
    // Radio status
    QProcess radioProc;
    radioProc.start("nmcli", {"radio", "wifi"});
    if (radioProc.waitForFinished(1000)) {
        bool en = radioProc.readAllStandardOutput().trimmed() == "enabled";
        if (m_wifiEnabled != en) {
            m_wifiEnabled = en;
            emit wifiEnabledChanged();
        }
    }

    // Active connection
    QProcess actProc;
    actProc.start("nmcli", {"-t", "-f", "TYPE,NAME", "connection", "show", "--active"});
    if (actProc.waitForFinished(1000)) {
        QString actOut = QString::fromUtf8(actProc.readAllStandardOutput()).trimmed();
        QString act = "Disconnected";
        for (const QString &line : actOut.split('\n')) {
            if (line.contains(':')) {
                QString ctype = line.section(':', 0, 0);
                QString cname = line.section(':', 1);
                act = QString("%1 (%2)").arg(cname, ctype);
                break;
            }
        }
        if (m_activeConnection != act) {
            m_activeConnection = act;
            emit activeConnectionChanged();
        }
    }

    // Networks
    scanNetworks();
}

void NetworkController::toggleWifi(bool on)
{
    QProcess::startDetached("nmcli", {"radio", "wifi", on ? "on" : "off"});
    QTimer::singleShot(500, this, &NetworkController::refresh);
}

void NetworkController::scanNetworks()
{
    QtConcurrent::run([this]() {
        QProcess proc;
        proc.start("nmcli", {"-t", "-f", "IN-USE,SSID,BARS,SECURITY", "device", "wifi", "list"});
        if (!proc.waitForFinished(3000)) return;

        QString out = QString::fromUtf8(proc.readAllStandardOutput());
        QVariantList nets;
        QSet<QString> seen;

        for (const QString &line : out.split('\n', Qt::SkipEmptyParts)) {
            QStringList parts = line.split(':');
            if (parts.size() >= 3) {
                bool inUse = parts.at(0) == "*";
                QString ssid = parts.at(1).trimmed();
                QString bars = parts.at(2).trimmed();
                QString sec = parts.size() > 3 ? parts.at(3).trimmed() : "Open";

                if (!ssid.isEmpty() && !seen.contains(ssid)) {
                    seen.insert(ssid);
                    QVariantMap item;
                    item["inUse"] = inUse;
                    item["ssid"] = ssid;
                    item["bars"] = bars;
                    item["security"] = sec.isEmpty() ? "Open" : sec;
                    item["isSecured"] = !sec.isEmpty() && sec != "--";
                    nets.append(item);
                }
            }
        }

        QMetaObject::invokeMethod(this, [this, nets]() {
            if (m_networks != nets) {
                m_networks = nets;
                emit networksChanged();
            }
        });
    });
}

void NetworkController::connectNetwork(const QString &ssid, const QString &password)
{
    QtConcurrent::run([this, ssid, password]() {
        QStringList args = {"device", "wifi", "connect", ssid};
        if (!password.isEmpty()) {
            args << "password" << password;
        }
        QProcess::execute("nmcli", args);
        QMetaObject::invokeMethod(this, "refresh", Qt::QueuedConnection);
    });
}

void NetworkController::disconnectNetwork(const QString &ssid)
{
    Q_UNUSED(ssid);
    QProcess::startDetached("nmcli", {"device", "disconnect", "wlan0"});
    QTimer::singleShot(1000, this, &NetworkController::refresh);
}
