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
 
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

extension Article {
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title &&
        lhs.source == rhs.source &&
        lhs.author == rhs.author &&
        lhs.articleDescription == rhs.articleDescription &&
        lhs.url == rhs.url &&
        lhs.urlToImage == rhs.urlToImage &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.content == rhs.content
    }
}

// MARK: - Source
struct Source: Codable, Equatable, Hashable {
    let id: String
    let name: String
}
extension Source {
    static func == (lhs: Source, rhs: Source) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name 
    }
}
