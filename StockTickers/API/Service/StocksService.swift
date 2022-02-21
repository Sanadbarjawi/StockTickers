//
//  StocksService.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine
import CSVImporter

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol StocksServiceProtocol {
    func getStockTickers() -> AnyPublisher<[Stock], Error>
}

final class StocksService: StocksServiceProtocol {
    var importer: CSVImporter<Stock>?
    
    func getStockTickers() -> AnyPublisher<[Stock], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<[Stock], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest() else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                if let stocksString = String(data: data, encoding: .utf8) {
                    self?.importer = CSVImporter<Stock>(contentString: stocksString)
                    self?.importer?.startImportingRecords { recordValues -> Stock in
                        
                        return Stock(title: recordValues[0], value: recordValues[1])
                        
                    }.onFinish { stocks in
                        var mutatingStocks: [Stock] = stocks
                        mutatingStocks.removeFirst()
                        promise(.success(mutatingStocks))
                    }
                } else {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
    }
    
    private func getUrlRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = "/dsancov/TestData/main/stocks.csv"
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
}
