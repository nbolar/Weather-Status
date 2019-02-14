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

let API_KEY1 = "&appid=691657a05faabbd6ef5736fbcdcf951f" //OpenWeatherMap API Key
let API_KEY2 = "47c545315eff2221c6346d3ee071083d" //DarkSky API Key
let IMAGE_API_KEY = "11603631-76c27310563cb928319e34339"

let API_URL_CURRENT_WEATHER_si = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=ca"
let API_URL_FORECAST_si  = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=ca"


let API_URL_CURRENT_WEATHER_us = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=us"
let API_URL_FORECAST_us  = "https://api.darksky.net/forecast/\(API_KEY2)/\(LAT),\(LONG)?units=us"



