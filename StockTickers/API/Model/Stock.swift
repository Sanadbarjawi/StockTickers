//
//  Stock.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
class Stock: Equatable, Hashable, Decodable {
    
    let identifier = UUID()
  
    var title: String
    var value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
      return lhs.identifier == rhs.identifier
    }
}
