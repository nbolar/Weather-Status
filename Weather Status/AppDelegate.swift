//
//  AppDelegate.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import CoreLocation


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CLLocationManagerDelegate {

    //Variables
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
 

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
        
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(AppDelegate.displayPopUp(_:))
        
        weatherInterval(interval: 15)
        
        

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            currentLocation = locations[locations.count - 1]
            Location.instance.latitude = currentLocation.coordinate.latitude
            Location.instance.longitude = currentLocation.coordinate.longitude
            downloadWeatherData()
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _ = dialogOKCancel(question: "Please Allow Location Access to Weather Status", text: "Enable access in Location Services in System Preferences and restart the app.")

        
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool{
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "System Preferences")
        alert.buttons[1].target = self
        alert.buttons[1].action = #selector(openPrefs)
        alert.buttons[1].highlight(true)
        return alert.runModal() == .alertFirstButtonReturn
        
        
    }
    
    @objc func openPrefs()
    {

        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!
        NSWorkspace.shared.open(url)
        NSApp.terminate(nil)


    }
    
    
    
    func weatherInterval(interval : Int)
    {
        
        let updateWeatherData = Timer.scheduledTimer(timeInterval: TimeInterval(60*interval), target: self, selector: #selector(AppDelegate.downloadWeatherData), userInfo: nil, repeats: true)
        updateWeatherData.tolerance = 60
        
    }
    
    @objc func downloadWeatherData(){

        WeatherService.instance.downloadWeatherDetails {
            self.statusItem.button?.image = NSImage(named: "\(WeatherService.instance.currentWeather.weatherType.lowercased())_small")
            self.statusItem.button?.title = "             \(WeatherService.instance.currentWeather.currentTemp)"
            
            WeatherService.instance.downloadForecast(completed: {
                NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
                self.locationManager.stopUpdatingLocation()
                
            })
        }
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

