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
    private let shared = Database()
    
    private var db: Connection!
    
    private let recordTable = Table("Records")
    
    private let id = Expression<Int64>("id")
    
    private let date = Expression<Date>("date")
    
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
            try db.run(recordTable.create{ t in
                 t.column(id)
                 t.column(date)
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func save(day:Date, record: Date){
        do{
            let insert = recordTable.insert(date<-day, punchInTime<-record)
            try db.run(insert)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func delete(day: Date){
        do{
            let record = recordTable.filter(day == date)
            try db.run(record.delete())
        }catch{
            print(error.localizedDescription)
        }
    }
}
