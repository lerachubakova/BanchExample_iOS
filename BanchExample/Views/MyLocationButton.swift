//
//  MyLocationButton.swift
//  BanchExample
//
//  Created by User on 3.11.21.
//

import UIKit

@IBDesignable final class MyLocationButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        self.addConstraint(heightConstraint)
        self.addConstraint(widthConstraint)

        self.layer.cornerRadius = heightConstraint.constant / 2

        let inset: CGFloat = heightConstraint.constant / 4
        self.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        self.setImage(UIImage(named: "icMyLocation"), for: .normal)

        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset.height = 5.0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.45
        self.layer.shadowOffset.height = 5.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setup()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setup()
    }
}
