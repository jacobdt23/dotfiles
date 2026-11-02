QT += core gui qml quick concurrent
CONFIG += c++17

TARGET = hypr-settings
TEMPLATE = app

SOURCES += \
    src/main.cpp \
    src/BluetoothController.cpp \
    src/NetworkController.cpp \
    src/AudioController.cpp \
    src/HyprlandController.cpp \
    src/SystemInfoController.cpp \
    src/ThemeController.cpp \
    src/DefaultAppsController.cpp

HEADERS += \
    src/BluetoothController.hpp \
    src/NetworkController.hpp \
    src/AudioController.hpp \
    src/HyprlandController.hpp \
    src/SystemInfoController.hpp \
    src/ThemeController.hpp \
    src/DefaultAppsController.hpp

RESOURCES += \
    qml.qrc
