//
//  NewsFeedService.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine

protocol NewsFeedServiceProtocol {
    func getNewsFeed() -> AnyPublisher<[News], Error>
}

final class NewsFeedService: NewsFeedServiceProtocol {
    func getNewsFeed() -> AnyPublisher<[News], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<[News], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest() else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let news = try JSONDecoder().decode([News].self, from: data)
                    promise(.success(news))
                } catch {
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
        components.host = "saurav.tech"
        components.path = "/NewsAPI/everything/cnn.json"
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
}
