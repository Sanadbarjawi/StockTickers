//
//  Stock.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
struct Stock: Equatable, Hashable, Decodable {
    
    let identifier = UUID()
  
    var title: String
    var value: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(value)
        hasher.combine(title)
    }
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
      return lhs.identifier == rhs.identifier && lhs.value == rhs.value && lhs.title == rhs.title
    }
}
