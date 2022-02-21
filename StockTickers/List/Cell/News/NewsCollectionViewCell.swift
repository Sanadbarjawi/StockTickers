//
//  NewsCollectionViewCell.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine

final class NewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsCollectionViewCell"
   
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    var viewModel: NewsCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    private func setUpViewModel() {
        articleTitle.text = viewModel.title
        articleImageView.image = viewModel.image
    }
}
