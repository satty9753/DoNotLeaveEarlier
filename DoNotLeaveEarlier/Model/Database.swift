//
//  Database.swift
//  PunchInRecord
//
//  Created by michelle on 2020/8/31.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation
import SQLite

class Database{
    static let shared = Database()
    
    private var db: Connection!
    
    private let recordTable = Table("Records")
    
    private let id = Expression<Int64>("id")
    
    private let date = Expression<String>("dateString")
    
    private let punchInTime = Expression<Date>("punchInTime")
    
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
                 t.column(date)
                 t.column(punchInTime)
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func save(today: Date){
        do{
            let todayDateString = today.toString()
            
            var value: Date?
            
            let results = try db.prepare(recordTable.filter(date==todayDateString))
            for r in results{
                value = r[punchInTime]
            }
            
            if value == nil{
                let insert = recordTable.insert(date<-todayDateString, punchInTime<-today)
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
            let records = try db.prepare(recordTable.filter(day == date))
            let record = records.first { (row) -> Bool in
                return true
            }
            return record?[punchInTime]
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func delete(day: String){
        do{
            let record = recordTable.filter(day == date)
            try db.run(record.delete())
        }catch{
            print(error.localizedDescription)
        }
    }
}
