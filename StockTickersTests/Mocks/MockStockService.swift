//
//  MockStockService.swift
//  StockTickersTests
//
//  Created by sanad barjawi on 22/02/2022.
//

import Foundation
import Combine
@testable import StockTickers
import XCTest

final class MockStockService: StocksServiceProtocol {
    var getCallsCount: Int = 0
    
    var getResult: Result<[Stock], Error> = .success([])
    
    func getStockTickers() -> AnyPublisher<[Stock], Error> {
        getCallsCount += 1
        return getResult.publisher.eraseToAnyPublisher()
    }
}
