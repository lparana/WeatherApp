//
//  CurrentWeatherResponseModel.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation

struct CurrentWeatherResponseModel: Codable {
    var name: String
    var id: Int
    var weather: [WeatherDataResponse]
    var main: MainWeatherInfoResponse
    var coord: Coordinates
}
