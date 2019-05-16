//
//  ImagesModelDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




protocol ImagesModelDelegate {
    func shouldUpdate(ImageHavingId id: Int, withData data: Data?)
}
