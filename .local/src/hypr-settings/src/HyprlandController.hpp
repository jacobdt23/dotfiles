#ifndef HYPRLANDCONTROLLER_HPP
#define HYPRLANDCONTROLLER_HPP

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class HyprlandController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList monitors READ monitors NOTIFY monitorsChanged)
    Q_PROPERTY(int gapsIn READ gapsIn WRITE setGapsIn NOTIFY gapsInChanged)
    Q_PROPERTY(int gapsOut READ gapsOut WRITE setGapsOut NOTIFY gapsOutChanged)
    Q_PROPERTY(int borderSize READ borderSize WRITE setBorderSize NOTIFY borderSizeChanged)
    Q_PROPERTY(int rounding READ rounding WRITE setRounding NOTIFY roundingChanged)
    Q_PROPERTY(bool blurEnabled READ blurEnabled WRITE setBlurEnabled NOTIFY blurEnabledChanged)
    Q_PROPERTY(bool shadowEnabled READ shadowEnabled WRITE setShadowEnabled NOTIFY shadowEnabledChanged)
    Q_PROPERTY(bool animationsEnabled READ animationsEnabled WRITE setAnimationsEnabled NOTIFY animationsEnabledChanged)
    Q_PROPERTY(double activeOpacity READ activeOpacity WRITE setActiveOpacity NOTIFY activeOpacityChanged)
    Q_PROPERTY(double inactiveOpacity READ inactiveOpacity WRITE setInactiveOpacity NOTIFY inactiveOpacityChanged)

    // Input settings
    Q_PROPERTY(double mouseSensitivity READ mouseSensitivity WRITE setMouseSensitivity NOTIFY mouseSensitivityChanged)
    Q_PROPERTY(bool naturalScroll READ naturalScroll WRITE setNaturalScroll NOTIFY naturalScrollChanged)
    Q_PROPERTY(bool tapToClick READ tapToClick WRITE setTapToClick NOTIFY tapToClickChanged)
    Q_PROPERTY(int repeatRate READ repeatRate WRITE setRepeatRate NOTIFY repeatRateChanged)

    // Power Profile
    Q_PROPERTY(QString powerProfile READ powerProfile WRITE setPowerProfile NOTIFY powerProfileChanged)

    // Keybindings
    Q_PROPERTY(QVariantList shortcuts READ shortcuts CONSTANT)

public:
    explicit HyprlandController(QObject *parent = nullptr);

    QVariantList monitors() const { return m_monitors; }
    int gapsIn() const { return m_gapsIn; }
    void setGapsIn(int v);

    int gapsOut() const { return m_gapsOut; }
    void setGapsOut(int v);

    int borderSize() const { return m_borderSize; }
    void setBorderSize(int v);

    int rounding() const { return m_rounding; }
    void setRounding(int v);

    bool blurEnabled() const { return m_blurEnabled; }
    void setBlurEnabled(bool v);

    bool shadowEnabled() const { return m_shadowEnabled; }
    void setShadowEnabled(bool v);

    bool animationsEnabled() const { return m_animationsEnabled; }
    void setAnimationsEnabled(bool v);

    double activeOpacity() const { return m_activeOpacity; }
    void setActiveOpacity(double v);

    double inactiveOpacity() const { return m_inactiveOpacity; }
    void setInactiveOpacity(double v);

    double mouseSensitivity() const { return m_mouseSensitivity; }
    void setMouseSensitivity(double v);

    bool naturalScroll() const { return m_naturalScroll; }
    void setNaturalScroll(bool v);

    bool tapToClick() const { return m_tapToClick; }
    void setTapToClick(bool v);

    int repeatRate() const { return m_repeatRate; }
    void setRepeatRate(int v);

    QString powerProfile() const { return m_powerProfile; }
    void setPowerProfile(const QString &profile);

    QVariantList shortcuts() const { return m_shortcuts; }

    Q_INVOKABLE void refreshMonitors();
    Q_INVOKABLE void setMonitorScale(const QString &name, double scale);
    Q_INVOKABLE void applyDefaults();

signals:
    void monitorsChanged();
    void gapsInChanged();
    void gapsOutChanged();
    void borderSizeChanged();
    void roundingChanged();
    void blurEnabledChanged();
    void shadowEnabledChanged();
    void animationsEnabledChanged();
    void activeOpacityChanged();
    void inactiveOpacityChanged();
    void mouseSensitivityChanged();
    void naturalScrollChanged();
    void tapToClickChanged();
    void repeatRateChanged();
    void powerProfileChanged();

private:
    void loadCurrentOptions();
    void loadPowerProfile();
    void loadShortcuts();
    void setKeyword(const QString &opt, const QString &val);
    QString getOption(const QString &opt);

    QVariantList m_monitors;
    int m_gapsIn = 5;
    int m_gapsOut = 10;
    int m_borderSize = 2;
    int m_rounding = 10;
    bool m_blurEnabled = true;
    bool m_shadowEnabled = true;
    bool m_animationsEnabled = true;
    double m_activeOpacity = 1.0;
    double m_inactiveOpacity = 0.9;

    double m_mouseSensitivity = 0.0;
    bool m_naturalScroll = false;
    bool m_tapToClick = true;
    int m_repeatRate = 25;

    QString m_powerProfile = "balanced";
    QVariantList m_shortcuts;
};

#endif // HYPRLANDCONTROLLER_HPP
