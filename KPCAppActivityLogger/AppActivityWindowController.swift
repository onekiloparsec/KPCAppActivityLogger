//
//  AppActivityLoggerWindowController.swift
//  KPCAppActivityLogger
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation
import AppKit

class AppActivityWindowController: NSWindowController, NSStreamDelegate {
    @IBOutlet var logTextView: NSTextView?
    private var readStream: NSInputStream?
    private weak var logger: AppActivityLogger?
    
    static func newWindowController(withLogger logger: AppActivityLogger) -> AppActivityWindowController {
        let wc = AppActivityWindowController(windowNibName: "ActivityLoggerWindow")
        wc.logger = logger
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
        
        guard let path = self.logger?.logFileManager.sortedLogFilePaths().first else {
            print("hum, no file path to work with?")
            return
        }
        
        self.readStream = NSInputStream(fileAtPath: path as! String)
        self.readStream?.delegate = self
        self.readStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.readStream?.open()
    }
    
    @objc private func refreshUponUpdate(notification: NSNotification) {
//        self.logTextView?.textStorage?.appendAttributedString(content);
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.None:
            break
        case NSStreamEvent.OpenCompleted:
            break
        case NSStreamEvent.HasBytesAvailable:
            var buffer: [UInt8] = []
            var length: Int = 0
            length = self.readStream!.read(&buffer, maxLength: 128)
            if (length > 0) {
                let s = String(data: NSData(bytes: buffer, length: length), encoding: NSUTF8StringEncoding)
                print("\(s!)")
            }
        case NSStreamEvent.HasSpaceAvailable:
            break
        case NSStreamEvent.ErrorOccurred:
            print("\(aStream.streamError)")
        case NSStreamEvent.EndEncountered:
            break
        default:
            break
        }
    }
    

}