//
//  String+formatter.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation

extension String {
    
    func toUSD() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        let stringPrice = self.replacingOccurrences(of: " ", with: "")
        if let priceInteger = Double(stringPrice) {
            let priceNumber = NSNumber(value: priceInteger)
            return formatter.string(from: priceNumber)
        } else {
            return nil
        }
    }
}
