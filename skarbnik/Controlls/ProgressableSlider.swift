//
//  ProgressableSlider.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit
import SnapKit





class ProgressableSlider: UIView {
    
    class VariableHightSlider: UISlider {
        override func trackRect(forBounds bounds: CGRect) -> CGRect {
            var result = super.trackRect(forBounds: bounds)
            result.size.height = 5
            result.origin.x = 0
            result.origin.y -= 2.5
            
            return result
        }
        
        
    }
    let slider: VariableHightSlider
    
    
    init(total totalAmount: Float, remittances: [Float], barHight: Float = 5, cornerRadius: Float = 0) {
        
        func createSlider(minValue min: Float, maxValue max: Float) -> VariableHightSlider {
            let slider = VariableHightSlider()
            slider.minimumTrackTintColor = UIColor.pacyficBlue
            slider.minimumValue = min
            slider.maximumTrackTintColor = UIColor.darkGrey
            slider.maximumValue = max
            slider.setValue(max, animated: true)
            slider.thumbTintColor = UIColor.catchyPink
            slider.isUserInteractionEnabled = true
            return slider
        }
        slider = createSlider(minValue: remittances.reduce(0.0, +), maxValue: totalAmount)
        //TODO: make thumb's zPosition > 2
        super.init(frame: .zero)
        
        
        self.isUserInteractionEnabled = true
        
        //For every remittance create track and dot with checkmark on the right side of that track
        for remittance in remittances {
            
            let track = createTrack(cornerRadius: cornerRadius)
            let dot = createProgressDot()
            let description = createDescription(text: String(format: "%.2f", remittance) )
            
            
            self.addSubview(track)
            track.snp.makeConstraints { (make) in
                //make track's width proportional
                make.width.equalToSuperview().multipliedBy(remittance/totalAmount)
                
                make.height.equalTo(barHight)
                make.centerY.equalToSuperview()

                //create an array of all tracks currently in View
                let allTracks = self.subviews.filter({ return $0.tag == 1 })
                
                //If this is first track (count == 1) make it's left eqaul to left of whole view
                if  allTracks.count == 1 {
                    make.left.equalToSuperview()

                //If it isn't make it's left equal to right of last track
                } else {
                    make.left.equalTo(allTracks.dropLast().last!.snp.right)
                }
            }
            
            self.addSubview(dot)
            dot.snp.makeConstraints { (make) in
                make.centerY.equalTo(track)
                make.centerX.equalTo(track.snp.right)
            }
            
            self.addSubview(description)
            description.snp.makeConstraints { (make) in
                make.centerX.equalTo(track)
                make.top.equalTo(track.snp.bottom)
            }
        } //End of for
        
        //Create slider for changing amount which user wish to pay
        //It's width should be proportional to unpaid amount
        addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            
            let mostLeftItem = self.subviews.filter({ return $0.tag == 1 }).last?.snp.right ?? self.snp.left
            make.left.equalTo(mostLeftItem)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTrack(cornerRadius radius: Float) -> UIView {
        let track = UIView()
        track.tag = 1
        track.backgroundColor = UIColor.pacyficBlue
        track.layer.cornerRadius = CGFloat(radius)
        return track
    }
    
    func createProgressDot() -> UIView {
        let progressDot = UIView()
        progressDot.tag = 2
        progressDot.backgroundColor = UIColor.backgroundGrey
        
        
        let innerDot = UIView()
        innerDot.backgroundColor = UIColor.pacyficBlue
        
        
        let tick = UIImageView()
        tick.image = UIImage(named: "tick")
        
        innerDot.addSubview(tick)
        tick.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(10)
        }
        
        progressDot.addSubview(innerDot)
        innerDot.layer.cornerRadius = 15 / 2.0
        innerDot.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(15)
        }
        
        progressDot.layer.zPosition = 1
        progressDot.layer.cornerRadius = 25 / 2.0
        
        progressDot.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
        }
        
        return progressDot
    }
    
    func createDescription(text: String) -> UILabel {
        let desc = UILabel()
        desc.font = UIFont(name: "PingFangTC-Thin", size: 14.0)
        desc.text = text
        return desc
    }

    
    
}
