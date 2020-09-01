//
//  VC+extension.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/1.
//  Copyright © 2020 michelle. All rights reserved.
//

import Foundation
import Cocoa

@nonobjc extension NSViewController {

    func add(_ child: NSViewController, frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        view.addSubview(child.view)
    }
    
    func remove() {
         self.children.first?.view.removeFromSuperview()
         self.children.first?.removeFromParent()
    }
}
