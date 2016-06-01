//
//  AppActivityLoggerWindowController.swift
//  KPCAppActivityLogger
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation
import AppKit

class AppActivityWindowController: NSWindowController {
    @IBOutlet var logTextView: NSTextView?
    
    static func newWindowController(withLogger logger: AppActivityLogger) -> AppActivityWindowController {
        let wc = AppActivityWindowController(windowNibName: "ActivityLoggerWindow")
        return wc
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(refreshUponUpdate(_:)),
                                                         name: AppActivityLoggerDidUpdateNotification,
                                                         object: nil)
    }
    
    @objc private func refreshUponUpdate(notification: NSNotification) {
//        self.logTextView?.textStorage?.appendAttributedString(content);
    }
    
    

}