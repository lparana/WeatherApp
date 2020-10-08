//
//  DetailWeatherViewModel.swift
//  WeatherApp
//
//  Created by Lara Poveda on 06/10/2020.
//

import Foundation

class DetailWeatherViewModel{
    
    var isFavorite: Bool?
    var detailWeatherDelegate: DetailWeatherDelegate?
    var cityName: String?
    var id: Int?
    var coordinates: Coordinates?
    var currentWeather: CurrentWeatherData?
    var forecast: [DailyWeatherInfo]?
    

    init(cityName: String,id: Int, cityCoord: Coordinates, isFavorite: Bool){
        self.cityName = cityName
        self.id = id
        self.coordinates = cityCoord
        self.isFavorite = isFavorite
    }
    
    func removeFavoriteCity(){
        self.isFavorite = false
        CoreDataStorage.shared.removeCity(id: self.id!)
    }
    
    func addFavoriteCity(){
        self.isFavorite = true
        
        let newCity = FavoritePlace(id: self.currentWeather!.id, name: self.currentWeather!.location, coord: self.currentWeather!.coord)
        CoreDataStorage.shared.addCity(favCity: newCity)
        
    }
    
    func getDetailWeather(in coord: Coordinates?){
        let coord = coord ?? self.coordinates!
        ApiManager.shared.getWeatherInfo(latitude: coord.lat, longitude: coord.lon) { (result) in
        
            switch result{
            case .success(let detailWeatherInfo):
                self.currentWeather = CurrentWeatherData(id: self.id!, location: self.cityName!,
                    temperature: detailWeatherInfo.current.temp,
                    icon: Helper.getIcon(main: detailWeatherInfo.current.weather.first!.main),
                    climate: detailWeatherInfo.current.weather.first!.description,
                    weatherMain: detailWeatherInfo.current.weather.first!.main,
                    coord: Coordinates(lat: detailWeatherInfo.lat, lon: detailWeatherInfo.lon))
                
                self.forecast = detailWeatherInfo.daily.map { (dailyForecast) -> DailyWeatherInfo in
                    return DailyWeatherInfo(
                        date: self.getDateFormatted(timestamp: dailyForecast.dt),
                        prediction: dailyForecast.weather.first!.main,
                        minTemp: dailyForecast.temp.min,
                        maxTemp: dailyForecast.temp.max,
                        icon: Helper.getIcon(main: dailyForecast.weather.first!.main))
                }
                
                self.detailWeatherDelegate!.showDetailWeather()
                
            case .failure(let error):
                //print(error)
                self.detailWeatherDelegate?.showError()
            }
        }
    }
    
    func getDateFormatted(timestamp: Int)-> String{
        let epocTime = TimeInterval(timestamp)
        let myDate = Date(timeIntervalSince1970: epocTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "E d"
        let finalDate = formatter.string(from: myDate)
        
        return finalDate
    }
}

