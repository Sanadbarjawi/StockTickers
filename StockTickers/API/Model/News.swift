//
//  News.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import Foundation

// MARK: - News
struct News: Codable {

    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Equatable, Hashable, Codable {
    
    let identifier = UUID()

    let source: Source?
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    var isTop6: Bool = false
}

extension Article {
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(content)
        hasher.combine(title)
    }
}

// MARK: - Source
struct Source: Codable, Equatable, Hashable {
    let identifier = UUID()

    let id: String
    let name: String
}
extension Source {
    
    static func == (lhs: Source, rhs: Source) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(id)
        hasher.combine(name)
    }
}
