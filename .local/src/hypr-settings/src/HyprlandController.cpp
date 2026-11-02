#include "HyprlandController.hpp"
#include <QProcess>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>
#include <QDir>

HyprlandController::HyprlandController(QObject *parent)
    : QObject(parent)
{
    refreshMonitors();
    loadCurrentOptions();
    loadPowerProfile();
    loadShortcuts();
}

void HyprlandController::setKeyword(const QString &opt, const QString &val)
{
    QProcess::startDetached("hyprctl", {"keyword", opt, val});
}

QString HyprlandController::getOption(const QString &opt)
{
    QProcess proc;
    proc.start("hyprctl", {"getoption", opt, "-j"});
    if (!proc.waitForFinished(1000)) return "";
    QJsonDocument doc = QJsonDocument::fromJson(proc.readAllStandardOutput());
    if (doc.isObject()) {
        QJsonObject obj = doc.object();
        if (obj.contains("int")) return QString::number(obj["int"].toInt());
        if (obj.contains("float")) return QString::number(obj["float"].toDouble());
        if (obj.contains("str")) return obj["str"].toString();
        if (obj.contains("custom")) return obj["custom"].toString();
    }
    return "";
}

void HyprlandController::loadCurrentOptions()
{
    bool ok = false;
    int gi = getOption("general:gaps_in").split(' ').first().toInt(&ok);
    if (ok) m_gapsIn = gi;

    int go = getOption("general:gaps_out").split(' ').first().toInt(&ok);
    if (ok) m_gapsOut = go;

    int bs = getOption("general:border_size").toInt(&ok);
    if (ok) m_borderSize = bs;

    int r = getOption("decoration:rounding").toInt(&ok);
    if (ok) m_rounding = r;

    QString blur = getOption("decoration:blur:enabled");
    m_blurEnabled = (blur == "1" || blur.toLower() == "true");

    QString shadow = getOption("decoration:shadow:enabled");
    m_shadowEnabled = (shadow == "1" || shadow.toLower() == "true");

    QString anim = getOption("animations:enabled");
    m_animationsEnabled = (anim == "1" || anim.toLower() == "true");

    double ao = getOption("decoration:active_opacity").toDouble(&ok);
    if (ok && ao > 0) m_activeOpacity = ao;

    double io = getOption("decoration:inactive_opacity").toDouble(&ok);
    if (ok && io > 0) m_inactiveOpacity = io;

    double sens = getOption("input:sensitivity").toDouble(&ok);
    if (ok) m_mouseSensitivity = sens;

    QString nat = getOption("input:touchpad:natural_scroll");
    m_naturalScroll = (nat == "1" || nat.toLower() == "true");

    QString tap = getOption("input:touchpad:tap-to-click");
    m_tapToClick = (tap == "1" || tap.toLower() == "true");

    int rr = getOption("input:repeat_rate").toInt(&ok);
    if (ok && rr > 0) m_repeatRate = rr;
}

void HyprlandController::loadPowerProfile()
{
    QProcess proc;
    proc.start("powerprofilesctl", {"get"});
    if (proc.waitForFinished(1000)) {
        QString s = QString::fromUtf8(proc.readAllStandardOutput()).trimmed();
        if (!s.isEmpty()) m_powerProfile = s;
    }
}

void HyprlandController::loadShortcuts()
{
    m_shortcuts.clear();
    QFile file(QDir::homePath() + "/.config/hypr/modules/binds.lua");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (line.startsWith("hl.bind(")) {
                // Parse key and action
                QString content = line.section("hl.bind(", 1).section(")", 0, -2);
                QString key = content.section(',', 0, 0).remove('"').remove('\'').trimmed();
                QString action = content.section(',', 1).trimmed();

                key.replace("mainMod", "SUPER");

                QVariantMap item;
                item["key"] = key;
                item["action"] = action;
                m_shortcuts.append(item);
            }
        }
    }
}

void HyprlandController::refreshMonitors()
{
    QProcess proc;
    proc.start("hyprctl", {"monitors", "-j"});
    if (!proc.waitForFinished(1500)) return;

    QJsonDocument doc = QJsonDocument::fromJson(proc.readAllStandardOutput());
    if (!doc.isArray()) return;

    QVariantList list;
    for (const auto &val : doc.array()) {
        list.append(val.toObject().toVariantMap());
    }
    m_monitors = list;
    emit monitorsChanged();
}

void HyprlandController::setMonitorScale(const QString &name, double scale)
{
    QString arg = QString("%1,preferred,auto,%2").arg(name, QString::number(scale, 'f', 2));
    QProcess::execute("hyprctl", {"keyword", "monitor", arg});
    refreshMonitors();
}

void HyprlandController::setGapsIn(int v) {
    if (m_gapsIn == v) return;
    m_gapsIn = v;
    emit gapsInChanged();
    setKeyword("general:gaps_in", QString::number(v));
}

void HyprlandController::setGapsOut(int v) {
    if (m_gapsOut == v) return;
    m_gapsOut = v;
    emit gapsOutChanged();
    setKeyword("general:gaps_out", QString::number(v));
}

void HyprlandController::setBorderSize(int v) {
    if (m_borderSize == v) return;
    m_borderSize = v;
    emit borderSizeChanged();
    setKeyword("general:border_size", QString::number(v));
}

void HyprlandController::setRounding(int v) {
    if (m_rounding == v) return;
    m_rounding = v;
    emit roundingChanged();
    setKeyword("decoration:rounding", QString::number(v));
}

void HyprlandController::setBlurEnabled(bool v) {
    if (m_blurEnabled == v) return;
    m_blurEnabled = v;
    emit blurEnabledChanged();
    setKeyword("decoration:blur:enabled", v ? "true" : "false");
}

void HyprlandController::setShadowEnabled(bool v) {
    if (m_shadowEnabled == v) return;
    m_shadowEnabled = v;
    emit shadowEnabledChanged();
    setKeyword("decoration:shadow:enabled", v ? "true" : "false");
}

void HyprlandController::setAnimationsEnabled(bool v) {
    if (m_animationsEnabled == v) return;
    m_animationsEnabled = v;
    emit animationsEnabledChanged();
    setKeyword("animations:enabled", v ? "true" : "false");
}

void HyprlandController::setActiveOpacity(double v) {
    if (qFuzzyCompare(m_activeOpacity, v)) return;
    m_activeOpacity = v;
    emit activeOpacityChanged();
    setKeyword("decoration:active_opacity", QString::number(v, 'f', 2));
}

void HyprlandController::setInactiveOpacity(double v) {
    if (qFuzzyCompare(m_inactiveOpacity, v)) return;
    m_inactiveOpacity = v;
    emit inactiveOpacityChanged();
    setKeyword("decoration:inactive_opacity", QString::number(v, 'f', 2));
}

void HyprlandController::setMouseSensitivity(double v) {
    if (qFuzzyCompare(m_mouseSensitivity, v)) return;
    m_mouseSensitivity = v;
    emit mouseSensitivityChanged();
    setKeyword("input:sensitivity", QString::number(v, 'f', 2));
}

void HyprlandController::setNaturalScroll(bool v) {
    if (m_naturalScroll == v) return;
    m_naturalScroll = v;
    emit naturalScrollChanged();
    setKeyword("input:touchpad:natural_scroll", v ? "true" : "false");
}

void HyprlandController::setTapToClick(bool v) {
    if (m_tapToClick == v) return;
    m_tapToClick = v;
    emit tapToClickChanged();
    setKeyword("input:touchpad:tap-to-click", v ? "true" : "false");
}

void HyprlandController::setRepeatRate(int v) {
    if (m_repeatRate == v) return;
    m_repeatRate = v;
    emit repeatRateChanged();
    setKeyword("input:repeat_rate", QString::number(v));
}

void HyprlandController::setPowerProfile(const QString &profile) {
    if (m_powerProfile == profile || profile.isEmpty()) return;
    m_powerProfile = profile;
    emit powerProfileChanged();
    QProcess::startDetached("powerprofilesctl", {"set", profile});
}

void HyprlandController::applyDefaults() {
    setGapsIn(5);
    setGapsOut(10);
    setBorderSize(2);
    setRounding(10);
    setBlurEnabled(true);
    setShadowEnabled(true);
    setActiveOpacity(1.0);
    setInactiveOpacity(0.9);
    setAnimationsEnabled(true);
    setMouseSensitivity(0.0);
    setNaturalScroll(false);
    setTapToClick(true);
}
