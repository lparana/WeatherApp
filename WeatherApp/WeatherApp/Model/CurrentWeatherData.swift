//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Lara Poveda on 05/10/2020.
//

import Foundation

struct CurrentWeatherData: Codable {
    var id: Int
    var location: String
    var temperature: Double
    var icon: String
    var climate: String
    var weatherMain: String
    var coord: Coordinates
}
