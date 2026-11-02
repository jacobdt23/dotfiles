#ifndef NETWORKCONTROLLER_HPP
#define NETWORKCONTROLLER_HPP

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QTimer>

class NetworkController : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool wifiEnabled READ isWifiEnabled NOTIFY wifiEnabledChanged)
    Q_PROPERTY(QString activeConnection READ activeConnection NOTIFY activeConnectionChanged)
    Q_PROPERTY(QVariantList networks READ networks NOTIFY networksChanged)

public:
    explicit NetworkController(QObject *parent = nullptr);

    bool isWifiEnabled() const { return m_wifiEnabled; }
    QString activeConnection() const { return m_activeConnection; }
    QVariantList networks() const { return m_networks; }

    Q_INVOKABLE void toggleWifi(bool on);
    Q_INVOKABLE void scanNetworks();
    Q_INVOKABLE void connectNetwork(const QString &ssid, const QString &password);
    Q_INVOKABLE void disconnectNetwork(const QString &ssid);

signals:
    void wifiEnabledChanged();
    void activeConnectionChanged();
    void networksChanged();

public slots:
    void refresh();

private:
    bool m_wifiEnabled = false;
    QString m_activeConnection = "Disconnected";
    QVariantList m_networks;
    QTimer m_timer;
};

#endif // NETWORKCONTROLLER_HPP
