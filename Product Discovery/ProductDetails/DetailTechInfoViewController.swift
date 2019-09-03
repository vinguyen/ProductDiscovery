//
//  DetailTechInfoViewController.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import RxSwift

class DetailTechInfoViewController: UIViewController {
    private var viewModel: DetailTechInfoViewModel?
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(with viewModel: DetailTechInfoViewModel) {
        self.viewModel = viewModel
        self.viewModel?.productAttributes.asObservable().subscribe(onNext: {[weak self] attributes in
            guard !attributes.isEmpty else { return }
            self?.stackView.removeAllArrangedSubviews()
            attributes.enumerated().forEach { (index, element) in
                guard index <= 3 else { return }
                if let attributeView = UINib(nibName: "AttributeView", bundle: nil)
                    .instantiate(withOwner: nil, options: nil).first as? AttributeView {
                    attributeView.updateInfo(with: (element["name"] as? String) ?? "",
                                             value: (element["value"] as? String) ?? "")
                    attributeView.frame.size.height = 35.0
                    if index % 2 == 0 {
                        attributeView.setColor()
                    }
                    self?.stackView.addArrangedSubview(attributeView)
                }
            }
            if attributes.count > 4 {
                self?.blurView.isHidden = false
                self?.bottomView.isHidden = false
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func showMore() {
        blurView.isHidden = true
        bottomView.isHidden = true
        stackView.removeAllArrangedSubviews()
        viewModel?.productAttributes.value.enumerated().forEach { (index, element) in
            if let attributeView = UINib(nibName: "AttributeView", bundle: nil)
                .instantiate(withOwner: nil, options: nil).first as? AttributeView {
                attributeView.updateInfo(with: (element["name"] as? String) ?? "",
                                         value: (element["value"] as? String) ?? "")
                attributeView.frame.size.height = 35.0
                if index % 2 == 0 {
                    attributeView.setColor()
                }
                stackView.addArrangedSubview(attributeView)
            }
        }
    }

}
