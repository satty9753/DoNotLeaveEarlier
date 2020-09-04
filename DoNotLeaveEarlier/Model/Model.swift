//
//  Model.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/2.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation

@objcMembers class Record: NSObject{
    var date: String?
    var punchInTime: String?
    
    init(_ date: String?, _ punchInTime: String?){
        self.date = date
        self.punchInTime = punchInTime
    }
}


struct Day {
  // 1
  let date: Date
  // 2
  let number: String
  // 3
  let isSelected: Bool
  // 4
  let isWithinDisplayedMonth: Bool
}


struct MonthMetadata {
  let numberOfDays: Int
  let firstDay: Date
  let firstDayWeekday: Int
}
