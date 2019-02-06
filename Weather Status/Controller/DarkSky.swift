//
//  DarkSky.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/6/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import WebKit

class DarkSky: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let url = URL(string: "https://darksky.net/poweredby/"){
            let request = URLRequest(url: url)
            webView.load(request)
        }

    }
    
}
