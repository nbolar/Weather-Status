//
//  WeatherCell.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa

class WeatherCell: NSCollectionViewItem {

    //Outlets
    
    @IBOutlet weak var weatherCellImage: NSImageView!
    @IBOutlet weak var cellDate: NSTextField!
    @IBOutlet weak var highTemp: NSTextField!
    @IBOutlet weak var lowTemp: NSTextField!
    @IBOutlet weak var weatherConditions: NSTextField!
    @IBOutlet weak var anchorText: NSTextField!
    let popoverView = NSPopover()
    
    override func awakeFromNib() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = CGColor.init(gray: 0.9, alpha: 0.2)
        self.view.layer?.cornerRadius = 8
        let area = NSTrackingArea.init(rect: weatherCellImage.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        weatherCellImage.addTrackingArea(area)
    }
    
    
    func configureCell(weatherCell: Forecast)
    {
        weatherCellImage.image = NSImage(named: weatherCell.weatherType.lowercased())
        weatherConditions.stringValue = "\(weatherCell.weatherType)"
        highTemp.stringValue = "\(weatherCell.highTemp)°"
        lowTemp.stringValue = "\(weatherCell.lowTemp)°"
        cellDate.stringValue = weatherCell.date
    }
    

    
    override func mouseEntered(with event: NSEvent) {
        displayPopUp(indexPath: index)

    }

    override func mouseExited(with event: NSEvent) {
        if popoverView.isShown{
            popoverView.close()

        }

    }
    
    func displayPopUp(indexPath : Int) {        
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc =  storyboard.instantiateController(withIdentifier: "ForecastWeather") as? NSViewController else { return }

        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: anchorText.bounds, of: anchorText, preferredEdge: .minY)
        
    }
    

    
}

