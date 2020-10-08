//
//  DetailWeatherResponse.swift
//  WeatherApp
//
//  Created by Lara Poveda on 07/10/2020.
//

import Foundation

struct DetailWeatherResponse: Codable {
    
    var daily: [DailyForecastResponse]
    var current: CurrentForecastResponse
    var lat: Double
    var lon: Double
}

struct CurrentForecastResponse: Codable {
    var dt: Int
    var temp: Double
    var weather: [WeatherDataResponse]
    
}

struct DailyForecastResponse: Codable {
    var weather: [WeatherDataResponse]
    var temp: TempDataResponse
    var dt: Int
    
}

struct TempDataResponse: Codable {
    var min: Double
    var max: Double
}
