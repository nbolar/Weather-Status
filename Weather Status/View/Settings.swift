//
//  Settings.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/8/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import CoreLocation

class Settings: NSViewController,CLLocationManagerDelegate {
    
    var value: Int!
    var compare: Int!
    
    @IBOutlet weak var oneMinute: NSButton!
    @IBOutlet weak var fiveMinutes: NSButton!
    @IBOutlet weak var tenMinutes: NSButton!
    @IBOutlet weak var fifteenMinutes: NSButton!
    @IBOutlet weak var thirtyMinutes: NSButton!
    @IBOutlet weak var sixtyMinutes: NSButton!
    @IBOutlet weak var updatedLabel: NSTextField!
    @IBOutlet weak var internetLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .clear
//        self.view.layer?.backgroundColor = CGColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        self.view.layer?.cornerRadius = 5
//        oneMinute.layer?.backgroundColor = CGColor.init(gray: 0.1, alpha: 0.2)
        retainButton(flag: interval)
//        (oneMinute.cell! as! NSButtonCell).backgroundColor = NSColor.init(white: 0.1, alpha: 0.0)
        
    }
    
    @IBAction func buttonClicked(_ sender: NSButton){
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.weatherInterval(interval: sender.tag)
        interval = sender.tag
        
        if connected == 1 {
            updatedLabel.isHidden = false
        } else if connected == 0 {
            internetLabel.isHidden = false
        }

        
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            if connected == 1{
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissLabel), userInfo: nil, repeats: false)
        }else if CLLocationManager.authorizationStatus() == .denied{
            
            Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.dismissLabel), userInfo: nil, repeats: false)
        }else if CLLocationManager.authorizationStatus() == .notDetermined{
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissLabel), userInfo: nil, repeats: false)
        }
        
        
        
    }
    }
    @IBAction func infoButtonClicked(_ sender: Any) {
        self.dismiss(self)
        
    }
    
    func retainButton(flag : Int)
    {
        let temp = self.view.viewWithTag(flag) as? NSButton
        temp?.state = .on
    }
    
    @objc func dismissLabel()
    {
        
        updatedLabel.isHidden = true
        internetLabel.isHidden = true
        self.dismiss(self)

        
    }
    
    
    
}
