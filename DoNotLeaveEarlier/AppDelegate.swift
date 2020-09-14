//
//  AppDelegate.swift
//  DoNotLeaveEarlier
//
//  Created by michelle on 2020/9/1.
//  Copyright © 2020 michelle. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var mainMenu: NSMenu!
    
    var exportWindow: NSWindow? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        Database.shared.save(today: Date())
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func export(_ sender: NSMenuItem) {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        let exportVC = storyboard.instantiateController(withIdentifier: "ExportVC") as! ExportVC
        
        
        exportWindow = NSWindow(contentViewController: exportVC)
        exportWindow?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: exportWindow)
        vc.showWindow(self)
        
    }
    
   
    
}

