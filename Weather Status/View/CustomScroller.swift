//
//  CustomScroller.swift
//  Weather Status
//
//  Created by Nikhil Bolar on 2/14/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa

class CustomScroller: NSScrollView {
    
    override func awakeFromNib() {
        let area = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseMoved], owner: self, userInfo: nil)
        addTrackingArea(area)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseMoved(with event: NSEvent) {

        var pointInView = convert(event.locationInWindow, from: nil)
        pointInView.x += documentVisibleRect.origin.x
        
        if let collectionView = documentView as? NSCollectionView{
            if let indexPath = collectionView.indexPathForItem(at: pointInView){
                index = indexPath[1]
            }
        }
    }

    
}
