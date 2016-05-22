//
//  AppActivityLoggerWindowController.swift
//  KPCAppActivityLogger
//
//  Created by Cédric Foellmi on 22/05/16.
//  Copyright © 2016 onekiloparsec. All rights reserved.
//

import Foundation
import AppKit

class AppActivityWindowController: NSWindowController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var entriesTableView: NSTableView?
    weak var logger: AppActivityLogger?
    
    static func newWindowController(withLogger logger: AppActivityLogger) -> AppActivityWindowController {
        let path = NSBundle(forClass: self).pathForResource("ActivityLoggerWindow", ofType: "nib")!
        let wc = AppActivityWindowController(windowNibPath: path, owner: self)
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
    }
    
    @objc private func refreshUponUpdate(notification: NSNotification) {
        self.entriesTableView?.reloadData()
    }

    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        self.entriesTableView?.reloadData()
        Swift.print("\(self.logger?.logFullContent())")
    }
    
    
//    - (void)reloadEntriesTableView:(NSNotification *)notif
//    {
//    [self.entriesTableView reloadData];
//    }
//    
//    #pragma mark - NSTableViewDataSource
//    
//    - (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
//    {
//    return [_allEntries count];
//    }
//    
//    - (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//    {
//    KPCActivityLogEntry *entry = [_allEntries objectAtIndex:row];
//    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:nil];
//    
//    if ([tableColumn.identifier isEqualToString:@"DateColumn"]) {
//    cellView.textField.text = [entry.date description];
//    }
//    else if ([tableColumn.identifier isEqualToString:@"TypeColumn"]) {
//    cellView.textField.text = KPCActivityLogEntryTypeString(entry.type);
//    }
//    else if ([tableColumn.identifier isEqualToString:@"MessageColumn"]) {
//    cellView.textField.text = entry.title;
//    
//    if ([entry.shortDescription length] > 0) {
//    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] init];
//    [s appendAttributedString:[[NSAttributedString alloc] initWithString:cellView.textField.text]];
//    
//    NSDictionary *shortDescriptionAttr = @{NSForegroundColorAttributeName : [NSColor secondaryLabelColor],
//    NSFontAttributeName : [NSFont labelFontOfSize:11.0]};
//    
//    [s appendAttributedString:[[NSAttributedString alloc] initWithString:@" (" attributes:shortDescriptionAttr]];
//    [s appendAttributedString:[[NSAttributedString alloc] initWithString:entry.shortDescription attributes:shortDescriptionAttr]];
//    [s appendAttributedString:[[NSAttributedString alloc] initWithString:@")" attributes:shortDescriptionAttr]];
//    
//    [cellView.textField setAttributedStringValue:[s copy]];
//    }
//    }
//    
//    return cellView;
//    }
//    

}