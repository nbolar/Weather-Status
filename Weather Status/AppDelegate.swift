//
//  AppDelegate.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //Variables
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(AppDelegate.displayPopUp(_:))
        
        let updateWeatherData = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(AppDelegate.downloadWeatherData), userInfo: nil, repeats: true)
        
    }
    
    @objc func downloadWeatherData(){
        WeatherService.instance.downloadWeatherDetails {
            self.statusItem.button?.image = NSImage(named: "\(WeatherService.instance.currentWeather.weatherType)_small")
            
            self.statusItem.button?.title = "             \(WeatherService.instance.currentWeather.currentTemp)°"
            WeatherService.instance.downloadForecast(completed: {
                NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
                
            })
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func displayPopUp(_ sender: AnyObject?) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc =  storyboard.instantiateController(withIdentifier: "WeatherVC") as? NSViewController else { return }
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .minY)
        
    }


}

