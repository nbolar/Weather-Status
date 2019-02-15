//
//  ForecastWeather.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/14/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import Solar
import CoreLocation

class ForecastWeather: NSViewController, CLLocationManagerDelegate {

    @IBOutlet weak var forecastSummaryLabel: NSTextField!
    @IBOutlet weak var sunriseLabel: NSTextField!
    @IBOutlet weak var sunsetLabel: NSTextField!
    @IBOutlet weak var precipProbLabel: NSTextField!
    @IBOutlet weak var windLabel: NSTextField!
    @IBOutlet weak var humidLabel: NSTextField!
    @IBOutlet weak var uvLabel: NSTextField!
    var speed : String!
    var url : URL!
    static let instance = ForecastWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true

        self.view.layer?.cornerRadius = 8
        downloadWeather()
        updateUI()
    }
    func downloadWeather(){
        
        
        if fahrenheit == 0 && celsi == 1{
            url = URL(string: API_URL_FORECAST_si)
            speed = "kph"
            
        }
        if fahrenheit == 1 && celsi == 0 {
            url = URL(string: API_URL_FORECAST_us)
            speed = "mph"

        }
        if connected == 1 {
            
            AF.request(url!).responseData { (response) in
                let swiftyJson = try! JSON(data: response.data!)
                self.forecastSummaryLabel?.stringValue = swiftyJson["daily"]["data"][index+1]["summary"].stringValue
                self.precipProbLabel?.stringValue = "\(Int(swiftyJson["daily"]["data"][index+1]["precipProbability"].doubleValue * 100)) %"
                self.windLabel?.stringValue = "\(Int(swiftyJson["daily"]["data"][index+1]["windSpeed"].doubleValue.rounded())) \(self.speed ?? "--")"
                self.humidLabel?.stringValue = "Humidity : \(Int(swiftyJson["daily"]["data"][index+1]["humidity"].doubleValue * 100))%"
                self.uvLabel?.stringValue = "UV Index : \(swiftyJson[""]["data"][index+1]["uvIndex"].intValue)"
                
                
                let sunriseTime = swiftyJson["daily"]["data"][index+1]["sunriseTime"].doubleValue
                let unixConvertedDateRise = Date(timeIntervalSince1970: sunriseTime)
                self.sunriseLabel?.stringValue = "\(unixConvertedDateRise.timeOfTheDay()) AM"
                let sunsetTime = swiftyJson["daily"]["data"][index+1]["sunsetTime"].doubleValue
                let unixConvertedDateSet = Date(timeIntervalSince1970: sunsetTime)
                self.sunsetLabel?.stringValue = "\(unixConvertedDateSet.timeOfTheDay()) PM"
                
            }
        } else if connected == 0{
            self.forecastSummaryLabel?.stringValue = "No Internet Connection"
            self.precipProbLabel?.stringValue = "--"
            self.windLabel?.stringValue = "--"
            self.sunriseLabel?.stringValue = "--"
            self.sunsetLabel?.stringValue = "--"
            self.humidLabel?.stringValue = "--"
            
        }
        
        
        
    }
    
    func updateUI(){
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
        
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            if connected == 1{
                if (appDelegate.solar.isNighttime){
                    let image = NSImage(named: "wallpaper7")
                    self.view.layer?.contents = image
                } else if (appDelegate.solar.isDaytime){
                    let image = NSImage(named: "wallpaper1")
                    self.view.layer?.contents = image
                }
                
            }

        }
    }
    
}
