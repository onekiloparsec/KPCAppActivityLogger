//
//  AppDelegate.swift
//  KPCAppActivityLoggerDemo
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Cocoa
import CocoaLumberjack
import KPCAppActivityLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var appLogger: AppActivityLogger?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if self.appLogger == nil {
            self.appLogger = AppActivityLogger()
            DDLog.addLogger(self.appLogger)
        }
        
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

