//
//  NewsCollectionCell.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine

final class NewsCollectionCell: UICollectionViewCell {
    static let identifier = "NewsCollectionCell"
    
    var viewModel: NewsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var articleTitle = UILabel()
    lazy var articleImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [articleTitle, articleImageView]
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            articleTitle.centerYAnchor.constraint(equalTo: articleImageView.centerYAnchor),
            articleTitle.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: 10.0),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            articleTitle.heightAnchor.constraint(equalTo: articleImageView.heightAnchor)
        ])
    }
    
    private func setUpViewModel() {
        articleTitle.text = viewModel.title
        articleImageView.image = viewModel.image
    }
}
