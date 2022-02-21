//
//  StockCollectionCell.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine

final class StockCollectionCell: UICollectionViewCell {
    static let identifier = "StockCollectionCell"
    
    var viewModel: StockCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    lazy var stockName = UILabel()
    lazy var stockPrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubiews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubiews() {
        let subviews = [stockName, stockPrice]
        
        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stockName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            stockName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            stockName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            stockPrice.centerYAnchor.constraint(equalTo: stockName.centerYAnchor),
            stockPrice.leadingAnchor.constraint(equalTo: stockName.trailingAnchor, constant: 10.0),
            stockPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            stockPrice.heightAnchor.constraint(equalTo: stockName.heightAnchor)
        ])
    }
    
    private func setUpViewModel() {
        stockName.text = viewModel.stockName
        stockPrice.text = viewModel.price
    }
}
