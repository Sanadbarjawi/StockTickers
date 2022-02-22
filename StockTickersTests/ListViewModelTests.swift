//
//  StockTickersTests.swift
//  StockTickersTests
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import XCTest
import Combine
@testable import StockTickers

final class ListViewModelTests: XCTestCase {
    
    private var subject: ListViewModel!
    
    private var mockStockService: MockStockService!
    private var mockNewsFeedService: MockNewsFeedService!
    
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockStockService = MockStockService()
        mockNewsFeedService = MockNewsFeedService()
        
        subject = ListViewModel(stocksService: mockStockService, newsFeedService: mockNewsFeedService)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockStockService = nil
        mockNewsFeedService = nil
        subject = nil

        super.tearDown()
    }

    func test_stock_api_givenServiceCallSucceeds_shouldUpdateStocks() {
        // given
        mockStockService.getResult = .success(Constants.stocks)

        // when
        subject.fetchStocks()

        // then
        XCTAssertEqual(mockStockService.getCallsCount, 1)
        subject.$stocks
            .sink { XCTAssertEqual($0, Constants.stocks) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }

    func test_stock_api_givenServiceCallFails_shouldUpdateStateWithError() {
        // given
        mockStockService.getResult = .failure(NSError())

        // when
        subject.fetchStocks()

        // then
        XCTAssertEqual(mockStockService.getCallsCount, 1)
        subject.$stocks
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .error(.stocksFetch)) }
            .store(in: &cancellables)
    }
    
    
    func test_newsFeed_api_givenServiceCallSucceeds_shouldUpdate6TopArticles() {
        // given
        mockNewsFeedService.getResult = .success(Constants.articles)

        // when
        subject.fetchNewsFeed()

        // then
        XCTAssertEqual(mockNewsFeedService.getCallsCount, 1)
        subject.$top6Articles
            .sink { XCTAssertEqual($0, Constants.articles) }//should equal 6 articles
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }

    func test_newsFeed_api_givenServiceCallFails_shouldUpdateStateWithError() {
        // given
        mockNewsFeedService.getResult = .failure(NSError())

        // when
        subject.fetchNewsFeed()

        // then
        XCTAssertEqual(mockNewsFeedService.getCallsCount, 1)
        subject.$articles
            .sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)

        subject.$state
            .sink { XCTAssertEqual($0, .error(.newsFeedFetch)) }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers
extension ListViewModelTests {
    enum Constants {
        static let stocks = [
            Stock(title: "FORD", value: "123,00 USD"),
            Stock(title: "TESLA", value: "78,00 USD")
        ]
        
        static let articles = [
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false),
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false),
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false),
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false),
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false),
            Article(source: Source(id: "", name: ""), author: "",
                    title: "Some cool title", articleDescription: "", url: "", urlToImage: "",
                    publishedAt: "", content: "Some cool content", isTop6: false)
        ]
    }
}
