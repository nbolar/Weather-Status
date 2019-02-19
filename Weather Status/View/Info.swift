//
//  Info.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/6/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Foundation

class Info: NSViewController {
    
    @IBAction func unsplashClicked(_ sender: Any) {
        
        let url = URL(string: "https://unsplash.com/search/photos/gradient")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func poweredByButtonClicked(_ sender: Any) {
        let url = URL(string: "https://darksky.net/poweredby/")!
        NSWorkspace.shared.open(url)
        
    }
    
    @IBAction func openWeatherButtonClicked(_ sender: Any) {
        let url = URL(string: "https://www.mapbox.com")!
        NSWorkspace.shared.open(url)
        
    }
    @IBAction func glyphsButtonClicked(_ sender: Any) {
        let url = URL(string: "https://icons8.com/")!
        NSWorkspace.shared.open(url)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
//        self.view.layer?.backgroundColor = CGColor.init(red: 0.39, green: 0.72, blue: 1.0, alpha: 0.9)
        self.view.layer?.cornerRadius = 5
        let image = NSImage(named: "wallpaper1")
        self.view.layer?.contents = image
                
    }

}
