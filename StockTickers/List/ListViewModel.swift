//
//  ListViewModel.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine

enum ListViewModelError: Error, Equatable {
    case stocksFetch
    case newsFeedFetch
}

enum ListViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ListViewModelError)
}

final class ListViewModel {
    enum Section: String, CaseIterable, Hashable { case stocksFetch, newsFeedFetch }

    @Published private(set) var stocks: [Stock] = []
    @Published private(set) var articles: [Article] = []

    @Published private(set) var state: ListViewModelState = .loading
    
    private let stocksService: StocksServiceProtocol
    private let newsFeedService: NewsFeedServiceProtocol
    
    private var bindings = Set<AnyCancellable>()
    
    init(stocksService: StocksServiceProtocol = StocksService(),
         newsFeedService: NewsFeedServiceProtocol = NewsFeedService()) {
        self.stocksService = stocksService
        self.newsFeedService = newsFeedService
    }

}

extension ListViewModel {
    
    func fetchNewsFeed() {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.newsFeedFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let valueHandler: ([Article]) -> Void = { [weak self] articles in
            self?.articles = articles
        }
        
        newsFeedService
            .getNewsFeed()
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
    
    func fetchStocks() {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure:
                self?.state = .error(.stocksFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let valueHandler: ([Stock]) -> Void = { [weak self] stocks in
            self?.stocks = stocks
        }
        
        stocksService
            .getStockTickers()
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}
