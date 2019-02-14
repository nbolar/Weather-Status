//
//  CurrentWeather.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/5/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation
import SwiftyJSON


class CurrentWeather {
    
    fileprivate var _cityName: String!
    fileprivate var _date: String!
    fileprivate var _weatherType: String!
    fileprivate var _currentTemp: String!
    fileprivate var _currentSummary: String!
    fileprivate var _hourlySummary: String!
    fileprivate var _highLabel: String!
    fileprivate var _lowLabel: String!
    fileprivate var _windSpeed: String!
    fileprivate var _rainProb: String!
    fileprivate var _humid: String!
    fileprivate var _feels: String!
    fileprivate var _weekSummary: String!
    fileprivate var _sunrise: String!
    fileprivate var _sunset: String!
    
    
    var cityName: String{
        get{
            return _cityName ?? "None"
        }
        set {
            _cityName = newValue
        }
    }
    
    
    var date: String{
        get{
            return _date ?? "None"
        }
        set {
            _date = newValue
        }
    }
    
    var weatherType: String{
        get{
            return _weatherType ?? "None"
        }
        set {
            _weatherType = newValue
        }
    }
    
    var currentTemp: String{
        get{
            return _currentTemp ?? "--"
        }
        set {
            _currentTemp = newValue
        }
    }
    var currentSummary: String{
        get{
            return _currentSummary ?? "--"
        }
        set {
            _currentSummary = newValue
        }
    }
    
    var hourlySummary: String{
        get{
            return _hourlySummary ?? "--"
        }
        set {
            _hourlySummary = newValue
        }
    }
    
    var highLabel: String{
        get{
            return _highLabel ?? "--"
        }
        set {
            _highLabel = newValue
        }
    }
    
    var lowLabel: String{
        get{
            return _lowLabel ?? "--"
        }
        set {
            _lowLabel = newValue
        }
    }
    
    var windSpeed: String{
        get{
            return _windSpeed ?? "--"
        }
        set {
            _windSpeed = newValue
        }
    }
    
    var rainProb: String{
        get{
            return _rainProb ?? "--"
        }
        set {
            _rainProb = newValue
        }
    }
    
    var humid: String{
        get{
            return _humid ?? "--"
        }
        set {
            _humid = newValue
        }
    }
    
    var feels: String{
        get{
            return _feels ?? "--"
        }
        set {
            _feels = newValue
        }
    }
    
    var weekSummary: String{
        get{
            return _weekSummary ?? "--"
        }
        set {
            _weekSummary = newValue
        }
    }
    
    var sunrise: String{
        get{
            return _sunrise ?? "--"
        }
        set {
            _sunrise = newValue
        }
    }
    
    var sunset: String{
        get{
            return _sunset ?? "--"
        }
        set {
            _sunset = newValue
        }
    }
    
    
    class func loadCurrentWeatherFromData(_ APIData: Data) -> CurrentWeather{
        
        let currentWeather = CurrentWeather()
        let swiftyJson = try! JSON(data: APIData)
        

        currentWeather.weatherType = swiftyJson["currently"]["icon"].stringValue.capitalized
        currentWeather.currentTemp = "\(Int(swiftyJson["currently"]["temperature"].doubleValue.rounded()))°"
        currentWeather.currentSummary = swiftyJson["currently"]["summary"].stringValue
        currentWeather.hourlySummary = swiftyJson["hourly"]["summary"].stringValue
        currentWeather.highLabel = "\(Int(swiftyJson["daily"]["data"][0]["temperatureHigh"].doubleValue.rounded()))°"
        currentWeather.lowLabel = "\(Int(swiftyJson["daily"]["data"][0]["temperatureLow"].doubleValue.rounded()))°"
        currentWeather.windSpeed = "\(Int(swiftyJson["currently"]["windSpeed"].doubleValue.rounded()))"
        currentWeather.rainProb = "\(Int(swiftyJson["currently"]["precipProbability"].doubleValue * 100))"
        currentWeather.humid = "\(Int(swiftyJson["currently"]["humidity"].doubleValue * 100))"
        currentWeather.feels = "\(Int(swiftyJson["currently"]["apparentTemperature"].doubleValue.rounded()))°"
        currentWeather.weekSummary = swiftyJson["daily"]["summary"].stringValue
        
        let sunriseTime = swiftyJson["daily"]["data"][0]["sunriseTime"].doubleValue
        let unixConvertedDateRise = Date(timeIntervalSince1970: sunriseTime)
        currentWeather.sunrise = unixConvertedDateRise.timeOfTheDay()
        
        let sunsetTime = swiftyJson["daily"]["data"][0]["sunsetTime"].doubleValue
        let unixConvertedDateSet = Date(timeIntervalSince1970: sunsetTime)
        currentWeather.sunset = unixConvertedDateSet.timeOfTheDay()
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        
        currentWeather.date = "Today, \(currentDate)"
        
        return currentWeather
        
    }
    
    
    
    
    
}
