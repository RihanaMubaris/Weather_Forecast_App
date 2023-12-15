//
//  WeatherManager.swift
//  Weather
//
//  Created by Elamurugu on 13/12/23.
//
//Passing data to WeatherViewController, we can use protocols and delegates.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
   func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error, msg:String)
}

struct WeatherManager {
    
    // URLs for fetching weather data
    let weatherURL = "https://api.weatherapi.com/v1/current.json?key=3359b096eef14268b3b160254231212"

    let forecastURL = "https://api.weatherapi.com/v1/forecast.json?key=3359b096eef14268b3b160254231212"
    
    var delegate: WeatherManagerDelegate?// Delegate for handling weather updates
    
    
    // Fetch weather using city name with an option to determine the type of URL (weather or forecast)
    func fetchWeather(cityName: String, weatherUrl: Bool) {
        
        let urlString = weatherUrl ? "\(forecastURL)&q=\(cityName)&aqi=no" : "\(forecastURL)&q=\(cityName)&days=5&aqi=no&alerts=no"
        performRequest(with: urlString)
    }
    // Fetch weather based on current location with an option to determine the type of URL (weather or forecast)
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, weatherUrl: Bool) {
        let urlString = weatherUrl ?  "\(forecastURL)&q=lat=\(latitude)&lon=\(longitude)&aqi=no" : "\(forecastURL)&q=lat=\(latitude)&lon=\(longitude)&days=5&aqi=no&alerts=no"
        performRequest(with: urlString)
    }
    
    // Perform an HTTP request with the given URL
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30 // Set a reasonable timeout interval in seconds

            let session = URLSession(configuration: config)
            let task = session.dataTask(with: url) { (data, response, error) in
                    
                    if let error = error as NSError? {
                        let errMessage = ErrorHandlingForNSErr(error)
                        delegate?.didFailWithError(error: error, msg: errMessage)
                        return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        // Send the weather data to the delegate for further handling
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume() // Start the data task
        }
    }
    
    // Parse JSON data into a WeatherModel object
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // Extract necessary weather information from the decoded data
            
            // Current weather data
            let id = decodedData.current.condition.code
            let temp = decodedData.current.temp_c
            let name = decodedData.location.name
            let text = decodedData.current.condition.text
            let urlIcon = decodedData.current.condition.icon
            
                
            // Array for forecast data for 5 days
            var myArray = [[String: Any]]()
                
            for forecast in decodedData.forecast.forecastday {
                let dict = [
                    "date": forecast.date,
                    "maxtemp_c": forecast.day.maxtemp_c,
                    "code": forecast.day.condition.code,
                    "text": forecast.day.condition.text,
                    "urlIcon":forecast.day.condition.icon
                ] as [String : Any]
                myArray.append(dict)
            }
                
            // Create a WeatherModel object with the extracted data
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, text: text, urlIcon: urlIcon, forecastArr: myArray) // object of Weather Model struct
                
            return weather // Return the WeatherModel object

        } catch let error as DecodingError {
            // Handle decoding errors
            let errMessage = ErrorHandlingForDecodeErr(error)
            delegate?.didFailWithError(error: error, msg: errMessage)
            }catch {
                // Handle any other errors
                print("An unknown error occurred: \(error.localizedDescription)")
                // Show a generic error message to the user
                let errorMessage = "An unknown error occurred"
                delegate?.didFailWithError(error: error, msg: errorMessage)

            }
            return nil // Return nil if there was an error during parsing
        }
    }
    

// Handle NSError type errors (typically network-related errors)
func ErrorHandlingForNSErr(_ error:NSError) -> (String) {
    let errorMessage: String
    if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
        // Handle no internet connection error
        errorMessage = "The Internet connection appears to be offline."
    } else {
        // Handle other network-related errors
        errorMessage = "An error occurred: \(error.localizedDescription)"
    }


    return errorMessage // Return appropriate error message
}
    
// Handle DecodingError type errors (errors occurring during JSON decoding)
func ErrorHandlingForDecodeErr(_ error:DecodingError) -> (String) {
    let errorMessage: String
    switch error {
    case .keyNotFound(let key, let context):
        print("Key not found: \(key.stringValue), \(context.debugDescription)")
        // Show an appropriate message to the user based on the error
        errorMessage = "Data is missing for \(key.stringValue)"
        // Display this merror message to the user using an alert or UI update
        // For example:
//                    showAlert(title: "Error", message: errorMessage)
    default:
        print("An error occurred: \(error.localizedDescription)")
        // Show a generic error message to the user
        errorMessage = "An error occurred while processing data"
    }

return errorMessage // Return appropriate error message
}

