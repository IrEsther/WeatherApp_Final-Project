//
//  weatherManager.swift
//  Weather_project
//
//  Created by Esther Chasin on 26/05/2020.
//  Copyright © 2020 Esther Chasin. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=d44fbe92097fcf55334c0a6c12f42bac&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest ( with urlSring : String)  {
        if  let url = URL(string: urlSring){
            let session = URLSession(configuration: .default)
            
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if  let weather = self.parseJSON(safeData){
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
            
        }
        
    }
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let  decoder  = JSONDecoder()
        do{
            let decodedData =
                try  decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
           // let description = decodedData.weather[0].description
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)//, description: description)
           return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
}

