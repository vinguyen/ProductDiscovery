//
//  ViewController.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProductsListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel: ProductsListViewModel = ProductsListViewModel(
        productManager: ManagerProvider.sharedInstance.productManager,
        dataManager: ManagerProvider.sharedInstance.dataManager
    )
    
    private lazy var searchBar: UISearchBar = {
        $0.tintColor = .red
        $0.setImage(#imageLiteral(resourceName: "searchIcon"), for: .search, state: .normal)
        $0.placeholder = "Nhập tên, mã sản phẩm"
        return $0
    }(UISearchBar())
    
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var tableFooterView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        
        viewModel
            .isLoading
            .drive(
                onNext: { [weak self] isLoading in
                    guard let `self` = self else { return }
                    self.loadingIndicator.isHidden = !isLoading
                }
            )
            .disposed(by: disposeBag)
        
        viewModel
            .errorMessage
            .drive(
                onNext: { [weak self] message in
                    guard let message = message else { return }
                    self?.showInfoAlert(message)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel
            .productsList
            .drive(
                onNext: {[weak self] _ in
                    self?.tableView.reloadData()
                }
            )
            .disposed(by: disposeBag)
        
        searchBar
            .rx.text
            .orEmpty
            .skip(1)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty {
                    self.searchBar.resignFirstResponder()
                }
                self.tableView.scrollToTop(animated: false)
                self.viewModel.loadFirstPage(query: query)
            })
            .disposed(by: disposeBag)
        
        viewModel.loadFirstPage(query: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(Gradient.main, for: .default)
        navigationController?.navigationBar.barStyle = .black
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        viewModel.loadFirstPage(query: searchBar.text ?? "")
    }
}

extension ProductsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath)
        if let productCell = cell as? ProductCell, let product = viewModel.productItem(at: indexPath) {
            productCell.update(with: product)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let productItem = viewModel.productItem(at: indexPath),
            let detailViewController =  UIStoryboard(name: ProductDetailsViewController.identifier,
                                                     bundle: .main
                                                    ).instantiateInitialViewController() as? ProductDetailsViewController else { return }
        let productDetailsViewModel = ProductDetailsViewModel(
                                        productManager: ManagerProvider.sharedInstance.productManager,
                                        dataManager: ManagerProvider.sharedInstance.dataManager,
                                        productItem: productItem
                                    )
        detailViewController.setup(with: productDetailsViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if maximumOffset - currentOffset <= 10.0 {
                viewModel.checkToLoadNextPage()
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 5.0 {
            viewModel.checkToLoadNextPage()
        }
    }
}

