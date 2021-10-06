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
    @IBOutlet private weak var button: UIButton!

    class func loadFromNib() -> CustomAlertView {
        (Bundle.main.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?.first as? CustomAlertView)!
    }

    func configure(title: String? = "Error", body: String? = "We have some error", buttonTitle: String? = "OK") {
        
        titleLabel.text = title
        textLabel.text = body
        button.setTitle(buttonTitle, for: .normal)
    }

    @IBAction private func tappedButton(_ sender: Any) {
        self.removeFromSuperview()
    }
}
