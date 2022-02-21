//
//  NewsCollectionViewCell.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine
import Kingfisher

final class NewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsCollectionViewCell"
   
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var articleImageView: UIImageView!
    
    var viewModel: NewsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    private func setUpViewModel() {
        articleLabel.text = viewModel.title
        if let url = URL(string: viewModel.imageURL ?? "-") {
            articleImageView.kf.setImage(with: url)
        }
        
        dateLabel.isHidden = viewModel.isTop6
        descriptionLabel.isHidden = viewModel.isTop6
        
        dateLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
    }
}
