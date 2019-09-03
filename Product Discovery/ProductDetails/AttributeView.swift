//
//  AttributeView.swift
//  Product Discovery
//
//  Created by vi nguyen on 9/3/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import UIKit

class AttributeView: UIStackView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func updateInfo(with name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }
    
    func setColor() {
        nameLabel.backgroundColor = Color.coolGray
        valueLabel.backgroundColor = Color.coolGray
    }

}
