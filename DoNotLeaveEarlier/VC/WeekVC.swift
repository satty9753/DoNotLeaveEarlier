//
//  WeekVC.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/1.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

class WeekVC: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    @objc dynamic var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.delegate = self
        
        let week:[Record] = CalenderManager.shared.generateDaysInWeek(for: Date()).map{
            let date = $0.toString()
            let value = Database.shared.find(day: date)
            
            let dateWithWeek = $0.toString(format: "yyyy-MM-dd(EEEE)")
            
            let record = Record(dateWithWeek, value?.toString(format: TimeStyle.time.rawValue))
                return record
        } 
        
        self.records.append(contentsOf: week)
        
        selectToday()
        
    }
    
    func selectToday(){
        let index = CalenderManager.shared.getDayInWeek(for: Date()) 
        
        let indexSet = IndexSet(integer: index-1)
        
        tableView.selectRowIndexes(indexSet, byExtendingSelection: false)
    }
    
}


extension WeekVC: NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.records.count
    }
}
