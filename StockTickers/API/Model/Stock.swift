//
//  Stock.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
struct Stock: Equatable, Hashable, Decodable {
    var title: String
    var value: String
}
