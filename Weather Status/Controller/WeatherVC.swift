//
//  WeatherVC.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Alamofire


class WeatherVC: NSViewController {
    

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.stringValue = "This is a date"
        collectionView.dataSource = self
        collectionView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherVC.dataDownloadedNotif(_:)), name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        self.view.layer?.backgroundColor = CGColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
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
        dateLabel.stringValue = weather.date
        locationLabel.stringValue = weather.cityName
        tempLabel.stringValue = "\(weather.currentTemp)°"
        weatherConditionLabel.stringValue = weather.weatherType
        weatherImage.image = NSImage(named: weather.weatherType.lowercased())
        collectionView.reloadData()
    }
    

    @IBAction func celsiusButtonClicked(_ sender: Any) {
        
        units = 1
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.downloadWeatherData()
        updateUI()
        farenheit.isHidden = false
        celsius.isHidden = true
        
        
    }
    @IBAction func farenheitButtonClciked(_ sender: Any) {
        
        units = 2
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.downloadWeatherData()
        updateUI()
        farenheit.isHidden = true
        celsius.isHidden = false
        
        
    }
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        refreshed.isHidden = false

        weatherImage.image = NSImage(named: "icons8-update-100")
        tempLabel.stringValue = "--"
        weatherConditionLabel.stringValue = "--"

        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.dismissText), userInfo: nil, repeats: false)
    }
    
    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApp.terminate(nil)
    }
    
    @objc func dismissText(){
        
        if refreshed.isHidden == false
        {
            
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.downloadWeatherData()
            refreshed.isHidden = true
            updateUI()
        }
    }
    

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
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

