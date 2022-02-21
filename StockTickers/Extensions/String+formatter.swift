//
//  String+formatter.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation

extension String {

    func toUSD2() -> String? {//#.## USD.
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let stringPrice = self.replacingOccurrences(of: " ", with: "")
        if let priceInteger = Double(stringPrice) {
            let priceNumber = NSNumber(value: priceInteger)
            let formatted = formatter.string(from: priceNumber)
            return String.init(format: "%@ %@", formatted ?? "-", "USD")
        } else {
            return nil
        }
    }
   
}
