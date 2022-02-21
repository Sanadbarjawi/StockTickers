//
//  NewsFeedService.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine

protocol NewsFeedServiceProtocol {
    //https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv
    func getNewsFeed() -> AnyPublisher<[News], Error>
}

final class NewsFeedService: NewsFeedServiceProtocol {


}
