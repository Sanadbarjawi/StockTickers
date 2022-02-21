//
//  ListViewController.swift
//  StockTickers
//
//  Created by sanad barjawi on 21/02/2022.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<ListViewModel.Section, Stock>
        private typealias Snapshot = NSDiffableDataSourceSnapshot<ListViewModel.Section, Stock>
        
        private lazy var contentView = ListView()
        private let viewModel: ListViewModel
        private var bindings = Set<AnyCancellable>()
        
        private var dataSource: DataSource!
        
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
            view.backgroundColor = .darkGray
            
            setUpCollectionView()
            configureDataSource()
            setUpBindings()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel.fetchStocks()
        }
        
        private func setUpCollectionView() {
            contentView.collectionView.register(
                StockCollectionCell.self,
                forCellWithReuseIdentifier: StockCollectionCell.identifier)
        }
        
        private func setUpBindings() {
            
            func bindViewModelToView() {
                viewModel.$stocks
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] _ in
                        self?.updateSections()
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
        
        private func updateSections() {
            var snapshot = Snapshot()
            snapshot.appendSections([.stocksFetch, .newsFeedFetch])
            snapshot.appendItems(viewModel.stocks)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: - UICollectionViewDataSource
    extension ListViewController {
        private func configureDataSource() {
            dataSource = DataSource(
                collectionView: contentView.collectionView,
                cellProvider: { (collectionView, indexPath, stock) -> UICollectionViewCell? in
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StockCollectionCell.identifier,
                        for: indexPath) as? StockCollectionCell
                    cell?.viewModel = StockCellViewModel(stock: stock)
                    return cell
                })
        }
    }
