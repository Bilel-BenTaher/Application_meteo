#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "weatherdata.h"
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("qrc:/images/images/Logo_Weather.png"));

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    // Enregistrer la classe WeatherData pour QML
    qmlRegisterType<WeatherData>("com.example.meteo", 1, 0, "WeatherData");
    engine.loadFromModule("Application_meteo", "Main");

    return app.exec();
}
