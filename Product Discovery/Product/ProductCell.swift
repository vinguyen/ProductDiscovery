//
//  ProductCell.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/1/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductCell: UITableViewCell {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountView: UIView!
    @IBOutlet private weak var discountPriceLabel: UILabel!
    @IBOutlet private weak var discountPricePercentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.af_cancelImageRequest()
    }
    
    func update(with productItem: Product) {
        productImageView.af_cancelImageRequest()
        productImageView.image = #imageLiteral(resourceName: "defaultProductImage")
        if let imagesData = productItem.images as Data?,
            let images = NSKeyedUnarchiver.unarchiveObject(with: imagesData) as? JSONArray,
            let imageURLString = (images.first as? JSONDictionary)?["url"] as? String,
            let imageURL = URL(string: imageURLString) {
            productImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "defaultProductImage"))
        }
        nameLabel.text = productItem.displayName
        
        if productItem.discountPrice != 0 && productItem.discountPrice < productItem.price {
            priceLabel.text = NumberFormatter.localizedFormattedNumber(from: productItem.discountPrice) + " đ"
            discountView.isHidden = false
            let salePriceAttributedString = NSMutableAttributedString(
                string: NumberFormatter.localizedFormattedNumber(from: productItem.price)
            )
            salePriceAttributedString
                .setRegular(for: NumberFormatter.localizedFormattedNumber(from: productItem.price), ofSize: 12)
                .setStrikeThrough(for: NumberFormatter.localizedFormattedNumber(from: productItem.price))
            discountPriceLabel.attributedText = salePriceAttributedString
            let discountPercent = (productItem.price - productItem.discountPrice) /  productItem.price
            discountPricePercentLabel.text = "\(discountPercent) %"
        } else {
            priceLabel.text = NumberFormatter.localizedFormattedNumber(from: productItem.price) + " đ"
            discountView.isHidden = true
        }
    }

}
