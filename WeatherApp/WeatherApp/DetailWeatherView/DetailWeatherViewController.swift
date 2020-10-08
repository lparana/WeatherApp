//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Lara Poveda on 06/10/2020.
//

import UIKit

class DetailWeatherViewController: UIViewController, DetailWeatherDelegate {

    var detailWeatherViewModel: DetailWeatherViewModel?
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cityNameLabel.text = self.detailWeatherViewModel?.cityName
        self.favButton.isSelected = self.detailWeatherViewModel!.isFavorite ?? false
        self.forecastTableView.delegate = self
        self.forecastTableView.dataSource = self
        self.forecastTableView.register(UINib(nibName: "DailyDetailWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "forecastCell")
        self.detailWeatherViewModel?.detailWeatherDelegate = self
        self.detailWeatherViewModel?.getDetailWeather(in: nil)
    }

    func showDetailWeather() {
        
        DispatchQueue.main.async{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = self.bgColors[self.detailWeatherViewModel!.currentWeather!.weatherMain]
            
            gradientLayer.locations = [0.0, 1.0]
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        
            self.forecastTableView.reloadData()
            let temp = self.detailWeatherViewModel!.currentWeather?.temperature ?? 0
            self.tempLabel.text = String(format: "%.2f", temp)+" ºC"
            self.climateLabel.text = self.detailWeatherViewModel?.currentWeather?.climate
        }
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        if favButton.isSelected{
            favButton.isSelected = false
            self.detailWeatherViewModel!.removeFavoriteCity()
        }else{
            favButton.isSelected = true
            self.detailWeatherViewModel!.addFavoriteCity()
        }
    }
    
    @IBAction func refreshWeatherInfo(_ sender: Any) {
        self.detailWeatherViewModel?.getDetailWeather(in: nil)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("ERROR_TITLE_INFO", comment: ""), message: NSLocalizedString("ERROR_MESSAGE_INFO", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    let bgColors = [
        
        "Clear":[UIColor( red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1.0 ).cgColor, UIColor( red: 0.9529411793, green: 0.8685067713, blue: 0.1800223484, alpha: 1.0 ).cgColor],
        "Clouds": [UIColor( red: 0.5088317674, green: 0.5486197199, blue: 0.7256778298, alpha: 1.0 ).cgColor, UIColor( red: 0.3843137255, green: 0.4117647059, blue: 0.5450980392, alpha: 1.0 ).cgColor],
        "Smoke":[UIColor( red: 0.4714559888, green: 0.41813849, blue: 0.4877657043, alpha: 1.0 ).cgColor, UIColor( red: 0.3823538819, green: 0.3384427864, blue: 0.3941545051, alpha: 1.0 ).cgColor],
        "Mist": [UIColor( red: 0.8536048541, green: 0.8154317929, blue: 0.6934956985, alpha: 1.0 ).cgColor, UIColor( red: 0.5, green: 0.3992742327, blue: 0.3267588525, alpha: 1.0 ).cgColor],
        "Snow": [UIColor(red: 0.8229460361, green: 0.8420813229, blue: 0.9764705896, alpha: 1.0 ).cgColor, UIColor(red: 0.6424972056, green: 0.9015246284, blue: 0.9529411793, alpha: 1.0 ).cgColor],
        "Haze":[UIColor(red: 0.9764705896, green: 0.7979655136, blue: 0.9493740175, alpha: 1.0 ).cgColor, UIColor( red: 0.6843526756, green: 0.7806652456, blue: 0.9529411793, alpha: 1.0 ).cgColor],
        "Thunderstorm": [UIColor( red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1.0 ).cgColor, UIColor( red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1.0 ).cgColor],
        "Blowing snow":[UIColor( red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1.0 ).cgColor, UIColor( red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1.0 ).cgColor],
        "Fog": [UIColor( red: 0.6324083141, green: 0.8039215803, blue: 0.7850640474, alpha: 1.0 ).cgColor, UIColor( red: 0.4545597353, green: 0.393878495, blue: 0.5369011739, alpha: 1.0 ).cgColor],
        "Ash": [UIColor( red: 0.325, green: 0.325, blue: 0.325, alpha: 1.0 ).cgColor, UIColor( red: 0.4545597353, green: 0.393878495, blue: 0.5369011739, alpha: 1.0 ).cgColor],
        "Dust": [UIColor( red: 0.579, green: 0.322, blue: 0, alpha: 1.0 ).cgColor, UIColor( red: 0.664, green: 0.664, blue: 0.664, alpha: 1.0 ).cgColor],
        "Sand": [UIColor( red: 0.455, green: 0.322, blue: 0.043, alpha: 1.0 ).cgColor, UIColor( red: 0.325, green: 0.325, blue: 0.325, alpha: 1.0 ).cgColor],
        "Squall": [UIColor( red: 0.6324083141, green: 0.8039215803, blue: 0.7850640474, alpha: 1.0 ).cgColor, UIColor( red: 0.4545597353, green: 0.393878495, blue: 0.5369011739, alpha: 1.0 ).cgColor],
        "Drizzle": [UIColor( red: 0.5892893535, green: 0.7170531098, blue: 0.9764705896, alpha: 1.0 ).cgColor, UIColor( red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1.0 ).cgColor],
        "Tornado":[UIColor( red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1.0 ).cgColor, UIColor( red: 0.2854045624, green: 0.4267300284, blue: 0.6992385787, alpha: 1.0 ).cgColor],
        "Rain": [UIColor( red: 0.3437546921, green: 0.6157113381, blue: 0.7179171954, alpha: 1.0 ).cgColor, UIColor( red: 0.4118283819, green: 0.5814552154, blue: 0.6975531409, alpha: 1.0 ).cgColor],
        ]

}

extension DetailWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailWeatherViewModel?.forecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! DailyDetailWeatherTableViewCell
        cell.setData(dailyWeather: (self.detailWeatherViewModel?.forecast![indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


protocol DetailWeatherDelegate{
    func showDetailWeather()
    func showError()
}
