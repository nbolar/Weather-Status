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
        let url = URL(string: API_URL_CURRENT_WEATHER)
        AF.request(url!).responseData { (response) in
            
            if response.data != nil
            {
                self.currentWeather = CurrentWeather.loadCurrentWeatherFromData(response.data!)
            }
            
            
            completed()
            
            
            
        }
        
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        
        let url = URL(string: API_URL_FORECAST)
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
