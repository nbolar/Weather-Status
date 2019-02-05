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
    
    func downloadWeatherDetails ()
    {
        let url = URL(string: API_URL_CURRENT_WEATHER)
        AF.request(url!).responseJSON { (response) in
            print(response.result.value)
        }
        
    }
}
