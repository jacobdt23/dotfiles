#ifndef SYSTEMINFOCONTROLLER_HPP
#define SYSTEMINFOCONTROLLER_HPP

#include <QObject>

class SystemInfoController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString osName READ osName CONSTANT)
    Q_PROPERTY(QString kernelVersion READ kernelVersion CONSTANT)
    Q_PROPERTY(QString compositor READ compositor CONSTANT)
    Q_PROPERTY(QString cpuModel READ cpuModel CONSTANT)
    Q_PROPERTY(QString totalMemory READ totalMemory CONSTANT)
    Q_PROPERTY(QString hostname READ hostname CONSTANT)
    Q_PROPERTY(QString batteryStatus READ batteryStatus NOTIFY batteryChanged)
    Q_PROPERTY(int batteryPercent READ batteryPercent NOTIFY batteryChanged)
    Q_PROPERTY(bool hasBattery READ hasBattery NOTIFY batteryChanged)

public:
    explicit SystemInfoController(QObject *parent = nullptr);

    QString osName() const { return m_osName; }
    QString kernelVersion() const { return m_kernelVersion; }
    QString compositor() const { return m_compositor; }
    QString cpuModel() const { return m_cpuModel; }
    QString totalMemory() const { return m_totalMemory; }
    QString hostname() const { return m_hostname; }

    QString batteryStatus() const { return m_batteryStatus; }
    int batteryPercent() const { return m_batteryPercent; }
    bool hasBattery() const { return m_hasBattery; }

signals:
    void batteryChanged();

private:
    void readSystemSpecs();
    void readBattery();

    QString m_osName = "Arch Linux";
    QString m_kernelVersion;
    QString m_compositor = "Hyprland (Wayland)";
    QString m_cpuModel;
    QString m_totalMemory;
    QString m_hostname;

    QString m_batteryStatus = "AC Power";
    int m_batteryPercent = 100;
    bool m_hasBattery = false;
};

#endif // SYSTEMINFOCONTROLLER_HPP
