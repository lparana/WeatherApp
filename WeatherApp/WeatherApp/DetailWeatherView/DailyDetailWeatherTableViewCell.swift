//
//  DailyDetailWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Lara Poveda on 07/10/2020.
//

import UIKit

class DailyDetailWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(dailyWeather: DailyWeatherInfo){
        self.dateLabel.text = dailyWeather.date
        self.weatherIcon.image = UIImage(systemName: dailyWeather.icon)
        self.minTemp.text = String(format: "%.2f", dailyWeather.minTemp)+" ºC"
        self.maxTemp.text = String(format: "%.2f", dailyWeather.maxTemp)+" ºC"
    }
    
}
