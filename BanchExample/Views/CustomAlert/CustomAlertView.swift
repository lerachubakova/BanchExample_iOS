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

    class func loadFromNib() -> CustomAlertView {
        (Bundle.main.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?.first as? CustomAlertView)!
    }

    func configure(title: String, body: String, buttonTitle: String) {
        titleLabel.text = title
        textLabel.text = body
        button.setTitle(buttonTitle, for: .normal)
    }

}

class CustomAlertController: UIViewController {

    init(title: String = "Error", text: String = "We have some error", buttontext: String = "OK") {
        super.init(nibName: nil, bundle: Bundle.main)

        let alertView = (Bundle.main.loadNibNamed(String(describing: CustomAlertView.self), owner: self, options: nil)?.first as? CustomAlertView)!
        alertView.configure(title: title, body: text, buttonTitle: buttontext)

        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen

        alertView.button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = alertView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
