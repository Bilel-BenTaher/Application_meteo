#ifndef WEATHERDATA_H
#define WEATHERDATA_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

class WeatherData : public QObject
{
    Q_OBJECT

    // Propriétés exposées à QML
    Q_PROPERTY(QString temperature READ temperature NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString windSpeed READ windSpeed NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString precipitation READ precipitation NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString description READ description NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString city READ city NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString country READ country NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString humidity READ humidity NOTIFY weatherDataUpdated)
    Q_PROPERTY(QString weatherLogo READ weatherLogo NOTIFY weatherDataUpdated)

public:
    explicit WeatherData(QObject *parent = nullptr);

    // Méthodes exposées à QML
    Q_INVOKABLE void getWeatherData(const QString &zipCode, const QString &countryCode);

    // Getters pour les propriétés
    QString temperature() const;
    QString windSpeed() const;
    QString precipitation() const;
    QString description() const;
    QString city() const;
    QString country() const;
    QString humidity() const;
    QString weatherLogo() const;

signals:
    void weatherDataUpdated(); // Signal émis lorsque les données météo sont mises à jour
    void cityNotFound();

private slots:
    void onWeatherDataReceived();

private:
    QNetworkAccessManager *manager;
    QNetworkReply *reply;

    // Données météo
    QString m_temperature;
    QString m_windSpeed;
    QString m_precipitation;
    QString m_description;
    QString m_city;
    QString m_country;
    QString m_humidity;
    QString m_weatherLogo;

    void updateWeatherLogo(int weatherConditionCode);
};

#endif // WEATHERDATA_H
