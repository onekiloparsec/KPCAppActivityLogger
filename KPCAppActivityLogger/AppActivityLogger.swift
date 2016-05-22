//
//  AppActivityLogger.swift
//  KPCAppActivityLogger
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import AppKit

@objc public protocol WindowHashing {
    func hash() -> String
}

public let AppActivityLoggerDidUpdateNotification = "AppActivityLoggerDidUpdateNotification"

let AppNotifications = [NSApplicationDidBecomeActiveNotification,
                        NSApplicationDidChangeScreenParametersNotification,
                        NSApplicationDidFinishLaunchingNotification,
                        NSApplicationDidHideNotification,
                        NSApplicationDidResignActiveNotification,
                        NSApplicationDidUnhideNotification,
//                        NSApplicationDidUpdateNotification,
                        NSApplicationWillBecomeActiveNotification,
                        NSApplicationWillFinishLaunchingNotification,
                        NSApplicationWillHideNotification,
                        NSApplicationWillResignActiveNotification,
                        NSApplicationWillTerminateNotification,
                        NSApplicationWillUnhideNotification,
//                        NSApplicationWillUpdateNotification,
                        NSApplicationDidFinishRestoringWindowsNotification,
                        NSApplicationDidChangeOcclusionStateNotification]

let WindowNotifications = [NSWindowWillCloseNotification]

public class AppActivityLogger: DDFileLogger {
    
    private var windowController: AppActivityWindowController?
    
    override init!(logFileManager: DDLogFileManager!) {
        super.init(logFileManager: logFileManager)
        self.rollingFrequency = 60 * 60 * 24 * 7 // weekly rolling
        
        for appNotification in AppNotifications {
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(logUponAppNotification(_:)),
                                                             name: appNotification,
                                                             object: nil)
        }

        for appNotification in WindowNotifications {
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(logUponWindowNotification(_:)),
                                                             name: appNotification,
                                                             object: nil)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func didAddLogger() {
        DDLogInfo("\n\n Activity Start \n\n")
    }
    
    @objc private func logUponAppNotification(notification: NSNotification) {
        DDLogInfo(notification.name)
        NSNotificationCenter.defaultCenter().postNotificationName(AppActivityLoggerDidUpdateNotification, object: self)
    }
    
    @objc private func logUponWindowNotification(notification: NSNotification) {
        var message = notification.name
        if notification.object?.conformsToProtocol(WindowHashing) == true {
            let window = notification.object as! WindowHashing
            message += " window." + window.hash()
        }
        DDLogInfo(message)
        NSNotificationCenter.defaultCenter().postNotificationName(AppActivityLoggerDidUpdateNotification, object: self)
    }
    
    public func logFinalQuit() {
        DDLogInfo("Final Quit")
        NSNotificationCenter.defaultCenter().postNotificationName(AppActivityLoggerDidUpdateNotification, object: self)
    }
    
    @IBAction public func openActivityLogger(sender: AnyObject?) {
        if self.windowController == nil {
            self.windowController = AppActivityWindowController.newWindowController(withLogger: self)
        }
        self.windowController!.showWindow(self)
    }
    
    func logFullContent() -> String {
        return "hey"
    }
}


