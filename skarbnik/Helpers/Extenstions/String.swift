//
//  Extensions.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/07/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func decapitalizeingFirstLetter() -> String {
        return prefix(1).lowercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
