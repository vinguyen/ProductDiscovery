//
//  DetailInfoViewController.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import SwipeMenuViewController
import RxSwift

class DetailInfoViewController: SwipeMenuViewController {
    private var menus: [String] = ["Mô tả sản phẩm","Thông số kĩ thuật ", "So sánh giá"]
    private var viewModel: DetailInfoViewModel?
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        if let detailDescriptionViewController = UIStoryboard(
            name: ProductDetailsViewController.identifier,
            bundle: .main
            ).instantiateViewController(
                withIdentifier: DetailDescriptionViewController.identifier
            ) as? DetailDescriptionViewController {
            self.addChildViewController(detailDescriptionViewController)
        }
        
        if let detailTechInfoViewController = UIStoryboard(
            name: ProductDetailsViewController.identifier,
            bundle: .main
            ).instantiateViewController(
                withIdentifier: DetailTechInfoViewController.identifier
            ) as? DetailTechInfoViewController {
            self.addChildViewController(detailTechInfoViewController)
        }
        
        if let detailComprePriceViewController = UIStoryboard(
            name: ProductDetailsViewController.identifier,
            bundle: .main
            ).instantiateViewController(
                withIdentifier: DetailComparePriceViewController.identifier
            ) as? DetailComparePriceViewController {
            self.addChildViewController(detailComprePriceViewController)
        }
        
        super.viewDidLoad()
        
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.itemView.font = UIFont.SFProTextRegular(ofSize: 13)
        options.tabView.itemView.textColor = UIColor.lightGray
        options.tabView.itemView.selectedTextColor = UIColor.darkGray
        options.tabView.additionView.backgroundColor = UIColor.red
        
        swipeMenuView.reloadData(options: options, default: 1)
    }
    
    func setup(with viewModel: DetailInfoViewModel) {
        self.viewModel = viewModel
        self.viewModel?.productItem.asObservable().subscribe(onNext: {[weak self] product in
            guard let product = product,
                let detailInfo = self?.childViewControllers[safe: 1] as? DetailTechInfoViewController else { return }
            detailInfo.setup(with: DetailTechInfoViewModel(productItem: product))
        }).disposed(by: disposeBag)
    }
    
    override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return menus.count
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return menus[index]
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView,
                                viewControllerForPageAt index: Int) -> UIViewController {
        let vc = childViewControllers[index]
        vc.didMove(toParentViewController: self)
        return vc
    }
}
