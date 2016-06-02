//
//  ViewController.swift
//  KPCAppActivityLoggerDemo
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Cocoa
import KPCAppActivityLogger

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField?
    @IBOutlet weak var appendButton: NSButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openAppLogger(sender: AnyObject?) {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.appLogger?.openActivityLogger(sender)
    }

    @IBAction func appendToLogger(sender: AnyObject?) {
        if let message = self.textField?.stringValue {
            let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.appLogger?.logInfo(message)
            self.textField?.stringValue = ""
            print("\(message)")
        }
    }

}

