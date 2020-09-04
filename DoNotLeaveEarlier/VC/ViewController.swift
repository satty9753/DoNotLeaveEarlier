//
//  ViewController.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/1.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
//    var todayVC: NSViewController{
//        return storyboard?.instantiateController(withIdentifier: "TodayVC") as! TodayVC
//    }
//    var weekVC: NSViewController{
//        return storyboard?.instantiateController(withIdentifier: "WeekVC") as! WeekVC
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        changeView(segmentedControl)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func changeView(_ sender: NSSegmentedControl) {
        let todayVC = storyboard?.instantiateController(withIdentifier: "TodayVC") as! TodayVC
        let weekVC = storyboard?.instantiateController(withIdentifier: "WeekVC") as! WeekVC
        let monthVC = storyboard?.instantiateController(withIdentifier: "MonthVC") as! MonthVC
        
        remove()
        
        switch sender.selectedSegment {
        case 0:
            add(todayVC, frame: containerView.frame)
        case 1:
            add(weekVC, frame: containerView.frame)
        case 2:
            add(monthVC, frame: containerView.frame)
        default:
            print("default")
        }
        
    }
    

}



