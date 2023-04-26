//
//  File.swift
//  
//
//  Created by Jaylen Smith on 4/18/23.
//

import Foundation

extension Date {
    
    var fullDate: String {
        self.formatted(.dateTime.month().day().year())
    }
    
    var distanceDaysToExpired: Int {
        let endDate = self
        let days = endDate.timeIntervalSince(Date.now) / 86400
                
        return Int(days)
    }
}
