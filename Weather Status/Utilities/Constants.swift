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

let API_KEY1 = "&appid=691657a05faabbd6ef5736fbcdcf951f"
let API_KEY2 = "47c545315eff2221c6346d3ee071083d"
let API_URL_CURRENT_WEATHER = "https://api.openweathermap.org/data/2.5/weather?lat=33.65&lon=-112.13&units=metric\(API_KEY1)"
let API_URL_FORECAST  = "https://api.darksky.net/forecast/\(API_KEY2)/33.65,-112.13?units=si"


