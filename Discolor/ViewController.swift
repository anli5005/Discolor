//
//  ViewController.swift
//  Discolor
//
//  Created by Anthony Li on 4/20/20.
//  Copyright © 2020 Anthony Li. All rights reserved.
//

import Cocoa
import Combine

class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var autoChangeSwitch: NSSwitch?

    private var cancellables = Set<AnyCancellable>()
    
    var currentAppearance: NSAppearance.Name?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentAppearance = view.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        
        autoChangeSwitch?.state = UserDefaults.standard.bool(forKey: AppDelegate.autoChangeKey) ? .on : .off

        view.publisher(for: \.effectiveAppearance).sink { [unowned self] appearance in
            let name = appearance.bestMatch(from: [.darkAqua, .aqua])
            if name != self.currentAppearance {
                self.currentAppearance = name
                if UserDefaults.standard.bool(forKey: AppDelegate.autoChangeKey) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        try? (NSApp.delegate as! AppDelegate).changeColor(to: name == .darkAqua ? .dark : .light, activateDiscord: !UserDefaults.standard.bool(forKey: AppDelegate.doNotActivateDiscordDefaultsKey), returnFocus: !UserDefaults.standard.bool(forKey: AppDelegate.noReturnFocusDefaultsKey))
                    }
                }
            }
        }.store(in: &cancellables)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
        view.window?.collectionBehavior.insert(.canJoinAllSpaces)
        (NSApp.delegate as! AppDelegate).window = view.window
    }
    
    @IBAction func light(sender: NSButton?) {
        try? (NSApp.delegate as! AppDelegate).changeColor(to: .light, activateDiscord: !UserDefaults.standard.bool(forKey: AppDelegate.doNotActivateDiscordDefaultsKey), returnFocus: !UserDefaults.standard.bool(forKey: AppDelegate.noReturnFocusDefaultsKey))
    }

    @IBAction func dark(sender: NSButton?) {
        try? (NSApp.delegate as! AppDelegate).changeColor(to: .dark, activateDiscord: !UserDefaults.standard.bool(forKey: AppDelegate.doNotActivateDiscordDefaultsKey), returnFocus: !UserDefaults.standard.bool(forKey: AppDelegate.noReturnFocusDefaultsKey))
    }
    
    @IBAction func matchSystem(sender: NSButton?) {
        try? (NSApp.delegate as! AppDelegate).changeColor(to: view.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? .dark : .light, activateDiscord: !UserDefaults.standard.bool(forKey: AppDelegate.doNotActivateDiscordDefaultsKey), returnFocus: !UserDefaults.standard.bool(forKey: AppDelegate.noReturnFocusDefaultsKey))
    }
    
    @IBAction func autoChangeSwitched(sender: NSSwitch?) {
        UserDefaults.standard.set(sender?.state == .on, forKey: AppDelegate.autoChangeKey)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
}

