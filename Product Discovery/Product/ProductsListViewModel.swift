//
//  ProductsListViewModel.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class ProductsListViewModel: BaseViewModel {
    
    var isLoading: Driver<Bool> { return _isLoading.asDriver() }
    var errorMessage: Driver<String?> { return _errorMessage.asDriver(onErrorJustReturn: nil)}
    var productsList: Driver<[Product]> { return _productsList.asDriver() }
    
    private let _isLoading = Variable<Bool>(false)
    private let _errorMessage = BehaviorSubject<String?>(value: nil)
    private let _productsList = Variable<[Product]>([])
    
    private let disposeBag = DisposeBag()
    private let productManager: ProductManager
    private let dataManager: DataManager
    private let productsFetchedResultsController: NSFetchedResultsController<Product>
    private var lastLoadedPage: Int? = nil
    private let pageSize = 10
    private var isLastPage = false
    private let onFetchRequest = PublishSubject<(page: Int, deleteOld: Bool, query: String)>()
    private var searchingQuery = ""
    
    init(productManager: ProductManager, dataManager: DataManager) {
        self.productManager = productManager
        self.dataManager = dataManager
        
        let productFetchRequest = NSFetchRequest<Product>(entityName: Product.entityName)
        productFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        productFetchRequest.returnsObjectsAsFaults = false
        
        productsFetchedResultsController = NSFetchedResultsController(
            fetchRequest: productFetchRequest,
            managedObjectContext: dataManager.dataStack.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        initialize()
    }
    
    func loadFirstPage(query: String) {
        searchingQuery = query
        isLastPage = false
        lastLoadedPage = nil
        onFetchRequest.onNext( (1, true, query) )
    }
    
    func numberOfRow() -> Int {
        return _productsList.value.count
    }
    
    func productItem(at indexPath: IndexPath) -> Product? {
        return _productsList.value[safe: indexPath.row]
    }
    
    func checkToLoadNextPage() {
        loadNextPage()
    }
    
    private func initialize() {
        productsFetchedResultsController.delegate = self
        fetchProducts()
        onFetchRequest
            .do(onNext: { [weak _isLoading] _ in
                _isLoading?.value = true
            })
            .flatMapLatest { [weak self] (page, deleteOld, query) -> Observable<Bool> in
                guard let `self` = self else {
                    return Observable.just(false)
                }
                let observable = self.loadProducts(pageIndex: page, deleteOld: deleteOld, query: query)
                return observable
                    .do(onError: {[weak self] error in
                        self?._errorMessage.onNext(error.localizedDescription)
                    }, onCompleted: {[weak self] in
                        self?.lastLoadedPage = page
                    })
                    .catchErrorJustReturn(false)
            }
            .do(onNext: { [weak _isLoading] _ in
                _isLoading?.value = false
            })
            .subscribe(onNext: { [weak self] isLastPage in
                guard let `self` = self else {
                    return
                }
                self.isLastPage = isLastPage
            })
            .disposed(by: disposeBag)
    }
    
    private func loadProducts(pageIndex: Int, deleteOld: Bool, query: String) -> Observable<Bool> {
        return productManager.fetchProductsList(query: query,
                                                visitorId: "",
                                                channel: "pv_online",
                                                terminal: "CP01",
                                                page: pageIndex,
                                                limit: pageSize,
                                                deleteOld: deleteOld)
    }
    
    private func fetchProducts() {
        do {
            try productsFetchedResultsController.performFetch()
            updateProducts()
        } catch {
            print("Failed to fetch hidden transactions - \(error)")
        }
    }
    
    private func updateProducts() {
        _productsList.value = (productsFetchedResultsController.sections?.first?.objects as? [Product]) ?? []
    }
    
    private func loadNextPage() {
        guard
            !isOffline,
            !_isLoading.value,
            !isLastPage,
            let lastLoadedPage = lastLoadedPage
            else { return }
        
        onFetchRequest.onNext( (page: lastLoadedPage + 1, deleteOld: false, query: searchingQuery) )
    }
    
}

extension ProductsListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateProducts()
    }
}
