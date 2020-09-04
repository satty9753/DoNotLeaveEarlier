//
//  TodayVC.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/1.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

class TodayVC: NSViewController {

    @IBOutlet weak var titleCell: NSTextFieldCell!
    @IBOutlet weak var titleLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showTimeLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTimeLabel), name: Notification.Name(rawValue: "SaveSuccess"), object: nil)
        
    }

    @objc func showTimeLabel(){
        DispatchQueue.main.async {
            self.titleCell.title = self.getTodayRecord() ?? ""
        }
    }
    
    func getTodayRecord()->String?{
        let today = Date().toString()
        let punchInTime = Database.shared.find(day: today)
        return punchInTime?.toString(format: TimeStyle.time.rawValue)
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NotificationCenter.default.removeObserver(self)
    }
    
}
