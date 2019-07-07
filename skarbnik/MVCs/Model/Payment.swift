//
//  Payment.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



final class Payment: Decodable {
    let id: Int
    let title, description: String
    let amount: Float
    let amountLocale: Locale
    let creationDate, startDate, endDate: Date
    let images: [Image]
    var contributions = [Contribution]()
    var state: State {
        get {
            if contributions.map({ $0.amount }).reduce(0, +) == amount { return .paid }
            if Date() < startDate { return .awaiting }
            return .pending
        }
    }
    var leftToPay: Float {
        get {
            return amount - contributions.map({ $0.amount }).reduce(0, +)
        }
    }
    
    enum State: Int {
        case awaiting = 2
        case pending = 1
        case paid = 3
    }
    
    //Payment's Image Data Model
    final class Image: Codable {
        let id: Int
        let url: URL
        var data: Data?
        var state: State = .notLoaded
        
        enum State {
            case notLoaded
            case loading
            case loaded
            case error
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "id_field"
            case url = "image"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            url = URL(string: try container.decode(String.self, forKey: .url))!
        }
        
    }
    
    //Payment's Contribution Data Model
    struct Contribution: Codable {
        let amount: Float
        let date: Date
        
        enum CodingKeys: String, CodingKey {
            case amount = "amount_paid"
            case date = "created"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            amount = Float(try container.decode(String.self, forKey: .amount))!
            date = ISO8601DateFormatter().date(from: (try container.decode(String.self, forKey: .date)))!
        }
        
    }
    

    
    enum CodingKeys: String, CodingKey {
        case id = "id_field"
        case title = "name"
        case description = "description"
        case amount = "amount"
        case amountLocale = "currency"
        case creationDate = "creation_date"
        case startDate = "start_date"
        case endDate = "end_date"
        case images = "images"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        
        amount = Float(try container.decode(String.self, forKey: .amount))!
        let amountCurrencyCode = try container.decode(String.self, forKey: .amountLocale)
        amountLocale = Locale.availableIdentifiers
                                .lazy
                                .map({Locale(identifier: $0)})
                                .first(where: { $0.currencyCode == amountCurrencyCode })!
        
        creationDate = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .creationDate))!
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = shortDateFormatter.date(from: (try container.decode(String.self, forKey: .startDate)))!
        endDate = shortDateFormatter.date(from: (try container.decode(String.self, forKey: .endDate)))!
        
        images = try container.decode([Image].self, forKey: .images)
    }
    
}
