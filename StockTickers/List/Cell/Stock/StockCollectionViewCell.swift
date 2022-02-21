//
//  StockCollectionViewCell.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit

final class StockCollectionViewCell: UICollectionViewCell {
    static let identifier = "StockCollectionViewCell"
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!

    var viewModel: StockCellViewModel! {
        didSet { setUpViewModel() }
    }
 
    private func setUpViewModel() {
        stockName.text = viewModel.stockName
        stockPrice.text = viewModel.price
    }
}

