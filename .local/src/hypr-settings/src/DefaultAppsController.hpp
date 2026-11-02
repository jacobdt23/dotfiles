#ifndef DEFAULTAPPSCONTROLLER_HPP
#define DEFAULTAPPSCONTROLLER_HPP

#include <QObject>
#include <QStringList>

class DefaultAppsController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString browser READ browser WRITE setBrowser NOTIFY browserChanged)
    Q_PROPERTY(QString fileManager READ fileManager WRITE setFileManager NOTIFY fileManagerChanged)
    Q_PROPERTY(QString terminal READ terminal CONSTANT)

public:
    explicit DefaultAppsController(QObject *parent = nullptr);

    QString browser() const { return m_browser; }
    void setBrowser(const QString &b);

    QString fileManager() const { return m_fileManager; }
    void setFileManager(const QString &fm);

    QString terminal() const { return "kitty"; }

signals:
    void browserChanged();
    void fileManagerChanged();

private:
    void loadDefaults();
    QString m_browser = "firefox.desktop";
    QString m_fileManager = "thunar.desktop";
};

#endif // DEFAULTAPPSCONTROLLER_HPP
