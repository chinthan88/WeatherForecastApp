//
//  ForecastCell.swift
//  WeatherForecastApp
//
//  Created by Chinthan on 01/06/20.
//  Copyright © 2020 Chinthan. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
    }
    
    func configure(forecast: WeatherInfo?) {
        if let weatherForecast = forecast {
            self.currentTemperatureLabel.text = weatherForecast.currentTemperature
            self.weatherDescLabel.text =  weatherForecast.description
            self.minTempLabel.text =  weatherForecast.minTemperature
            self.maxTempLabel.text =  weatherForecast.maxTemperature
            self.dateTimeLabel.text = weatherForecast.dayName
            self.weatherImageView.image = UIImage.weatherIcon(of: weatherForecast.icon)
        }
    }
    
}
