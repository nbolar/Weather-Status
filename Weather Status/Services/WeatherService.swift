//
//  WeatherService.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/5/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    
    static let instance = WeatherService()
    fileprivate var _currentWeather = CurrentWeather()
    fileprivate var _forecast = [Forecast]()
    
    var currentWeather: CurrentWeather{
        get{
            return _currentWeather
        } set {
            _currentWeather = newValue
        }
    }
    var forecast: [Forecast]{
        get{
            return _forecast
        } set {
            _forecast = newValue
        }
    }

    
    
    func downloadWeatherDetails (completed: @escaping DownloadComplete)
    {
        if units == 1
        {
            let url = URL(string: API_URL_CURRENT_WEATHER_si)
            AF.request(url!).responseData { (response) in
                
                if response.data != nil
                {
                    self.currentWeather = CurrentWeather.loadCurrentWeatherFromData(response.data!)
                }
                
                
                completed()
            }
        }
        else{
            
            let url = URL(string: API_URL_CURRENT_WEATHER_us)

            AF.request(url!).responseData { (response) in
                
                if response.data != nil
                {
                    self.currentWeather = CurrentWeather.loadCurrentWeatherFromData(response.data!)
                }
                
                
                completed()
            }
        }
         
    }
    
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        
        
        if units == 1
        {
            let url = URL(string: API_URL_FORECAST_si)
            AF.request(url!).responseJSON { (response) in
                
                if response.data != nil
                {
                    self.forecast = Forecast.loadForecastFromData(response.data!)
                }
                if self.forecast.count > 0 {
                    self.forecast.remove(at: 0)
                }
                
                completed()
            }
            
        } else
        {
            let url = URL(string: API_URL_FORECAST_us)
            AF.request(url!).responseJSON { (response) in
                
                if response.data != nil
                {
                    self.forecast = Forecast.loadForecastFromData(response.data!)
                }
                if self.forecast.count > 0 {
                    self.forecast.remove(at: 0)
                }
                
                completed()
            }
        }
        
        
    }
    
}

