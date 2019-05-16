//
//  ImagesView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



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
                
                var image = UIImage()
                
                if let data = imageData.value {
                    image = UIImage(data: data) ?? UIImage(named: "corupted data image")!
                } else { image = UIImage(named: "loading...")! }//loading
                    
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                scrollView.addSubview(imageView)
                imageView.snp.makeConstraints({ (make) in
                    make.width.height.equalToSuperview()
                    make.top.equalToSuperview()
                    if let last = self.scrollView.subviews.dropLast().last {
                        make.left.equalTo(last.snp.right)
                    } else { make.left.equalToSuperview() }
                    
                })
                
                let dot = Dot()
                dot.tapHandler = {
                    self.scrollView.setContentOffset(imageView.frame.origin, animated: true)
                    selectionFeedbackGenerator.selectionChanged()
                    self.dotsStackView.arrangedSubviews.compactMap({ $0 as? Dot }).forEach({ $0.state = .empty })
                    dot.state = .filled
                }
                dotsStackView.addArrangedSubview(dot)
                
            }
            
            if let last = scrollView.subviews.last {
                last.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview()
                })
            }
            
            dotsStackView.addArrangedSubview(UIView())
            dotsStackView.arrangedSubviews.compactMap({ $0 as? Dot }).first?.state = .filled
            
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
