#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDir>

#include "BluetoothController.hpp"
#include "NetworkController.hpp"
#include "AudioController.hpp"
#include "HyprlandController.hpp"
#include "SystemInfoController.hpp"
#include "ThemeController.hpp"
#include "DefaultAppsController.hpp"

int main(int argc, char *argv[])
{
    if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")) {
        qputenv("QT_QPA_PLATFORM", "wayland;xcb");
    }

    QGuiApplication app(argc, argv);
    app.setApplicationName("System Settings");
    app.setOrganizationName("KDE-Hypr");
    app.setDesktopFileName("hypr-settings");
    app.setWindowIcon(QIcon::fromTheme("preferences-system"));

    BluetoothController bluetoothController;
    NetworkController networkController;
    AudioController audioController;
    HyprlandController hyprlandController;
    SystemInfoController systemInfoController;
    ThemeController themeController;
    DefaultAppsController defaultAppsController;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("bluetoothController", &bluetoothController);
    engine.rootContext()->setContextProperty("networkController", &networkController);
    engine.rootContext()->setContextProperty("audioController", &audioController);
    engine.rootContext()->setContextProperty("hyprlandController", &hyprlandController);
    engine.rootContext()->setContextProperty("systemInfoController", &systemInfoController);
    engine.rootContext()->setContextProperty("themeController", &themeController);
    engine.rootContext()->setContextProperty("defaultAppsController", &defaultAppsController);

    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
