#include "DefaultAppsController.hpp"
#include <QProcess>

DefaultAppsController::DefaultAppsController(QObject *parent)
    : QObject(parent)
{
    loadDefaults();
}

void DefaultAppsController::loadDefaults()
{
    QProcess p1;
    p1.start("xdg-settings", {"get", "default-web-browser"});
    if (p1.waitForFinished(1000)) {
        QString s = QString::fromUtf8(p1.readAllStandardOutput()).trimmed();
        if (!s.isEmpty()) m_browser = s;
    }

    QProcess p2;
    p2.start("xdg-mime", {"query", "default", "inode/directory"});
    if (p2.waitForFinished(1000)) {
        QString s = QString::fromUtf8(p2.readAllStandardOutput()).trimmed();
        if (!s.isEmpty()) m_fileManager = s;
    }
}

void DefaultAppsController::setBrowser(const QString &b)
{
    if (m_browser == b || b.isEmpty()) return;
    m_browser = b;
    emit browserChanged();
    QProcess::startDetached("xdg-settings", {"set", "default-web-browser", b});
}

void DefaultAppsController::setFileManager(const QString &fm)
{
    if (m_fileManager == fm || fm.isEmpty()) return;
    m_fileManager = fm;
    emit fileManagerChanged();
    QProcess::startDetached("xdg-mime", {"default", fm, "inode/directory"});
}
