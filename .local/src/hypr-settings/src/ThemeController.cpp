#include "ThemeController.hpp"
#include <QProcess>
#include <QDir>
#include <QStandardPaths>

ThemeController::ThemeController(QObject *parent)
    : QObject(parent)
{
    loadGSettings();
    scanInstalledThemes();
    refreshWallpapers();
}

void ThemeController::loadGSettings()
{
    QProcess p1;
    p1.start("gsettings", {"get", "org.gnome.desktop.interface", "color-scheme"});
    if (p1.waitForFinished(1000)) {
        QString s = QString::fromUtf8(p1.readAllStandardOutput()).trimmed().remove('\'');
        m_darkMode = (s == "prefer-dark");
    }

    QProcess p2;
    p2.start("gsettings", {"get", "org.gnome.desktop.interface", "gtk-theme"});
    if (p2.waitForFinished(1000)) {
        m_gtkTheme = QString::fromUtf8(p2.readAllStandardOutput()).trimmed().remove('\'');
    }

    QProcess p3;
    p3.start("gsettings", {"get", "org.gnome.desktop.interface", "icon-theme"});
    if (p3.waitForFinished(1000)) {
        m_iconTheme = QString::fromUtf8(p3.readAllStandardOutput()).trimmed().remove('\'');
    }

    QProcess p4;
    p4.start("gsettings", {"get", "org.gnome.desktop.interface", "text-scaling-factor"});
    if (p4.waitForFinished(1000)) {
        bool ok = false;
        double f = QString::fromUtf8(p4.readAllStandardOutput()).trimmed().toDouble(&ok);
        if (ok && f > 0.5) m_fontScaling = f;
    }
}

void ThemeController::scanInstalledThemes()
{
    QStringList gtkDirs = {"/usr/share/themes", QDir::homePath() + "/.themes"};
    for (const QString &d : gtkDirs) {
        QDir dir(d);
        for (const QString &sub : dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            if (!m_availableGtkThemes.contains(sub)) {
                m_availableGtkThemes.append(sub);
            }
        }
    }

    QStringList iconDirs = {"/usr/share/icons", QDir::homePath() + "/.local/share/icons"};
    for (const QString &d : iconDirs) {
        QDir dir(d);
        for (const QString &sub : dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            if (!sub.startsWith("default") && !sub.startsWith("hicolor") && !m_availableIconThemes.contains(sub)) {
                m_availableIconThemes.append(sub);
            }
        }
    }
}

void ThemeController::refreshWallpapers()
{
    m_availableWallpapers.clear();
    QDir wpDir(QDir::homePath() + "/Pictures/Wallpapers");
    for (const QString &f : wpDir.entryList({"*.png", "*.jpg", "*.jpeg", "*.webp"}, QDir::Files)) {
        m_availableWallpapers.append(wpDir.filePath(f));
    }
    emit wallpapersChanged();
}

void ThemeController::setDarkMode(bool dark)
{
    if (m_darkMode == dark) return;
    m_darkMode = dark;
    emit darkModeChanged();

    QString val = dark ? "prefer-dark" : "default";
    QProcess::startDetached("gsettings", {"set", "org.gnome.desktop.interface", "color-scheme", val});
}

void ThemeController::setGtkTheme(const QString &theme)
{
    if (m_gtkTheme == theme || theme.isEmpty()) return;
    m_gtkTheme = theme;
    emit gtkThemeChanged();

    QProcess::startDetached("gsettings", {"set", "org.gnome.desktop.interface", "gtk-theme", theme});
}

void ThemeController::setIconTheme(const QString &icons)
{
    if (m_iconTheme == icons || icons.isEmpty()) return;
    m_iconTheme = icons;
    emit iconThemeChanged();

    QProcess::startDetached("gsettings", {"set", "org.gnome.desktop.interface", "icon-theme", icons});
}

void ThemeController::setFontScaling(double scale)
{
    if (qFuzzyCompare(m_fontScaling, scale)) return;
    m_fontScaling = scale;
    emit fontScalingChanged();

    QProcess::startDetached("gsettings", {"set", "org.gnome.desktop.interface", "text-scaling-factor", QString::number(scale, 'f', 2)});
}

void ThemeController::setWallpaper(const QString &path)
{
    QProcess::startDetached("awww", {"img", path});
}
