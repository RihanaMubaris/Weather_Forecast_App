//
//  WeatherViewController.swift
//  Weather
//
//  Created by Created by Elamurugu on 13/12/23.
//

import UIKit
import CoreLocation
import Kingfisher

class WeatherViewController: BaseViewController {
    
    
    @IBOutlet weak var btnFiveDaysForecast: UIButton!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var descTextLabel: UILabel!
    
    
    
    @IBAction func searchBtnPresses(_ sender: Any) {
        
        // Create a UIStoryboard instance for accessing view controller from storyboard
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        // Instantiate the SearchViewController from the storyboard
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        // Push the instantiated SearchViewController onto the navigation stack
        // This will navigate to the SearchViewController when the search button is pressed

        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFiveDaysForecast.layer.cornerRadius = 10
        
        // Create a refresh button in the navigation bar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItem = refreshButton
        
        
    }
    @objc func refreshButtonTapped() {
        
        // Request location updates when the refresh button is tapped
        locationManager.requestLocation()
        
    }
    
    // Update UI with received weather data
    override func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.stopLoading()
            
            // Update UI elements with weather data
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.descTextLabel.text = weather.text
            
            // Set the weather condition icon using Kingfisher
            let urlString = "https:\(weather.urlIcon)"
            if let url = URL(string: urlString) {
                self.conditionImageView.kf.setImage(with: url) // Load image from URL
            } else {
                print("Invalid URL")
                
                // Display a default image in case of an invalid URL
                self.conditionImageView.image = UIImage(systemName: "cloud")
            }
        }
        
    }
}
