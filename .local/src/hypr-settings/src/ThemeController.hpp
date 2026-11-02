#ifndef THEMECONTROLLER_HPP
#define THEMECONTROLLER_HPP

#include <QObject>
#include <QStringList>

class ThemeController : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isDarkMode READ isDarkMode WRITE setDarkMode NOTIFY darkModeChanged)
    Q_PROPERTY(QString gtkTheme READ gtkTheme WRITE setGtkTheme NOTIFY gtkThemeChanged)
    Q_PROPERTY(QString iconTheme READ iconTheme WRITE setIconTheme NOTIFY iconThemeChanged)
    Q_PROPERTY(double fontScaling READ fontScaling WRITE setFontScaling NOTIFY fontScalingChanged)
    Q_PROPERTY(QStringList availableGtkThemes READ availableGtkThemes CONSTANT)
    Q_PROPERTY(QStringList availableIconThemes READ availableIconThemes CONSTANT)
    Q_PROPERTY(QStringList availableWallpapers READ availableWallpapers NOTIFY wallpapersChanged)

public:
    explicit ThemeController(QObject *parent = nullptr);

    bool isDarkMode() const { return m_darkMode; }
    void setDarkMode(bool dark);

    QString gtkTheme() const { return m_gtkTheme; }
    void setGtkTheme(const QString &theme);

    QString iconTheme() const { return m_iconTheme; }
    void setIconTheme(const QString &icons);

    double fontScaling() const { return m_fontScaling; }
    void setFontScaling(double scale);

    QStringList availableGtkThemes() const { return m_availableGtkThemes; }
    QStringList availableIconThemes() const { return m_availableIconThemes; }
    QStringList availableWallpapers() const { return m_availableWallpapers; }

    Q_INVOKABLE void setWallpaper(const QString &path);
    Q_INVOKABLE void refreshWallpapers();

signals:
    void darkModeChanged();
    void gtkThemeChanged();
    void iconThemeChanged();
    void fontScalingChanged();
    void wallpapersChanged();

private:
    void loadGSettings();
    void scanInstalledThemes();

    bool m_darkMode = true;
    QString m_gtkTheme = "Tokyonight-Dark";
    QString m_iconTheme = "Papirus-Dark";
    double m_fontScaling = 1.0;

    QStringList m_availableGtkThemes;
    QStringList m_availableIconThemes;
    QStringList m_availableWallpapers;
};

#endif // THEMECONTROLLER_HPP
