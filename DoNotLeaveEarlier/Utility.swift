//
//  Utility.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/2.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation

enum TimeStyle: String{
    case date = "yyyy-MM-dd"
    case time = "HH:mm:ss"
    case all = "yyyy-MM-dd HH:mm:ss"
}


extension Date{
    func toString(format: String = TimeStyle.date.rawValue) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}


extension String{
    func toDate(format: String = TimeStyle.all.rawValue)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
        
}
