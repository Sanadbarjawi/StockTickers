//
//  NewsCellViewModel.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation
import Combine
import UIKit

final class NewsCellViewModel {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: String = ""
    @Published var imageURL: String?
    @Published var isTop6: Bool = false

    private let article: Article
    init(article: Article) {
        self.article = article
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        title = article.title ?? ""
        description = article.content ?? ""
        date = article.publishedAt ?? ""
        isTop6 = article.isTop6
        imageURL = article.urlToImage
    }
}
