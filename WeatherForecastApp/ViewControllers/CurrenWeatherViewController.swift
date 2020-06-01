//
//  CurrenWeatherViewController.swift
//  WeatherForecastApp
//
//  Created by Chinthan on 01/06/20.
//  Copyright © 2020 Chinthan. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var currentWeather: WeatherInfo? {
        didSet {
            DispatchQueue.main.async{
                if let current = self.currentWeather {
                    self.currentTemperatureLabel.text = current.currentTemperature
                    self.weatherDescLabel.text =  current.description
                    self.humidityLabel.text =  "Humidity \(current.humidity)"
                    self.windLabel.text =  "Wind \(current.windSpeed)"
                    self.weatherImageView.image = UIImage.weatherIcon(of: current.icon)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 15.0
    }

}

