//
//  PaymantCellView.swift
//  skarbinik
//
//  Created by Jakub Towarek on 25/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import Material

class PaymantCellView: UITableViewCell {

    @IBOutlet weak var expandButton: IconButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amounLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var payButton: RaisedButton!
    @IBOutlet weak var showPhotosButton: IconButton!
    
    var isColapsed: Bool = true
    
    @IBAction func expandButtonTapped(_ sender: Any) {
        if isColapsed {
            descriptionLabel.isHidden = false
            self.contentView.setNeedsLayout()
        } else {
            descriptionLabel.isHidden = true
            self.contentView.setNeedsLayout()
        }
    }
    func initialSetup() {
        expandButton.image = Icon.cm.arrowDownward
        expandButton.tintColor = Color.grey.base
        expandButton.title = ""
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        
        amounLabel.numberOfLines = 0
        amounLabel.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        amounLabel.textColor = UIColor(rgb: 0xFA3CB1)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        descriptionLabel.textColor = UIColor(rgb: 0x78C0E5)
        
        payButton.pulseColor = Color.white
        payButton.title = "zapłać"
        payButton.backgroundColor = UIColor.init(rgb: 0xFA3CB1)
        payButton.titleColor = UIColor.white
        payButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
        
        showPhotosButton.image = Icon.photoLibrary
        showPhotosButton.title = ""
    }
    
    func setupValues(forPayment payment: Payment) {
        self.initialSetup()
        titleLabel.text = payment.name
        amounLabel.text = String.localizedStringWithFormat("%.2f%@", Float(payment.amount)!, "zł")
        descriptionLabel.text = payment.description
        descriptionLabel.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
