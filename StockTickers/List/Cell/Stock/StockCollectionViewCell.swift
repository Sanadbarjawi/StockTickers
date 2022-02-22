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
    @IBOutlet weak var stockDirection: UIImageView!

    var viewModel: StockCellViewModel! {
        didSet { setUpViewModel() }
    }
 
    private func setUpViewModel() {
        stockName.text = viewModel.stockName
        stockPrice.text = viewModel.price
        stockDirection.image = viewModel.isIncreasing ? UIImage(named: ("ic_stock_up")) : UIImage(named: ("ic_stock_down"))
    }
}

