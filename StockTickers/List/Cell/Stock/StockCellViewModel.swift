//
//  StockCellViewModel.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine

final class StockCellViewModel {
    @Published var stockName: String = ""
    @Published var price: String = ""
        
    private let stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        stockName = stock.title
        price = stock.value
    }
}
