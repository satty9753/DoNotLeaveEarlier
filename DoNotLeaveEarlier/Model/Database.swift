//
//  Database.swift
//  PunchInRecord
//
//  Created by michelle on 2020/8/31.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation
import SQLite

enum TimeFormat{
    case day
    case week
    case month
}

class Database{
    static let shared = Database()
    
    private var db: Connection!
    
    private let recordTable = Table("Records")
    
    private let id = Expression<Int64>("id")
    
    private let dateColumn = Expression<String>("dateString")
    
//    private let monthColumn = Expression<String>("month")
//
//    private let yearColumn = Expression<String>("year")
    
    private let punchInTimeColumn = Expression<Date>("punchInTime")
    
    private init(){
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        documentsURL.appendPathComponent("sqlite.db")
        do{
            db = try Connection(documentsURL.absoluteString)
            createTable()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    private func createTable(){
        do{
            try db.run(recordTable.create(ifNotExists: true){ t in
                 t.column(id, primaryKey: true)
                 t.column(dateColumn)
//                 t.column(monthColumn)
//                 t.column(yearColumn)
                 t.column(punchInTimeColumn)
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func save(today: Date){
        do{
            let todayDateString = today.toString()
            var value: Date?
            
            let results = try db.prepare(recordTable.filter(dateColumn==todayDateString))
            for r in results{
                value = r[punchInTimeColumn]
            }
//
//            let year = today.toString(format: "YYYY")
//            let month = today.toString(format: "MM")
            
            if value == nil{
                let insert = recordTable.insert(dateColumn<-todayDateString, punchInTimeColumn<-today)
                try db.run(insert)
                print("save successfully")
                let noti = Notification(name: Notification.Name(rawValue: "SaveSuccess"))
                NotificationCenter.default.post(noti)
            }else{
                print("Today's record already exists.")
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func find(day:String)->Date?{
        do{
            let records = try db.prepare(recordTable.filter(day == dateColumn))
            let record = records.first { (row) -> Bool in
                return true
            }
            return record?[punchInTimeColumn]
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getThisWeek(date: Date)->[Date]{
        
        var numbersOfDate = [Date]()
        
        do{
            let weekdays = CalenderManager.shared.generateDaysInWeek(for: date)
            
            guard let lowerBound = weekdays.first, let upperBound = weekdays.last else{
                return []}
            
            let table = recordTable.filter(lowerBound..<upperBound ~= punchInTimeColumn)
            
            for row in try db.prepare(table){
                numbersOfDate.append(row[punchInTimeColumn])
            }
            
        }catch{
            print(error.localizedDescription)
        }
        return numbersOfDate
    }
    
    func getThisMonth(date: Date)->[Date]{
        var numbersOfDate = [Date]()
        do{
            let monthDays = CalenderManager.shared.generateDaysInMonth(for: date)
            
            guard let lowerBound = monthDays.first?.date, let upperBound = monthDays.last?.date else{
                return []}
            
            let table = recordTable.filter(lowerBound..<upperBound ~= punchInTimeColumn)
            
            for row in try db.prepare(table){
                numbersOfDate.append(row[punchInTimeColumn])
            }
            
        }catch{
            print(error.localizedDescription)
        }
        return numbersOfDate
    }
    
    func getCustomDate(from:Date, to:Date)->[Date]{
        
        var numbersOfDate = [Date]()
        
        let table = recordTable.filter(from..<to ~= punchInTimeColumn)
        do{
            for row in try db.prepare(table){
                numbersOfDate.append(row[punchInTimeColumn])
            }
        }catch{
            print(error.localizedDescription)
        }
        
        return numbersOfDate
    }
    
    
    func delete(day: String){
        do{
            let record = recordTable.filter(day == dateColumn)
            try db.run(record.delete())
        }catch{
            print(error.localizedDescription)
        }
    }
}
