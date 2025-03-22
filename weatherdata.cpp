#include "weatherdata.h"

WeatherData::WeatherData(QObject *parent) : QObject(parent), manager(new QNetworkAccessManager(this)), reply(nullptr) {}

void WeatherData::getWeatherData(const QString &zipCode, const QString &countryCode)
{
    QString apiKey = "ce5d8b703474d4f8995c888934e6c9ea"; // Remplacez par votre clé API
    QString url = QString("https://api.openweathermap.org/data/2.5/weather?zip=%1,%2&appid=%3")
                      .arg(zipCode)
                      .arg(countryCode)
                      .arg(apiKey);

    QNetworkRequest request((QUrl(url)));
    reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, &WeatherData::onWeatherDataReceived);
}

void WeatherData::onWeatherDataReceived()
{
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray responseData = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
        QJsonObject jsonObj = jsonDoc.object();

        // Extraction des données
        if (jsonObj.contains("main") && jsonObj["main"].isObject()) {
            m_temperature = QString::number(jsonObj["main"].toObject()["temp"].toDouble() - 273.15);
            m_humidity = QString::number(jsonObj["main"].toObject()["humidity"].toDouble());
        }

        if (jsonObj.contains("wind") && jsonObj["wind"].isObject()) {
            double windSpeedMps = jsonObj["wind"].toObject()["speed"].toDouble();
            double windSpeedKmph = windSpeedMps * 3.6; // Conversion en km/h
            m_windSpeed = QString::number(static_cast<int>(windSpeedKmph)); // Convertir en entier
        }

        if (jsonObj.contains("weather") && jsonObj["weather"].isArray()) {
            QJsonArray weatherArray = jsonObj["weather"].toArray();
            if (!weatherArray.isEmpty()) {
                m_description = weatherArray[0].toObject()["description"].toString();
                QString iconCode = weatherArray[0].toObject()["icon"].toString();
                m_weatherLogo = QString("https://openweathermap.org/img/wn/%1@2x.png").arg(iconCode);
            }
        }

        if (jsonObj.contains("name")) {
            m_city = jsonObj["name"].toString();
        }

        if (jsonObj.contains("sys") && jsonObj["sys"].isObject()) {
            m_country = jsonObj["sys"].toObject()["country"].toString();
        }

        // Extraction des précipitations (si disponibles)
        if (jsonObj.contains("rain") && jsonObj["rain"].isObject()) {
            m_precipitation = QString::number(jsonObj["rain"].toObject()["1h"].toDouble()); // Précipitations sur 1 heure en mm
        } else {
            m_precipitation = "0"; // Aucune précipitation
        }

        // Émission du signal pour mettre à jour l'interface QML
        emit weatherDataUpdated();
    } else {
        // Gestion des erreurs
        if (reply->error() == QNetworkReply::ContentNotFoundError) {
            emit cityNotFound(); // Émettre un signal spécifique pour une ville non trouvée
        } else {
            qDebug() << "Error:" << reply->errorString();
        }
    }

    reply->deleteLater();
}

// Getters pour les propriétés
QString WeatherData::temperature() const { return m_temperature; }
QString WeatherData::windSpeed() const { return m_windSpeed; }
QString WeatherData::precipitation() const { return m_precipitation; }
QString WeatherData::description() const { return m_description; }
QString WeatherData::city() const { return m_city; }
QString WeatherData::country() const { return m_country; }
QString WeatherData::humidity() const { return m_humidity; }
QString WeatherData::weatherLogo() const { return m_weatherLogo; }
