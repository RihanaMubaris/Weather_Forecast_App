//
//  BaseViewController.swift
//  Weather
//
//  Created by Elamurugu on 14/12/23.
//

import UIKit
import CoreLocation

class BaseViewController: UIViewController, WeatherManagerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Do any additional setup after loading the view.
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
}
    
    /// <#Description#>
    /// - Parameters:
    ///   - error: <#error description#>
    ///   - msg: <#msg description#>
    func didFailWithError(error: Error, msg: String) {
        DispatchQueue.main.async {
            self.stopLoading() // Hide loader when the response is received
        }
        showAlert(title: "Error", message: msg)
    }
    
    func startLoading() {
        // Start animating the activity indicator
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        // Stop and hide the activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    /// this fuction is used to show  alert message popup with okay  button
    /// - Parameters:
    ///   - title: to show as a title
    ///   - message: message to show as a content
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            // Get the reference to the current UIViewController
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension BaseViewController: CLLocationManagerDelegate {
    
    /// This function is called whenever there's an update in the device's location. Upon receiving the location update, it triggers the weather fetching process.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            startLoading()
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            var weatherURL = false
            if let presentedVC = self.presentedViewController {
                if presentedVC is WeatherViewController {
                    weatherURL = true
                }
            }

            weatherManager.fetchWeather(latitude: lat, longitude: lon, weatherUrl: weatherURL)
        }
    }
    
    ///
    /// - Parameters: This function is called when the location manager encounters an error while trying to retrieve the device's location.
    ///   - manager:use to start and stop the delivery of location-related events to app.
    ///   - error: A type representing an error value that can be thrown.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {//This code ensures that UI updates are performed on the main thread, which is crucial for UI-related tasks.
            self.stopLoading() // Hide loader when the response is received
        }
        showAlert(title: "Error", message: error.localizedDescription)
        print(error.localizedDescription)
    }
}

