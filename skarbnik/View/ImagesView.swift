//
//  ImagesView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView



class ImagesView: UIView {
    
    let topBar: UIView                      = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 15.0
        return view
    }()
    var topBarBottomConstraint: Constraint? = nil
    let backIV: UIImageView                 = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let scrollView: UIScrollView            = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = false
        return scrollView
    }()
    let bottomBar: UIView                   = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 15.0
        return view
    }()
    var bottomBarTopConstraint: Constraint? = nil
    let dotsStackView: UIStackView          = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    var imagesData                          = Dictionary<Int, Data?>() {
        didSet {
            
            scrollView.subviews.forEach({ $0.removeFromSuperview() })
            dotsStackView.subviews.forEach({ $0.removeFromSuperview() })
            dotsStackView.addArrangedSubview(UIView())
            
            for imageData in imagesData {
                
                //everything is fine
                if let data = imageData.value, let image = UIImage(data: data) {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    addToScrollView(imageView)
                    
                //downloaded data is corrupted
                } else if imageData.value != nil {
                    delegate?.foundCorruptedImageData()
                    assertionFailure()
                    
                //image is loading...
                } else {
                    let indicator = NVActivityIndicatorView(frame: .zero,
                                                            type: .circleStrokeSpin,
                                                            color: .white)
                    indicator.startAnimating()
                    let indicatorWrapper = UIView()
                    indicatorWrapper.addSubview(indicator)
                    indicator.snp.makeConstraints { (make) in
                        make.center.equalToSuperview()
                        make.width.height.equalTo(50)
                    }
                    
                    addToScrollView(indicatorWrapper)
                }
                    
                
                
                
            }
            
            if let last = scrollView.subviews.last {
                last.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview()
                })
            }
            
            dotsStackView.addArrangedSubview(UIView())
            var selectedOption: Int = 0
            if scrollView.bounds.width != 0 {
                selectedOption = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            }
            dotsStackView.arrangedSubviews.compactMap({ $0 as? Dot })[selectedOption].state = .filled
            
        }
    }
    var delegate: ImagesViewDelegate?
    
    
    
    
    init(imagesData: [Int: Data?]) {
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor.black
        
        //Setup topBar
        self.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            topBarBottomConstraint = make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60).constraint
        }
        
        topBar.addSubview(backIV)
        let backTGR = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backIV.addGestureRecognizer(backTGR)
        backIV.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.width.equalTo(50)
        }
        
        //Setup bottomBar
        self.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            bottomBarTopConstraint = make.height.equalTo(100).constraint
        }
        
        bottomBar.addSubview(dotsStackView)
        dotsStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        //Setup scrollView and it's content
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        defer {
            self.imagesData = imagesData
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToScrollView<T: UIView>(_ view: T) {
        scrollView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.width.height.equalToSuperview()
            make.top.equalToSuperview()
            if let last = self.scrollView.subviews.dropLast().last {
                make.left.equalTo(last.snp.right)
            } else { make.left.equalToSuperview() }
            
        })
        
        let dot = Dot()
        dot.tapHandler = {
            self.scrollView.setContentOffset(view.frame.origin, animated: true)
            selectionFeedbackGenerator.selectionChanged()
            self.dotsStackView.arrangedSubviews.compactMap({ $0 as? Dot }).forEach({ $0.state = .empty })
            dot.state = .filled
        }
        dotsStackView.addArrangedSubview(dot)
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
}

extension ImagesView: Slidable {
    
    func slideIn(completion: @escaping () -> ()) {
        
        topBarBottomConstraint?.deactivate()
        topBar.snp.makeConstraints { (make) in
            topBarBottomConstraint = make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).constraint
        }
        bottomBarTopConstraint?.deactivate()
        bottomBar.snp.makeConstraints { (make) in
            bottomBarTopConstraint = make.height.equalTo(0).constraint
        }
        self.layoutIfNeeded()
        
        topBarBottomConstraint?.deactivate()
        topBar.snp.makeConstraints { (make) in
            topBarBottomConstraint = make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60).constraint
        }
        bottomBarTopConstraint?.deactivate()
        bottomBar.snp.makeConstraints { (make) in
            bottomBarTopConstraint = make.height.equalTo(100).constraint
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion() })
        
    }
    
    func slideOut(completion: @escaping () -> ()) {
        
        topBarBottomConstraint?.deactivate()
        topBar.snp.makeConstraints { (make) in
            topBarBottomConstraint = make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).constraint
        }
        bottomBarTopConstraint?.deactivate()
        bottomBar.snp.makeConstraints { (make) in
            bottomBarTopConstraint = make.height.equalTo(0).constraint
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion() })
        
    }
    
}
