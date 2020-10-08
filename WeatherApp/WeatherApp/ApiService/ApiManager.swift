//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    let baseURL = Helper.infoForKey("baseURL")!
    private let session = URLSession(configuration: .default)
    let apiKey = Helper.infoForKey("ApiKey")!
    
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherResponseModel, Error>)-> Void){
        let currentWeatherRequest = CurentWeatherRequest(baseURl: baseURL, apiKey: apiKey, latitude: latitude, longitude: longitude)
        self.apiRequest(request: currentWeatherRequest, completion: completion)
    }
    
    func getWeatherInfo(latitude: Double, longitude: Double, completion: @escaping (Result<DetailWeatherResponse, Error>)-> Void){
    
        let weatherRequest = WeatherRequest(baseURl: baseURL, apiKey: apiKey, latitude: latitude, longitude: longitude)
        self.apiRequest(request: weatherRequest, completion: completion)
    }
    
    func apiRequest<T: Decodable, I: APIRequest>(request: I, completion: @escaping (Result<T, Error>)-> Void){
        let task = session.dataTask(with: request.urlRequest!) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                
                let code = (response as! HTTPURLResponse).statusCode
                if(code == 200){
                    do {
                        let decodeResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodeResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }else{
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                        completion(.failure(ApiError.Other))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}

enum ApiError: Error {
    case Other
}
