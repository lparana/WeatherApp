//
//  FavCityTableViewCell.swift
//  WeatherApp
//
//  Created by Lara Poveda on 07/10/2020.
//

import UIKit

class FavCityTableViewCell: UITableViewCell {

    var coord: Coordinates?
    var cityNameText: String?{
        didSet{
            self.cityName.text = cityNameText
            
        }
    }
    @IBOutlet weak var cityName: UILabel!
    
    var originalFrame: CGRect?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(name: String, coord: Coordinates){
        self.cityNameText = name
        self.coord = coord
        self.originalFrame = contentView.frame
    }

    override func layoutSubviews() {
        contentView.frame = self.originalFrame!.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
}
