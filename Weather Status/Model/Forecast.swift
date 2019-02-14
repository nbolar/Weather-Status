//
//  Forecast.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/5/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Forecast {
    
    fileprivate var _date: String!
    fileprivate var _weatherType: String!
    fileprivate var _highTemp: Int!
    fileprivate var _lowTemp:Int!
    
    
    var date: String {
        get{
            return _date
        } set {
            _date = newValue
        }
    }
    
    var weatherType: String {
        get{
            return _weatherType
        } set {
            _weatherType = newValue
        }
    }
    
    var lowTemp: Int {
        get{
            return _lowTemp
        } set {
            _lowTemp = newValue
        }
    }
    
    var highTemp: Int {
        get{
            return _highTemp
        } set {
            _highTemp = newValue
        }
    }
    
    
    class func loadForecastFromData(_ APIData: Data) -> [Forecast]{
        
        
        var forecast = [Forecast]()
        
        let json = try! JSON(data: APIData)
        
        if let list = json["daily"]["data"].array{
            for day in list
            {
                let dayForecast = Forecast()
                dayForecast.highTemp = Int(day["temperatureHigh"].doubleValue.rounded())
                dayForecast.lowTemp = Int(day["temperatureLow"].doubleValue.rounded())
                dayForecast.weatherType = day["icon"].stringValue
                
                let date = day["time"].doubleValue
                let unixConvertedDate = Date(timeIntervalSince1970: date)
                dayForecast.date = unixConvertedDate.dayOfTheWeek()
                forecast.append(dayForecast)
            }
        }
        return forecast
    }
    
}
