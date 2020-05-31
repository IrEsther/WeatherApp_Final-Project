//
//  weatherData.swift
//  Weather_project
//
//  Created by Esther Chasin on 27/05/2020.
//  Copyright © 2020 Esther Chasin. All rights reserved.
//

import Foundation
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let description: String
    let id : Int
    
}
