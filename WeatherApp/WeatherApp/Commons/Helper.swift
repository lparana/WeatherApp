//
//  Helper.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation


class Helper {
    
    static func infoForKey(_ key: String) -> String? {
           return (Bundle.main.infoDictionary?[key] as? String)?
               .replacingOccurrences(of: "\\", with: "")
    }
    
    static func getIcon(main: String)-> String{
        let icon = [
            "Clear": "sun.max.fill",
            "Partly cloudy Moon": "cloud.moon.fill",
            "Partly cloudy": "cloud.sun.fill",
            "Clouds": "cloud.fill",
            "Overcast": "smoke.fill",
            "Snow": "cloud.snow.fill",
            "Drizzle":"cloud.drizzle.fill",
            "Thunderstorm":"cloud.bolt.rain.fill",
            "Rain": "cloud.rain.fill",
            "Mist": "cloud.fog.fill",
            "Haze": "cloud.fog.fill",
            "Fog": "cloud.fog.fill",
            "Smoke": "cloud.fog.fill",
            "Dust": "cloud.fog",
            "Sand": "cloud.fog",
            "Ash": "cloud.fog",
            "Squall": "cloud.rain.fill",
            "Tornado": "tornado"
            ]
        return icon[main] ?? "bolt.horizontal"
    }
    
}
