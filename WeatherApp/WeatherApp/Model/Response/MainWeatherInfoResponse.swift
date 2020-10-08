//
//  MainWeatherInfoResponse.swift
//  WeatherApp
//
//  Created by Lara Poveda on 05/10/2020.
//

import Foundation

struct MainWeatherInfoResponse:Codable{
    var feels_like: Double
    var humidity: Int
    var pressure: Int
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}
