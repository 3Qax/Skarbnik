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





class ProgressableSlider: UIControl {
    
    //Colors
    var sliderTrackColor:UIColor            = UIColor.pacyficBlue
    var thumbColor: UIColor                 = UIColor.catchyPink
    
    var progressTrackColor: UIColor         = UIColor.darkGray
    var progressDotColor: UIColor           = UIColor.pacyficBlue
    var progressDotBackgroundColor: UIColor = UIColor.backgroundGrey
    
    var progressDotImage: UIImage?          = nil
    var progressDotImageTint: UIColor?      = nil
    
    var trackHight: Float                   = 5
    var cornerRadius: Float?                = nil
    
    //Vales
    var value: Float
    
    private let sumOfProgressionPoints: Float
    
    
    init(minValue min: Float, progressionPoints: [Float]? = nil, maxValue max: Float) {
        sumOfProgressionPoints = progressionPoints?.reduce(0.0, +) ?? min
        super.init(frame: .zero)
        
        
        self.isUserInteractionEnabled = true
        
        //If there are any progression points specified
        if let progressionPoints = progressionPoints {
            
            //For each one of them create a part of track and dot on the right side of that track
            for point in progressionPoints {
                
                let progressTrack = createTrack()
                let progressDot = createProgressDot()
                let progressDesciption = createDescription(text: String(format: "%.2f", point))
                
                
                self.addSubview(progressTrack)
                progressTrack.snp.makeConstraints { (make) in
                    make.width.equalToSuperview().multipliedBy(point/max) //make track's width proportional
                    make.height.equalTo(self.trackHight)
                    make.centerY.equalToSuperview()
                    
                    let allTracks = self.subviews.filter({ return $0.tag == 1 }) //create an array of all tracks currently in View
                    
                    
                    if  allTracks.count == 1 {
                        //If this is first track make it's left eqaul to left of whole control
                        make.left.equalToSuperview()
                    } else {
                        //If it isn't first one make it's left equal to right of last track
                        make.left.equalTo(allTracks.dropLast().last!.snp.right)
                    }
                }
                
                self.addSubview(progressDot)
                progressDot.snp.makeConstraints { (make) in
                    make.centerY.equalTo(progressTrack)
                    make.centerX.equalTo(progressTrack.snp.right)
                }
                
                self.addSubview(progressDesciption)
                progressDesciption.snp.makeConstraints { (make) in
                    make.centerX.equalTo(progressTrack)
                    make.top.equalTo(progressTrack.snp.bottom)
                }
            }
        }
        
        let sliderTrack = createTrack()
        addSubview(sliderTrack)
        sliderTrack.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            
            let mostLeftItem = self.subviews.filter({ return $0.tag == 1 }).last ?? self
            make.left.equalTo(mostLeftItem.snp.right)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    
}

extension ProgressableSlider {
    func createTrack(forSlider: Bool = false) -> UIView {
        let track = UIView()
        track.tag = 1
        if forSlider {
            track.backgroundColor = sliderTrackColor
        } else {
            track.backgroundColor = progressTrackColor
        }
        

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
    
    func createThumb() -> {
        
    }
}
