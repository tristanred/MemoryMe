//
//  AppDelegate.swift
//  Memory Me macOS
//
//  Created by Tristan Dube on 2019-01-03.
//  Copyright © 2019 Tristan Dubé. All rights reserved.
//

import Cocoa

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        MSAppCenter.start("5eb2309d-f030-4af0-9d96-9468b04ea5d3", withServices:[
            MSAnalytics.self,
            MSCrashes.self
            ]);
        
        MSAnalytics.setEnabled(true);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

