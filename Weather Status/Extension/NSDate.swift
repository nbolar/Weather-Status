//
//  NSDate.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/5/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation

extension Date {
    
    func dayOfTheWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: self)
    }
    
    func timeOfTheDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        
        return dateFormatter.string(from: self)
    }
}
