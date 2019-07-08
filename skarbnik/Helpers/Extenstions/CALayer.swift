//
//  CALayer.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/07/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



extension CALayer {
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "dasdasdasdasdasdasdasdasdasdasdasdfdfasdf" {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "dasdasdasdasdasdasdasdasdasdasdasdfdfasdf"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    func addShadow(Xoffset: Int = 4, Yoffset: Int = 4, opacity: Float = 0.25, blurRadius: CGFloat = 4) {
        self.shadowOffset = CGSize(width: Xoffset, height: Yoffset)
        self.shadowOpacity = opacity
        self.shadowRadius = blurRadius
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
}
