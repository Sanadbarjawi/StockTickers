//
//  StocksService.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine

protocol StocksServiceProtocol {
    //https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv
    func getStockTickers() -> AnyPublisher<[Stock], Error>
}

final class StocksService: StocksServiceProtocol {


}
