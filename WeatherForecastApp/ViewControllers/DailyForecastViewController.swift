//
//  DailyForecastViewController.swift
//  WeatherForecastApp
//
//  Created by Chinthan on 01/06/20.
//  Copyright © 2020 Chinthan. All rights reserved.
//

import UIKit

class DailyForecastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var forecasts: [WeatherInfo] = [] {
        didSet {
            DispatchQueue.main.async{
                if self.forecasts.count > 0 {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DailyForecastViewController {

    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherForecast", for: indexPath) as! ForecastCell
        
        cell.configure(forecast: forecasts[indexPath.row])
        
        return cell
    }
    
    
}
