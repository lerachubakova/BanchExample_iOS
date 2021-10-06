//
//  CustomAlertView.swift
//  BanchExample
//
//  Created by User on 6.10.21.
//

import UIKit

class CustomAlertView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet public weak var button: UIButton!

    func configure(title: String, body: String, buttonTitle: String) {
        titleLabel.text = title
        textLabel.text = body
    }

}
