//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lara Poveda on 04/10/2020.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, MainViewDelegate {

    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var climateDescription: UILabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favoriteCitiesLabel: UILabel!
    
    @IBOutlet weak var favoriteCitiesTableView: UITableView!
    
    var mainViewModel: MainViewModel = MainViewModel()
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainViewModel.mainViewController = self
        self.favoriteCitiesTableView.delegate = self
        self.favoriteCitiesTableView.dataSource = self
        self.favButton.isEnabled = false
        self.favoriteCitiesTableView.register(UINib(nibName: "FavCityTableViewCell", bundle: nil), forCellReuseIdentifier: "FavCityCell")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateData()
    }
    
    func updateData(){
        self.mainViewModel.getFavoriteCities()
        self.getCurrentLocation()
    }
    
    func getCurrentLocation() {
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        if favButton.isSelected{
            favButton.isSelected = false
            self.mainViewModel.removeFavoriteCity()
        }else{
            favButton.isSelected = true
            self.mainViewModel.addFavoriteCity()
        }
    }
    
    @IBAction func reloadData(_ sender: Any) {
        self.updateData()
    }
    
    func updateCurrentLocationWeather(weather: CurrentWeatherData){
        DispatchQueue.main.async {
            self.favButton.isEnabled = true
            self.favButton.isSelected = self.mainViewModel.isFavoriteCity(weather.id)
            self.cityLabel.text = weather.location
            self.climateDescription.text = weather.climate
            
            self.tempLabel.text = String(format: "%.2f", weather.temperature)+" ºC"
            self.climateImage.image = UIImage(systemName: weather.icon)
            self.currentWeatherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("currentViewTapped")))
            
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("ERROR_TITLE_INFO", comment: ""), message: NSLocalizedString("ERROR_MESSAGE_INFO", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    @objc func currentViewTapped(){
        
        let detailWeatherViewModel = DetailWeatherViewModel(cityName: self.mainViewModel.currentWeather!.location, id: self.mainViewModel.currentWeather!.id, cityCoord: self.mainViewModel.currentWeather!.coord, isFavorite: self.mainViewModel.isFavoriteCity(self.mainViewModel.currentWeather!.id))
        let detailViewController = DetailWeatherViewController()
        detailViewController.detailWeatherViewModel = detailWeatherViewModel
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        self.mainViewModel.getCurrentWeather(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error givingback location position: \(error.localizedDescription)")
        let alert = UIAlertController(title: NSLocalizedString("ERROR_TITLE_LOCATION", comment: ""), message: NSLocalizedString("ERROR_MESSAGE_LOCATION", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.favoriteCitiesLabel.isHidden = self.mainViewModel.favoritePlaces.isEmpty
        self.favoriteCitiesTableView.isHidden = self.mainViewModel.favoritePlaces.isEmpty
        
        return self.mainViewModel.favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCityCell", for: indexPath) as! FavCityTableViewCell
        cell.setData(name: self.mainViewModel.favoritePlaces[indexPath.row].name,
                     coord: self.mainViewModel.favoritePlaces[indexPath.row].coord)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let place = self.mainViewModel.favoritePlaces[indexPath.row]
        let detailWeatherViewModel = DetailWeatherViewModel(cityName: place.name, id: place.id, cityCoord: place.coord, isFavorite: true)
        let detailViewController = DetailWeatherViewController()
        detailViewController.detailWeatherViewModel = detailWeatherViewModel
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

protocol MainViewDelegate{
    var favoriteCitiesTableView: UITableView! { get }
    func updateCurrentLocationWeather(weather: CurrentWeatherData)
    func showError()
}
