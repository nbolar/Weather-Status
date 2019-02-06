//
//  Location.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/6/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation

class Location {
    
    static var instance = Location()
    
    fileprivate var _latitiude: Double!
    fileprivate var _longitude: Double!
    
    
    var latitude: Double {
        get {
            return _latitiude ?? 0
        } set {
            _latitiude = newValue
        }
    }
    
    var longitude: Double {
        get {
            return _longitude ?? 0
        } set {
            _longitude = newValue
        }
    }
    
}
