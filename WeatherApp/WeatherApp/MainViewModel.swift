//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import Foundation
import CoreData

class MainViewModel {
    
    var mainViewController: MainViewDelegate?
    var currentWeather: CurrentWeatherData?
    var favoritePlaces: [FavoritePlace] = []{
        didSet{
            mainViewController?.favoriteCitiesTableView.reloadData()
        }
    }
    
    init() {
        self.getFavoriteCities()
    }
    
    func removeFavoriteCity(){
        CoreDataStorage.shared.removeCity(id: currentWeather!.id)
        self.favoritePlaces.removeAll { $0.id == currentWeather?.id}
    }
    
    func addFavoriteCity(){
        let newCity = FavoritePlace(id: self.currentWeather!.id, name: self.currentWeather!.location, coord: self.currentWeather!.coord)
        CoreDataStorage.shared.addCity(favCity: newCity)
        self.favoritePlaces.append(newCity)
    }
    
    func isFavoriteCity(_ id: Int)-> Bool{
        return !(favoritePlaces.filter { $0.id == id}).isEmpty
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double){
        ApiManager.shared.getCurrentWeather(latitude: latitude, longitude: longitude) { [self] (result) in
        
            switch result{
            case .success(let weatherInfo):
                self.currentWeather = CurrentWeatherData(
                    id: weatherInfo.id,
                    location: weatherInfo.name,
                    temperature: weatherInfo.main.temp,
                    icon: Helper.getIcon(main: weatherInfo.weather.first!.main) ,
                    climate: weatherInfo.weather.first!.description,
                    weatherMain: weatherInfo.weather.first!.main,
                    coord: weatherInfo.coord)
                self.mainViewController!.updateCurrentLocationWeather(weather: self.currentWeather!)
            case .failure(let error):
                print(error.localizedDescription)
                self.mainViewController?.showError()
            }
        }
    }
    
    func getFavoriteCities(){
        let fetchedResults = CoreDataStorage.shared.getFavoriteCities()
        if(!fetchedResults.isEmpty){
            self.favoritePlaces = fetchedResults.map { (result) -> FavoritePlace in
                return FavoritePlace(
                    id: result.value(forKeyPath: "id") as! Int,
                    name: result.value(forKeyPath: "name") as! String,
                    coord: Coordinates(
                        lat: result.value(forKeyPath: "latitude") as! Double,
                        lon: result.value(forKeyPath: "longitude") as! Double))
            }
        }
    }
}


