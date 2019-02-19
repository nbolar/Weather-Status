//
//  Constants.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/5/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation



typealias DownloadComplete = () -> ()

let NOTIF_DOWNLOAD_COMPLETE = NSNotification.Name("dataDownloaded")

let LONG = Location.instance.longitude
let LAT = Location.instance.latitude
var units = 1
var interval = 15
var celsi = 1
var fahrenheit = 0
var check1 = 0
var check2 = 0
var index = 0
var connected = 0
var launched = 0

let API_KEY1 = "&YOURKEy" //OpenWeatherMap API Key
let API_KEY2 = "YOURKEY" //DarkSky API Key
let IMAGE_API_KEY = "YOURKEY"

let API_URL_CURRENT_WEATHER_si = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=ca"
let API_URL_FORECAST_si  = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=ca"


let API_URL_CURRENT_WEATHER_us = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=us"
let API_URL_FORECAST_us  = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=us"



