# Weather App

## Description:
Based on the user's current location, the Weather App presents real-time weather information. furthermore show the five-day forecast for the place the user searched.

## Setup Instructions:
1. Clone the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or device.

## Architectural Choices:
This project follows the MVC (Model-View-Controller) architecture for better separation of concerns.
Implementation:
Model: Contains structures/classes (WeatherModel, WeatherManager) for handling weather data retrieval, parsing, and business logic.
View: Comprises view controllers (WeatherViewController, SearchViewController) managing UI elements for displaying weather and search functionalities.
Controller: Orchestrates user interactions, invokes model methods to fetch weather data, and updates the view with the retrieved information (BaseViewController as a common base for handling loading indicators and alerts).
In my app, the MVC pattern helps organize and separate concerns related to weather data, user interface presentation, and user interactions, providing a structured approach for efficient development and maintenance.

## Additional Libraries/Tools:
Kingfisher: this library simplifies the process of fetching and displaying images from the web by providing a straightforward API and caching mechanisms.

