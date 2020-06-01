//
//  ViewController.swift
//  WeatherForecastApp
//
//  Created by Chinthan on 01/06/20.
//  Copyright © 2020 Chinthan. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController{

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var dailyWeatherView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherForecastLabel: UILabel!


    var currentWeatherVC: CurrentWeatherViewController?
    var dailyWeatherVC: DailyForecastViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        hideView()
        fetchWeatherService()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CurrentWeatherViewController,
            segue.identifier == "CurrentWeather" {
            self.currentWeatherVC = vc
        }
        else if let vc = segue.destination as? DailyForecastViewController,
            segue.identifier == "DailyWeather" {
            self.dailyWeatherVC = vc
        }        
    }
    
    //Mark: - Private Methods

    private func hideView() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.currentWeatherView.isHidden = true
            self.dailyWeatherView.isHidden = true
            self.weatherForecastLabel.isHidden = true
        }
    }
    
    private func showView() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.currentWeatherView.isHidden = false
            self.dailyWeatherView.isHidden = false
            self.weatherForecastLabel.isHidden = false
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchWeatherService() {
        self.hideView()
        viewModel?.fetchWeatherInfo(location: locationTextField.text ?? "London,GB")
    }

    // MARK: - ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            viewModel?.currentWeather.bind {
                [unowned self] in
                self.currentWeatherVC?.currentWeather = $0
            }
            
            viewModel?.forecasts.bind {
                [unowned self] in
                self.dailyWeatherVC?.forecasts = $0
            }
            
            viewModel?.isFetchingCompleted.bind {
                isCompleted in
                if isCompleted {
                    self.showView()
                }
            }
            
            viewModel?.errorMessage.bind {
                errorMsg in
                if errorMsg != "" {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.showAlert(message: errorMsg)
                    }
                }
            }
            
        }
    }

}

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideView()
        fetchWeatherService()
        return true
    }
}

