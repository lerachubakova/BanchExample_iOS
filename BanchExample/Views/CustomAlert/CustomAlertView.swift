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
    @IBOutlet private weak var secondButton: UIButton!

    private var completion: (() -> Void)?
    private var secondCompletion: (() -> Void)?

    private var buttonsCount: Int = 0

    func getButtonsCount() -> Int {
        buttonsCount
    }

    func configure(title: String, body: String) {
        titleLabel.text = title
        textLabel.text = body
    }

    func addFirstAction(title: String, completion: (() -> Void)? = nil) -> UIButton {
        self.completion = completion
        button.setTitle(title, for: .normal)
        button.isHidden = false
        buttonsCount += 1
        return button
    }

    func addSecondAction(title: String, completion: (() -> Void)? = nil) -> UIButton {
        self.secondCompletion = completion
        secondButton.setTitle(title, for: .normal)
        secondButton.isHidden = false
        buttonsCount += 1
        return secondButton
    }

    @IBAction private func tappedButton(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            completion?()
        case 2:
            secondCompletion?()
        default:
            break
        }
    }

}
