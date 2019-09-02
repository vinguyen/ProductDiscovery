//
//  ProductDetailsViewController.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/2/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ImageSlideshow
import AlamofireImage
import SVProgressHUD

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet private weak var productNameTitleLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var imageSlideShow: ImageSlideshow!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productCodeLabel: UILabel!
    @IBOutlet private weak var outOfStockView: UIView!
    @IBOutlet private weak var discountPriceLabel: UILabel!
    @IBOutlet private weak var salePriceLabel: UILabel!
    @IBOutlet private weak var percentDiscountLabel: UILabel!
    
    private var viewModel: ProductDetailsViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = .red
        pageIndicator.pageIndicatorTintColor = .lightGray
        imageSlideShow.pageIndicator = pageIndicator
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        viewModel?
            .productName
            .drive(
                onNext: {[weak self] name in
                self?.productNameTitleLabel.text = name
                self?.productNameLabel.text = name
                })
            .disposed(by: disposeBag)
        
        viewModel?
            .prodcutPrice
            .drive(onNext: { [weak self] price in
                self?.priceTitleLabel.text = price
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .imagesURL
            .drive(onNext: { [weak self] images in
                if images.isEmpty {
                    self?.imageSlideShow.setImageInputs([ImageSource(image: #imageLiteral(resourceName: "defaultProductImage"))])
                } else {
                    self?.imageSlideShow.setImageInputs(images.compactMap { return AlamofireSource(urlString: $0) })
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .productCode
            .drive(onNext: { [weak self] code in
                self?.productCodeLabel.attributedText = code
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .shouldHideOutOfStockView
            .drive(onNext: { [weak self] hidden in
                self?.outOfStockView.isHidden = hidden
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .isLoading
            .drive(onNext: { loading in
                loading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .discountPrice
            .drive(onNext: {[weak self] price in
                self?.discountPriceLabel.text = price
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .salePrice
            .drive(onNext: {[weak self] price in
                self?.salePriceLabel.attributedText = price
            })
            .disposed(by: disposeBag)
        
        viewModel?
            .precentDiscount
            .drive(onNext: {[weak self] percent in
                if let percent = percent {
                    self?.percentDiscountLabel.text = percent
                } else {
                    self?.percentDiscountLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barStyle = .default
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.tintColor = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func setup(with viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
    }
}
