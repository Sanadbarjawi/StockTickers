//
//  MockNewsFeedService.swift
//  StockTickersTests
//
//  Created by sanad barjawi on 22/02/2022.
//

import Foundation
import Combine
@testable import StockTickers
import XCTest

final class MockNewsFeedService: NewsFeedServiceProtocol {
    var getCallsCount: Int = 0
    
    var getResult: Result<[Article], Error> = .success([])
    
    func getNewsFeed() -> AnyPublisher<[Article], Error> {
        getCallsCount += 1
        return getResult.publisher.eraseToAnyPublisher()
    }
}
