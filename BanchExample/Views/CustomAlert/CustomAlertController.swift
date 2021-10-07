//
//  CustomAlertController.swift
//  BanchExample
//
//  Created by User on 6.10.21.
//

import UIKit

class CustomAlertController: UIViewController {
    private var alertView: CustomAlertView!

    init(title: String = "Error", text: String = "We have some error") {
        super.init(nibName: nil, bundle: Bundle.main)

        alertView = (Bundle.main.loadNibNamed(String(describing: CustomAlertView.self), owner: self, options: nil)?.first as? CustomAlertView)!
        alertView.configure(title: title, body: text)

        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen

        view = alertView
    }

    func addAction(title: String, completion: (() -> Void)? = nil) {
        if alertView.getButtonsCount() == 0 {
            let button = alertView.addFirstAction(title: title, completion: completion)
            button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        } else if alertView.getButtonsCount() == 1 {
            let secondButton = alertView.addSecondAction(title: title, completion: completion)
            secondButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismissView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
