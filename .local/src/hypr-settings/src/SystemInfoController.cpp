#include "SystemInfoController.hpp"
#include <QFile>
#include <QTextStream>
#include <QSysInfo>
#include <QHostInfo>
#include <QDir>
#include <QProcess>

SystemInfoController::SystemInfoController(QObject *parent)
    : QObject(parent)
{
    readSystemSpecs();
    readBattery();
}

void SystemInfoController::readSystemSpecs()
{
    // OS
    QFile osRel("/etc/os-release");
    if (osRel.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&osRel);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.startsWith("PRETTY_NAME=")) {
                m_osName = line.section('=', 1).remove('"').trimmed();
                break;
            }
        }
    }

    m_kernelVersion = QSysInfo::kernelVersion();
    m_hostname = QHostInfo::localHostName();

    // CPU
    QFile cpuFile("/proc/cpuinfo");
    if (cpuFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&cpuFile);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.contains("model name")) {
                m_cpuModel = line.section(':', 1).trimmed();
                break;
            }
        }
    }

    // Memory
    QFile memFile("/proc/meminfo");
    if (memFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&memFile);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.startsWith("MemTotal:")) {
                QStringList parts = line.split(' ', Qt::SkipEmptyParts);
                if (parts.size() >= 2) {
                    double kb = parts.at(1).toDouble();
                    double gb = kb / (1024.0 * 1024.0);
                    m_totalMemory = QString("%1 GiB").arg(QString::number(gb, 'f', 1));
                }
                break;
            }
        }
    }
}

void SystemInfoController::readBattery()
{
    QDir powerDir("/sys/class/power_supply");
    QStringList bats = powerDir.entryList({"BAT*"}, QDir::Dirs);
    if (!bats.isEmpty()) {
        m_hasBattery = true;
        QString batPath = powerDir.filePath(bats.first());

        QFile capFile(batPath + "/capacity");
        if (capFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
            m_batteryPercent = capFile.readAll().trimmed().toInt();
        }

        QFile statFile(batPath + "/status");
        if (statFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
            m_batteryStatus = QString::fromUtf8(statFile.readAll()).trimmed();
        }
        emit batteryChanged();
    }
}
