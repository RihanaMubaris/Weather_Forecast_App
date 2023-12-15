//
//  WeatherData.swift
//  Weather
//
//  Created by Elamurugu on 13/12/23.
//

import Foundation

// WeatherData structure representing the overall weather data
struct WeatherData: Codable {
    
    let location: Location // Information about the location
    let current: Current   //Current weather data
    let forecast: Forecast // Forecasted weather data
    
}

// Current structure holding current weather details
struct Current: Codable {
    let temp_c: Double
    let condition: Condition // Current weather condition
}

// Location structure containing location-specific data
struct Location: Codable {
    let name: String  // Name of the location (e.g., city name)
    
}

// Condition structure representing weather condition details
struct Condition: Codable {
    let code: Int // Weather condition code
    let text: String // Description of the weather condition
    let icon: String // URL for the weather condition icon
}

// Forecast structure containing forecasted data
struct Forecast: Codable{
    let forecastday: [Forecastday] // Array of forecast days
}

// Forecastday structure representing data for a specific forecast day
struct Forecastday: Codable{
    let date: String // Date for the forecast day
    let day: Day  // Weather details for the day
}

// Day structure containing weather details for a specific day
struct Day: Codable{
    let maxtemp_c: Double  // Maximum temperature for the day in Celsius
    let condition: Condition  // Weather condition for the day

}


