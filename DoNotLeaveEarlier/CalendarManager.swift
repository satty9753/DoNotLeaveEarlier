//
//  CalendarManager.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/2.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation


class CalenderManager{
    
    private var selectedDate: Date! = nil
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
    //        headerView.baseDate = baseDate
          }
        }

    private lazy var days = generateDaysInMonth(for: baseDate)

    private var numberOfWeeksInBaseDate: Int {
      calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

//    private let selectedDateChanged: ((Date) -> Void)?
    private let calendar = Calendar(identifier: .gregorian)

    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()

//    init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
//       self.selectedDate = baseDate
//       self.baseDate = baseDate
//       self.selectedDateChanged = selectedDateChanged
//     }
    
        init(baseDate: Date) {
           self.selectedDate = baseDate
           self.baseDate = baseDate
         }
    
}



// MARK: - Day Generation
extension CalenderManager {
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range(
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
      else {
        // 3
        throw CalendarDataError.metadataGeneration
    }

    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }
    
    
    func getDayInWeek(for baseDate: Date)->Int{
        let today = calendar.startOfDay(for: baseDate)
        let day = calendar.component(.weekday, from: today)
        return day
    }

    func generateDaysInWeek(for baseDate: Date) -> [Date] {
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        return days
        
    }
    

  // 1
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // 2
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }

    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay

    // 3
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // 4
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // 5
        let dayOffset =
          isWithinDisplayedMonth ?
          day - offsetInInitialRow :
          -(offsetInInitialRow - day)

        // 6
        return generateDay(
          offsetBy: dayOffset,
          for: firstDayOfMonth,
          isWithinDisplayedMonth: isWithinDisplayedMonth)
      }

    days += generateStartOfNextMonth(using: firstDayOfMonth)

    return days
  }
    


  // 7
  func generateDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate)
      ?? baseDate
    
    let punchInTime = Database.shared.find(day: date.toString())?.toString(format: TimeStyle.time.rawValue)
    

    return Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth,
      punchInTime: punchInTime
    )
  }

  // 1
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
    // 2
    guard
      let lastDayInMonth = calendar.date(
        byAdding: DateComponents(month: 1, day: -1),
        to: firstDayOfDisplayedMonth)
      else {
        return []
    }

    // 3
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }

    // 4
    let days: [Day] = (1...additionalDays)
      .map {
        generateDay(
        offsetBy: $0,
        for: lastDayInMonth,
        isWithinDisplayedMonth: false)
      }

    return days
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
}
