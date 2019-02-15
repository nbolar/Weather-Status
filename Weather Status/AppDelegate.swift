//
//  AppDelegate.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import CoreLocation
import Solar
import Network


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CLLocationManagerDelegate {

    //Variables
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var solar : Solar!
    let monitor = NWPathMonitor()
    
 

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        locationManager.delegate = self

        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                connected = 1
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startMonitoringSignificantLocationChanges()
                self.locationManager.distanceFilter = 1000
                self.locationManager.startUpdatingLocation()
            } else {
                connected = 0
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        statusItem.button?.title = "--°"
        statusItem.button?.action = #selector(AppDelegate.displayPopUp(_:))
        
        weatherInterval(interval: 15)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            currentLocation = locations[locations.count - 1]
            solar = Solar(coordinate: currentLocation.coordinate)
            Location.instance.latitude = currentLocation.coordinate.latitude
            Location.instance.longitude = currentLocation.coordinate.longitude
            downloadWeatherData()
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _ = dialogOKCancel(question: "Please Allow Location Access to Weather Status", text: "Enable access in Location Services in System Preferences and restart the app.")
        WeatherService.instance.currentWeather.cityName = "Please Provide Location Access in System Preferences"


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
        if CLLocationManager.authorizationStatus() == .authorizedAlways && connected == 1{
            let updateWeatherData = Timer.scheduledTimer(timeInterval: TimeInterval(60*interval), target: self, selector: #selector(AppDelegate.downloadWeatherData), userInfo: nil, repeats: true)
            updateWeatherData.tolerance = 60
        }
    }
    
    
    @objc func downloadWeatherData(){
        WeatherService.instance.downloadWeatherDetails {
            self.statusItem.button?.image = NSImage(named: "\(WeatherService.instance.currentWeather.weatherType.lowercased())_small")
            self.statusItem.button?.imagePosition = .imageLeft
            self.statusItem.button?.title = "\(WeatherService.instance.currentWeather.currentTemp)"
            
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

