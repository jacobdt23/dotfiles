#ifndef AUDIOCONTROLLER_HPP
#define AUDIOCONTROLLER_HPP

#include <QObject>
#include <QTimer>

class AudioController : public QObject {
    Q_OBJECT
    Q_PROPERTY(int outputVolume READ outputVolume WRITE setOutputVolume NOTIFY outputVolumeChanged)
    Q_PROPERTY(bool outputMuted READ isOutputMuted WRITE setOutputMuted NOTIFY outputMutedChanged)
    Q_PROPERTY(int inputVolume READ inputVolume WRITE setInputVolume NOTIFY inputVolumeChanged)
    Q_PROPERTY(bool inputMuted READ isInputMuted WRITE setInputMuted NOTIFY inputMutedChanged)

public:
    explicit AudioController(QObject *parent = nullptr);

    int outputVolume() const { return m_outputVolume; }
    void setOutputVolume(int vol);

    bool isOutputMuted() const { return m_outputMuted; }
    void setOutputMuted(bool muted);

    int inputVolume() const { return m_inputVolume; }
    void setInputVolume(int vol);

    bool isInputMuted() const { return m_inputMuted; }
    void setInputMuted(bool muted);

    Q_INVOKABLE void playTestSound();

signals:
    void outputVolumeChanged();
    void outputMutedChanged();
    void inputVolumeChanged();
    void inputMutedChanged();

public slots:
    void refresh();

private:
    int m_outputVolume = 50;
    bool m_outputMuted = false;
    int m_inputVolume = 50;
    bool m_inputMuted = false;
    QTimer m_timer;
};

#endif // AUDIOCONTROLLER_HPP
