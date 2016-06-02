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
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(prepareToClose(_:)),
                                                         name: NSWindowWillCloseNotification,
                                                         object: self.window)
        
        self.openReadStream()
    }
    
    private func openReadStream() {
        if self.readStream != nil {
            return
        }
        
        guard let path = self.logger?.logFileManager.sortedLogFilePaths().first else {
            print("hum, no file path to work with?")
            return
        }
        
        self.readStream = NSInputStream(fileAtPath: path as! String)
        self.readStream?.delegate = self
        self.readStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.readStream?.open()
    }
    
    private func closeReadStream() {
        if self.readStream == nil {
            return
        }
        
        self.readStream?.close()
        self.readStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.readStream = nil
    }
    
    @objc private func refreshUponUpdate(notification: NSNotification) {
//        self.logTextView?.textStorage?.appendAttributedString(content);
    }
    
    @objc private func prepareToClose(notification: NSNotification) {
        self.closeReadStream()
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
                let string = String(data: NSData(bytes: buffer, length: length), encoding: NSUTF8StringEncoding)
                let attr: [String: AnyObject] = [NSFontAttributeName: NSFont(name: "Courier", size: 14)!]
                let astring = NSAttributedString(string: string!, attributes: attr)
                self.logTextView?.textStorage?.appendAttributedString(astring);
                self.logTextView?.scrollToEndOfDocument(self)
            }
        case NSStreamEvent.HasSpaceAvailable:
            break
        case NSStreamEvent.ErrorOccurred:
            print("\(aStream.streamError)")
            self.closeReadStream()
            self.openReadStream()
        case NSStreamEvent.EndEncountered:
            break
        default:
            break
        }
    }
    

}