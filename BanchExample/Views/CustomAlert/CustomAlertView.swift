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

    private var buttonsCount = 0
    private let borderWidth: CGFloat = 0.4
    private let borderAlpha: CGFloat = 0.6

    func getButtonsCount() -> Int {
        buttonsCount
    }

    func configure(title: String, body: String) {
        titleLabel.text = title
        textLabel.text = body
        button.superview?.layer.addBorder(edge: UIRectEdge.top, color: UIColor.white.withAlphaComponent(borderAlpha), thickness: borderWidth)
        titleLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white.withAlphaComponent(borderAlpha), thickness: borderWidth)
        button.isHidden = true
        secondButton.isHidden = true
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
        button.layer.addBorder(edge: UIRectEdge.right, color: UIColor.white.withAlphaComponent(borderAlpha), thickness: borderWidth)
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
