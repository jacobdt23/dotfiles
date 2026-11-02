#ifndef BLUETOOTHCONTROLLER_HPP
#define BLUETOOTHCONTROLLER_HPP

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QTimer>
#include <QProcess>

class BluetoothController : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool enabled READ isEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool discoverable READ isDiscoverable NOTIFY discoverableChanged)
    Q_PROPERTY(bool scanning READ isScanning NOTIFY scanningChanged)
    Q_PROPERTY(QString adapterName READ adapterName NOTIFY adapterNameChanged)
    Q_PROPERTY(QVariantList pairedDevices READ pairedDevices NOTIFY pairedDevicesChanged)
    Q_PROPERTY(QVariantList nearbyDevices READ nearbyDevices NOTIFY nearbyDevicesChanged)

public:
    explicit BluetoothController(QObject *parent = nullptr);

    bool isEnabled() const { return m_enabled; }
    bool isDiscoverable() const { return m_discoverable; }
    bool isScanning() const { return m_scanning; }
    QString adapterName() const { return m_adapterName; }
    QVariantList pairedDevices() const { return m_pairedDevices; }
    QVariantList nearbyDevices() const { return m_nearbyDevices; }

    Q_INVOKABLE void togglePower(bool on);
    Q_INVOKABLE void toggleDiscoverable(bool on);
    Q_INVOKABLE void startScan();
    Q_INVOKABLE void stopScan();
    Q_INVOKABLE void connectDevice(const QString &mac);
    Q_INVOKABLE void disconnectDevice(const QString &mac);
    Q_INVOKABLE void removeDevice(const QString &mac);
    Q_INVOKABLE void pairDevice(const QString &mac);
    Q_INVOKABLE void refresh();

signals:
    void enabledChanged();
    void discoverableChanged();
    void scanningChanged();
    void adapterNameChanged();
    void pairedDevicesChanged();
    void nearbyDevicesChanged();

private slots:
    void onScanProcessOutput();
    void onScanFinished();

private:
    void parseAdapterInfo();
    void parsePairedDevices();

    bool m_enabled = false;
    bool m_discoverable = false;
    bool m_scanning = false;
    QString m_adapterName = "Bluetooth Adapter";
    QVariantList m_pairedDevices;
    QVariantList m_nearbyDevices;

    QTimer m_pollTimer;
    QProcess *m_scanProcess = nullptr;
};

#endif // BLUETOOTHCONTROLLER_HPP
