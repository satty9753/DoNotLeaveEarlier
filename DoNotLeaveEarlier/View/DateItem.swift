//
//  DateItem.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/4.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

class DateItem: NSCollectionViewItem {
   
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var dateLabel: NSTextFieldCell!
    @IBOutlet weak var timeLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
