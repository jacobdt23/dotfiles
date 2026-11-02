#include "AudioController.hpp"
#include <QProcess>

AudioController::AudioController(QObject *parent)
    : QObject(parent)
{
    connect(&m_timer, &QTimer::timeout, this, &AudioController::refresh);
    m_timer.start(4000);
    refresh();
}

void AudioController::refresh()
{
    // Output
    QProcess outProc;
    outProc.start("wpctl", {"get-volume", "@DEFAULT_AUDIO_SINK@"});
    if (outProc.waitForFinished(1000)) {
        QString s = QString::fromUtf8(outProc.readAllStandardOutput());
        QStringList parts = s.split(' ', Qt::SkipEmptyParts);
        if (parts.size() >= 2) {
            int vol = static_cast<int>(parts.at(1).toDouble() * 100);
            if (m_outputVolume != vol) {
                m_outputVolume = vol;
                emit outputVolumeChanged();
            }
        }
        bool muted = s.contains("[MUTED]");
        if (m_outputMuted != muted) {
            m_outputMuted = muted;
            emit outputMutedChanged();
        }
    }

    // Input
    QProcess inProc;
    inProc.start("wpctl", {"get-volume", "@DEFAULT_AUDIO_SOURCE@"});
    if (inProc.waitForFinished(1000)) {
        QString s = QString::fromUtf8(inProc.readAllStandardOutput());
        QStringList parts = s.split(' ', Qt::SkipEmptyParts);
        if (parts.size() >= 2) {
            int vol = static_cast<int>(parts.at(1).toDouble() * 100);
            if (m_inputVolume != vol) {
                m_inputVolume = vol;
                emit inputVolumeChanged();
            }
        }
        bool muted = s.contains("[MUTED]");
        if (m_inputMuted != muted) {
            m_inputMuted = muted;
            emit inputMutedChanged();
        }
    }
}

void AudioController::setOutputVolume(int vol)
{
    if (m_outputVolume == vol) return;
    m_outputVolume = vol;
    emit outputVolumeChanged();

    double v = vol / 100.0;
    QProcess::startDetached("wpctl", {"set-volume", "@DEFAULT_AUDIO_SINK@", QString::number(v, 'f', 2)});
}

void AudioController::setOutputMuted(bool muted)
{
    if (m_outputMuted == muted) return;
    m_outputMuted = muted;
    emit outputMutedChanged();

    QProcess::startDetached("wpctl", {"set-mute", "@DEFAULT_AUDIO_SINK@", muted ? "1" : "0"});
}

void AudioController::setInputVolume(int vol)
{
    if (m_inputVolume == vol) return;
    m_inputVolume = vol;
    emit inputVolumeChanged();

    double v = vol / 100.0;
    QProcess::startDetached("wpctl", {"set-volume", "@DEFAULT_AUDIO_SOURCE@", QString::number(v, 'f', 2)});
}

void AudioController::setInputMuted(bool muted)
{
    if (m_inputMuted == muted) return;
    m_inputMuted = muted;
    emit inputMutedChanged();

    QProcess::startDetached("wpctl", {"set-mute", "@DEFAULT_AUDIO_SOURCE@", muted ? "1" : "0"});
}

void AudioController::playTestSound()
{
    QProcess::startDetached("pw-play", {"/usr/share/sounds/freedesktop/stereo/complete.oga"});
}
