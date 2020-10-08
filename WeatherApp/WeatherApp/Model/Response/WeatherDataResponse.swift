//
//  WeatherDataResponse.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation

struct WeatherDataResponse: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
}
