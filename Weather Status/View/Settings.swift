//
//  Settings.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/8/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa

class Settings: NSViewController {
    
    var value: Int!
    var compare: Int!
    
    @IBOutlet weak var oneMinute: NSButton!
    @IBOutlet weak var fiveMinutes: NSButton!
    @IBOutlet weak var tenMinutes: NSButton!
    @IBOutlet weak var fifteenMinutes: NSButton!
    @IBOutlet weak var thirtyMinutes: NSButton!
    @IBOutlet weak var sixtyMinutes: NSButton!
    @IBOutlet weak var updatedLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .clear
//        self.view.layer?.backgroundColor = CGColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        self.view.layer?.cornerRadius = 5
        retainButton(flag: interval)
//        (oneMinute.cell! as! NSButtonCell).backgroundColor = .init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        
    }
    
    @IBAction func buttonClicked(_ sender: NSButton){
        updatedLabel.isHidden = false
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.weatherInterval(interval: sender.tag)
        interval = sender.tag
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissLabel), userInfo: nil, repeats: false)
        
    }
    
    func retainButton(flag : Int)
    {
        let temp = self.view.viewWithTag(flag) as? NSButton
        temp?.state = .on
    }
    
    @objc func dismissLabel()
    {
        updatedLabel.isHidden = true
        
    }
    
    
}
