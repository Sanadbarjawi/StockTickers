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
    @Published var image: UIImage?
        
    private let article: Article
    init(article: Article) {
        self.article = article
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        title = article.title
//        image = article.urlToImage
    }
}
