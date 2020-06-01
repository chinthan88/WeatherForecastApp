//
//  WeatherViewModel.swift
//  WeatherForecastApp
//
//  Created by Chinthan on 01/06/20.
//  Copyright © 2020 Chinthan. All rights reserved.
//

import UIKit

struct WeatherViewModel {
    
    // MARK: - Constants
   private let emptyString = ""
    
    // MARK: - Properties
    let isFetchingCompleted: Bind<Bool>
    let hasError: Bind<Bool>
    var errorMessage: Bind<String>
    var currentWeather: Bind<WeatherInfo>
    let forecasts: Bind<[WeatherInfo]>
    
    // MARK: - init
    init() {
        isFetchingCompleted = Bind(false)
        hasError = Bind(true)
        errorMessage = Bind("")
        currentWeather = Bind(WeatherInfo(dateTime: emptyString, description: emptyString, currentTemperature: emptyString, maxTemperature: emptyString, minTemperature: emptyString, humidity: emptyString, windSpeed: emptyString, dayName: emptyString, icon: emptyString))
        forecasts = Bind([])
    }
    
    func fetchWeatherInfo(location: String) {
        let network: NetworkManager = NetworkManager()
        network.getWeatherData(location: location) { (weather, error) -> Void in
            if let weatherDetail = weather {
                self.updateWeather(weatherDetail)
            }
            if let error = error {
                self.updateError(error)
            }
        }
    }
        
    // MARK: - private
    private func updateWeather(_ current: WeatherDetail) -> WeatherInfo {

        var currentInfo: WeatherInfo = WeatherInfo(dateTime: "", description: current.description.capitalized, currentTemperature: "\(current.currentTemperature) °C", maxTemperature: "\(current.maxTemperature) °C", minTemperature: "\(current.minTemperature) °C", humidity: "\(current.humidity) %", windSpeed: "\(current.windSpeed) meter/sec", dayName: DateUtility(date: current.dateTime).getWeekdayName, icon: current.icon)
        currentInfo.currentTemperature = "\(Int(round(current.currentTemperature)))°C"
        currentInfo.maxTemperature = "\(Int(round(current.maxTemperature)))°C"
        currentInfo.minTemperature = "\(Int(round(current.minTemperature)))°C"

        return currentInfo
    }
    
    private func updateWeather(_ weather: Weather) {        
        guard let currentWeather = weather.weatherDetails.first else {
            updateError(DataManagerError.noData)
            return
        }
        
        self.currentWeather.value = updateWeather(currentWeather)
        constructForecastDataModel(fromWeatherDetails: Array(weather.weatherDetails.dropFirst()))
        hasError.value = false
        isFetchingCompleted.value = true
    }
    
    
    private func updateError(_ error: DataManagerError) {
        hasError.value = true
        switch error {
        case .invalidURL, .requestParameterError:
            errorMessage.value = "The weather service is not working."
        case .networkRequestFailed, .noData:
            errorMessage.value = "The network appears to be down."
        case .unknown(let errorMsg):
            errorMessage.value = errorMsg
        case .failedRequest:
            errorMessage.value = "City not found"
        case .invalidResponse:
            errorMessage.value = "Something went wrong"
        }
        
        self.forecasts.value = []
        isFetchingCompleted.value = false
        hasError.value = true
    }
    
    private func constructForecastDataModel(fromWeatherDetails weatherDetails: [WeatherDetail]) {
        if (weatherDetails.count > 0) {
            var forecastList = [WeatherInfo]()
            for forecast in weatherDetails {
                let weatherInfo = updateWeather(forecast)
                forecastList.append(weatherInfo)
            }
            self.forecasts.value = forecastList

        } else {
            self.forecasts.value = []
        }
    }
}

