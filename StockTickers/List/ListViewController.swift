//
//  ListViewController.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    
    private lazy var contentView = ListView()
    private let viewModel: ListViewModel
    private var bindings = Set<AnyCancellable>()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<ListViewModel.Section, AnyHashable> = makeDataSource()

    init(viewModel: ListViewModel = ListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = contentView
    }
    
    override func viewDidLoad() {
        title = "Stock Tickers"
        setUpCollectionView()
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Timer.publish(every: 1, tolerance: .none, on: RunLoop.main, in: RunLoop.Mode.common, options: nil)
            .autoconnect()
            .sink(receiveCompletion: {_ in}) { [weak self] _ in self?.viewModel.fetchStocks() }
            .store(in: &bindings)

        viewModel.fetchNewsFeed()
    }
    
    private func setUpCollectionView() {
        let stockCell = UINib(nibName: StockCollectionViewCell.identifier, bundle: nil)
        contentView.collectionView.register(stockCell,
                                            forCellWithReuseIdentifier: StockCollectionViewCell.identifier)
        let newsCell = UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil)
        contentView.collectionView.register(newsCell,
                                            forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
    }
    
    private func setUpBindings() {
        
        func bindViewModelToView() {
            viewModel.$stocks
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.reloadDataSource()
                })
                .store(in: &bindings)
            
            viewModel.$top6Articles
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.reloadDataSource()
                })
                .store(in: &bindings)
            
            viewModel.$articles
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.reloadDataSource()
                })
                .store(in: &bindings)
            
            
            let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.contentView.startLoading()
                case .finishedLoading:
                    self?.contentView.finishLoading()
                case .error(let error):
                    self?.contentView.finishLoading()
                    self?.showError(error)
                }
            }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }
        bindViewModelToView()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Create our diffable data source
    /// - Returns: Diffable data source
    private func makeDataSource() -> UICollectionViewDiffableDataSource<ListViewModel.Section, AnyHashable> {
        return UICollectionViewDiffableDataSource(collectionView: contentView.collectionView) { collectionView, indexPath, item in
            if let stock = item as? Stock {
                //stock
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StockCollectionViewCell.identifier,
                    for: indexPath) as? StockCollectionViewCell
                cell?.viewModel = StockCellViewModel(stock: stock)
                return cell
                
            } else if let article = item as? Article {
                //article
               guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewsCollectionViewCell.identifier,
                    for: indexPath) as? NewsCollectionViewCell else {return UICollectionViewCell()}
                cell.viewModel = NewsCellViewModel(article: article)
                return cell
                
            } else {
                fatalError("Unknown cell type")
            }
        }
    }
}

extension ListViewController {
 
    func reloadDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<ListViewModel.Section, AnyHashable>()
        snapShot.appendSections([ListViewModel.Section.stocks,
                                 ListViewModel.Section.top6News,
                                 ListViewModel.Section.remainingNewsFeed])
        
        snapShot.appendItems(viewModel.stocks, toSection: ListViewModel.Section.stocks)
        snapShot.appendItems(viewModel.top6Articles, toSection: ListViewModel.Section.top6News)
        snapShot.appendItems(viewModel.articles, toSection: ListViewModel.Section.remainingNewsFeed)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
}
