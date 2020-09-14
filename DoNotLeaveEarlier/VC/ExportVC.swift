//
//  ExportVC.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/7.
//  Copyright © 2020 michelle. All rights reserved.
//


import Cocoa

class ExportVC: NSViewController {
    
    var dateFormat: DateFormat!
    @IBOutlet weak var fromDatePicker: NSDatePicker!
    @IBOutlet weak var toDatePicker: NSDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func export(_ sender: NSButton) {
        exportFormat(dateFormat)
    }
    
    @IBAction func dateFormatSelect(_ sender: NSButton) {
        dateFormat = DateFormat(rawValue: sender.tag)
    }
    
    func exportFormat( _ dateFormat: DateFormat){
        let openPanel = NSSavePanel()
        openPanel.canCreateDirectories = true
        openPanel.allowedFileTypes = ["txt"]
        openPanel.begin
            { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue
                {
                    let url = openPanel.url
                    
                    var numbersOfDate = [Date?]()
                    
                    switch dateFormat {
                    case .day:
                        let today = Database.shared.find(day: Date().toString())
                        numbersOfDate = [today]
                    case .week:
                        numbersOfDate = Database.shared.getThisWeek(date: Date())
                    case .month:
                        numbersOfDate = Database.shared.getThisMonth(date: Date())
                    case .custom:
                        let from = self.fromDatePicker.dateValue
                        let to = self.toDatePicker.dateValue
                        
                        numbersOfDate = Database.shared.getCustomDate(from: from, to: to)
                    }
                    
                    var dataString = ""
                    
                    if numbersOfDate.count > 0{
                        
                        let data = numbersOfDate.map{
                            $0?.toString(format: TimeStyle.all.rawValue) }
                        
                        data.forEach { (s) in
                            dataString.append(s ?? "")
                            dataString.append("\n")
                        }
                    }else{
                        dataString = "NO DATA in your selected periods. ಠ_ಠ"
                    }
                    
                    do{
                        if let url = url {
                            try dataString.write(to: url, atomically: true, encoding: .utf8)
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    
}
