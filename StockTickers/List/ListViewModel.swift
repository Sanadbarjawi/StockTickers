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
    enum Section { case stocksFetch, newsFeedFetch }

    @Published private(set) var stocks: [Stock] = []
    @Published private(set) var state: ListViewModelState = .loading
    
    private let stocksService: StocksServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(stocksService: StocksServiceProtocol = StocksService()) {
        self.stocksService = stocksService
    }

}

extension ListViewModel {
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
