//
//  WeatherModel.swift
//  Weather
//
//  Created by Elamurugu on 13/12/23.
//

import Foundation


struct WeatherModel {
    
    // Properties to hold weather data
    let conditionId: Int // Weather condition ID
    let cityName: String // Name of the city
    let temperature: Double // Temperature in Celsius
    let text: String // Description of weather condition
    let urlIcon: String // URL for weather condition icon
    let forecastArr: Array<Dictionary<String,Any>> // Array containing forecast data
    
    // Computed property to represent temperature as a formatted string
    var temperatureString: String {
        return String(format: "%.1f", temperature)  // Formats temperature to one decimal place
    }
    
}
