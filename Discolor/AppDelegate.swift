//
//  AppDelegate.swift
//  Discolor
//
//  Created by Anthony Li on 4/20/20.
//  Copyright © 2020 Anthony Li. All rights reserved.
//

import Cocoa
import ApplicationServices
import Quartz

enum DiscordAppearance {
    case light
    case dark
}

enum ColorChangeError: Error {
    case discordNotRunning
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static let autoChangeKey = "DiscolorAutomaticallyChangeOnAppearanceChange"
    var item: NSStatusItem!
    weak var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.title = "☯️"
        item.button?.target = self
        item.button?.action = #selector(show(sender:))
        
        NSApp.hide(nil)
    }
    
    @objc func show(sender: Any?) {
        NSApp.unhide(nil)
        window?.level = .floating
        window?.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
        
    func changeColor(to appearance: DiscordAppearance) throws {
        guard let discord = NSRunningApplication.runningApplications(withBundleIdentifier: "com.hnc.Discord").first else {
            throw ColorChangeError.discordNotRunning
        }
        
        let pid = discord.processIdentifier
        print("Discord's PID is \(pid)")
        
        let tab: CGKeyCode = 0x30
        
        let additionalTabs = appearance == .dark ? 11 : 12
        var keys = [CGKeyCode]()
        keys += [0xFF, 0x28, 0xFE, 0x35, 0xFF, 0x2B, 0xFE] // Open then close quick switcher, then open Preferences
        keys += [CGKeyCode](repeating: tab, count: 16) // Tab to Appearance
        keys += [0x31] // Open Appearance
        keys += [CGKeyCode](repeating: tab, count: additionalTabs) // Tab to desired color scheme
        keys += [0x31, 0x35] // Select and exit
        var i = 0
        
        var process: (() -> Void)?
        var flags = CGEventFlags()
        process = {
            let key = keys[i]
            
            var down: CGEvent?
            var up: CGEvent?
            
            if key == 0xFF {
                flags.insert(.maskCommand)
            } else if key == 0xFE {
                flags.remove(.maskCommand)
            } else {
                down = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: true)!
                up = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: false)!
            }
            
            down?.flags = flags
            up?.flags = flags
            
            down?.postToPid(pid)
            up?.postToPid(pid)
            
            i += 1
            if i < keys.count {
                if keys[i] != key {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: process!)
                } else {
                    process!()
                }
            }
        }
        
        process!()
    }


}

