//
//  SearchViewController.swift
//  Weather
//
//  Created by Elamurugu on 13/12/23.
//

import UIKit
import CoreLocation
import Kingfisher

class SearchViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImgView: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    var forecastArray: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds a tap gesture recognizer to the view that calls the handleTap(_:) method when a tap is detected. This gesture is configured to recognize taps on the entire view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)

        // Set the current view controller as the delegate for the search text field
        searchTextField.delegate = self
        
        // Set the data source and delegate for the weather table view to this view controller
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
        //register customtableviewcell
        self.registerTableViewCells()
        
    }

    private func registerTableViewCells() {
        // Load the SearchWeatherTableViewCell from the nib file
        let textFieldCell = UINib(nibName: "SearchWeatherTableViewCell",
                                  bundle: nil)
        
        // Register the cell with the weatherTableView using a reuse identifier
        self.weatherTableView.register(textFieldCell,
                                       forCellReuseIdentifier: "SearchWeatherTableViewCell")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Dismiss the keyboard when the view is tapped outside of the text field
        view.endEditing(true)
    }
    
    func convertDateStringToDay(_str: String) -> String {
        let dateString = _str // Replace this with your date string
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Parse the string into a Date object
        if let date = dateFormatter.date(from: dateString) {
            // Create a calendar
            let calendar = Calendar.current
            
            // Get the weekday symbol
            let weekday = calendar.component(.weekday, from: date)
            
            // Get the weekday name from the symbol
            let weekdayName = dateFormatter.weekdaySymbols[weekday - 1] // Adjust for zero-based array
            return weekdayName
            
        }
        else {
            return "--"
        }
    }
    
    override func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        //The code is wrapped inside DispatchQueue.main.async to ensure that UI updates happen on the main thread. This is important to prevent any UI-related issues since UI updates should always be performed on the main thread in iOS.
        DispatchQueue.main.async {
            self.stopLoading()
            self.cityNameLabel.text = weather.cityName
            
            // Construct the complete URL for the weather condition icon
            let urlString = "https:\(weather.urlIcon)"
            
            // Check if the URL is valid and load the weather condition icon asynchronously
            if let url = URL(string: urlString) {
                self.conditionImgView.kf.setImage(with: url)
            } else {
                print("Invalid URL")
                self.conditionImgView.image = UIImage(systemName: "cloud")
            }

//          self.conditionImgView.image = UIImage(systemName: weather.conditionName)
            self.forecastArray = weather.forecastArr  // Update forecast array data
            self.tempLabel.text = weather.temperatureString
            self.weatherTableView.reloadData() // Reload the weather table view data
        }

    }

}

    // MARK: - TableviewDelegate Methods
    extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
        
        // Configures and returns a cell for a particular row in the table view
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // Dequeue a reusable cell of type SearchWeatherTableViewCell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchWeatherTableViewCell") as? SearchWeatherTableViewCell {
                cell.backgroundColor = .clear

                // Extracting and formatting date information from forecastArray
                let str = self.forecastArray[indexPath.row]["date"] as? String ?? "0"
                let dayFromDate =  convertDateStringToDay(_str: str)
                cell.dayLabel.text = dayFromDate
                              
                // Constructing the URL string for the weather condition icon
                let urlString = "https:\(self.forecastArray[indexPath.row]["urlIcon"] ?? "")"
//                "https://cdn.weatherapi.com/weather/64x64/day/122.png"
                
                // Set the image from URL using Kingfisher if the URL is valid
                if let url = URL(string: urlString) {
                    cell.condImageView.kf.setImage(with: url)
                } else {
                    print("Invalid URL")
                    cell.condImageView.image = UIImage(systemName: "cloud")

                }

                // Set the maximum temperature text in the cell
                if let maxTemp = self.forecastArray[indexPath.row]["maxtemp_c"] as? Double {
                    // Convert Double to String and set it as the label text
                    cell.tempLabel.text = String(maxTemp)
                } else {
                    // Handle the case where the value doesn't exist or isn't a Double
                    cell.tempLabel.text = "N/A"
                }
                
                // Set the weather description text in the cell
                cell.desclabel.text = self.forecastArray[indexPath.row]["text"] as? String ?? "0"

                return cell
            }

            return UITableViewCell() // Return an empty cell if dequeuing fails
        }

        // Returns the number of rows in the table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.forecastArray.count; // Number of rows based on forecastArray count
        }
        
}
//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
        
    // Function triggered when the "go/return" button on the keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Dismiss the keyboard
        searchTextField.resignFirstResponder()

        // Check if the text field is empty
        if let locationText = searchTextField.text, locationText.isEmpty {
            let errorMessage = "Please enter a location."
           // Show an alert informing the user to enter a location
            showAlert(title: "Location Missing", message: errorMessage)
        }
        else {
            startLoading()
            
            // Fetch weather data for the entered city if the text field is not empty
            if let city = searchTextField.text {
                weatherManager.fetchWeather(cityName: city, weatherUrl: false)
            }
            // Clear the text field after initiating the weather fetch
            searchTextField.text = ""
            }

        return true // Indicates that the text field should return (close keyboard)
    }
    
}
