//
//  MonthVC.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/2.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

class MonthVC: NSViewController {
    @IBOutlet weak var titleLabel: NSTextFieldCell!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    
    var calenderManager: CalenderManager?
    
    let cellId = NSUserInterfaceItemIdentifier("DateItem")
    
    var days:[Day]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let date = Date()
        
        titleLabel.title = date.toString(format: "YYYY-MM")
        calenderManager = CalenderManager(baseDate: date)
        days = calenderManager?.generateDaysInMonth(for: date)

        collectionView.register(DateItem.self, forItemWithIdentifier: cellId)
    }
    
}


extension MonthVC: NSCollectionViewDelegate, NSCollectionViewDataSource{
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: cellId, for: indexPath) as? DateItem
        cell?.dateLabel.title = days?[indexPath.item].number ?? ""
        return cell!
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return days?.count ?? 0
    }
}


extension MonthVC: NSCollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.frame.width/8.0, height: collectionView.frame.height/5.0)
    }
}
