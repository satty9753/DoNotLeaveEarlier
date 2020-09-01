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
        titleCell.title = "AAA"
    }
    
}
