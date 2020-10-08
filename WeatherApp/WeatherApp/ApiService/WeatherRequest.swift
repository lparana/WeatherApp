//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Lara Poveda on 07/10/2020.
//

import Foundation

struct WeatherRequest: APIRequest{
    var headers: [String : String]?
    
    var relativePath: String = "onecall"
    
    var baseURLString: String
    
    var method: HTTPMethod = .get
    
    var parameters: [String : Any]?
      
    init(baseURl: String, apiKey: String, latitude: Double, longitude: Double ) {
        self.baseURLString = baseURl
        self.parameters = ["lat": String(latitude), "lon": String(longitude), "appid": apiKey, "exclude": "minutely,hourly,alerts", "units": "metric"]
        
    }
}
