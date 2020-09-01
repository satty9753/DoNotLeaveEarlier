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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


extension WeekVC: NSTableViewDelegate, NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
}
