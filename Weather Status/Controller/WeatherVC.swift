//
//  WeatherVC.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Alamofire
import Foundation
import CoreLocation
import MapboxGeocoder


let geocoder = Geocoder(accessToken: "pk.eyJ1IjoibmJvbGFyIiwiYSI6ImNqczBlZHN5NzAyN2wzeWt2b3lsN3g3MGgifQ.cFYFmlHIY3HxQnIwK6n6Eg")
class WeatherVC: NSViewController,CLLocationManagerDelegate {
    

    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var tempLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var weatherImage: NSImageView!
    @IBOutlet weak var weatherConditionLabel: NSTextField!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var refreshed: NSTextField!
    @IBOutlet weak var farenheit: NSButton!
    @IBOutlet weak var celsius: NSButton!
    @IBOutlet weak var gestureImage: NSImageView!
    @IBOutlet weak var progressBar: RTProgressBar!
    @IBOutlet weak var summaryLabel: NSTextField!
    
    var type:String!
    static let instance = WeatherVC()
    var timerTest : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dateLabel.stringValue = "This is a date"
        collectionView.dataSource = self
        collectionView.delegate = self
        if celsi == 1 {
            fahrenheit = 0
            celsius.isHidden = true
            farenheit.isHidden = false
        }else if fahrenheit == 1{
            celsi = 0
            farenheit.isHidden = true
            celsius.isHidden = false
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherVC.dataDownloadedNotif(_:)), name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        self.view.layer?.backgroundColor = CGColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        check1 = 1
        updateUI()
    }
    
    
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
    }
    
    
    @objc func dataDownloadedNotif(_ notif: Notification){
        updateUI()
        
    }
    
    
    func updateUI() {
        
        let weather = WeatherService.instance.currentWeather
        
        if fahrenheit == 1
        {
            type = "F"
        }
        if celsi == 1{
            type = "C"
        }
        if weather.currentTemp == "--"{
            type = ""
        }
        if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            let options = ReverseGeocodeOptions(location: appDelegate.currentLocation)
            _ = geocoder.geocode(options, completionHandler: { (placemarks, attribution, error) in
                guard let placemark = placemarks?.first else {
                    return
                }
                self.locationLabel.stringValue = "\(placemark.formattedName), \(placemark.postalAddress?.city ?? "") \(placemark.postalAddress?.country ?? "")"
            })
        }
    
    

        dateLabel.stringValue = weather.date
        summaryLabel.stringValue = weather.hourlySummary
        tempLabel.stringValue = "\(weather.currentTemp)\(type ?? "--")"
        weatherConditionLabel.stringValue = weather.currentSummary
        weatherImage.image = NSImage(named: weather.weatherType.lowercased())

        
        if check1 == 1 && check2 == 0 && CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            check2 = 1
            gestureImage.isHidden = false
            gestureImage.layer?.backgroundColor = CGColor.init(gray: 0.1, alpha: 0.3)
            gestureImage.layer?.cornerRadius = 5
            Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.dismissText), userInfo: nil, repeats: false)
        }

        
        collectionView.reloadData()
    }
    

    @IBAction func celsiusButtonClicked(_ sender: Any) {
        
        units = 1
        let appDelegate = NSApplication.shared.delegate as! AppDelegate

        appDelegate.downloadWeatherData()
        updateUI()
        farenheit.isHidden = false
        celsius.isHidden = true
        fahrenheit = 0
        celsi = 1
        
        
    }
    @IBAction func farenheitButtonClciked(_ sender: Any) {
        
        units = 2
        let appDelegate = NSApplication.shared.delegate as! AppDelegate

        appDelegate.downloadWeatherData()
        updateUI()
        farenheit.isHidden = true
        celsius.isHidden = false
        celsi = 0
        fahrenheit = 1
        
        
    }
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        
        refreshed.isHidden = false
        progressBar.color = NSColor.white
        progressBar.backgroundColor = NSColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        progressBar.alphaValue = 1
        progressBar.progress = 0
        startProgressIteration()
        
        tempLabel.stringValue = "--"
        weatherConditionLabel.stringValue = "--"
        locationLabel.stringValue = "--"
        summaryLabel.isHidden = true
        
        if timerTest == nil {
            timerTest = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.wait), userInfo: nil, repeats: true)
        }

        
        Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.dismissText), userInfo: nil, repeats: false)
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApp.terminate(nil)
    }
    
    @objc func dismissText(){
        
        if refreshed.isHidden == false
        {
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.locationManager.requestLocation()
            appDelegate.downloadWeatherData()
            refreshed.isHidden = true
            summaryLabel.isHidden = false
            updateUI()
            
            if timerTest != nil {
                timerTest?.invalidate()
                timerTest = nil
            }
            
        }
        if gestureImage.isHidden == false{
            
            gestureImage.isHidden = true
        }
    }
    
    @objc func wait(){
        weatherImage.image = NSImage(named: "image\(Int.random(in: 1...11))")
    
    }
    

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MARK: - dealing with progress
    fileprivate func startProgressIteration() {
        if progressBar.indeterminate {
            progressBar.animating = true
        } else {
            let value = Double(45)
            let delay = Double(1)
            appendProgress(value, afterDelay: delay)
        }
    }
    
    fileprivate func appendProgress(_ progress: Double, afterDelay delay: TimeInterval) {
        // calculate time
        let interval = Int64(UInt64(delay) * NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(interval) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.appendProgress(progress)
        }
    }
    
    fileprivate func appendProgress(_ progress: Double) {
        progressBar.append(progress, animated: true)
        if progressBar.progress >= 100 {
            NSAnimationContext.runAnimationGroup({ context in
                self.progressBar.animator().alphaValue = 0
                //                self..isEnabled = true
                context.duration = 0
            }, completionHandler: nil)
        } else {
            startProgressIteration()
        }
        
    }
    


}






extension WeatherVC: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let forecastItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "WeatherCell"), for: indexPath)
        
        guard let forecastCell = forecastItem as? WeatherCell else { return forecastItem}
        forecastCell.configureCell(weatherCell: WeatherService.instance.forecast[indexPath.item])
        
        return forecastCell
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherService.instance.forecast.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 125, height: 125)
    }
    
    
    
}

