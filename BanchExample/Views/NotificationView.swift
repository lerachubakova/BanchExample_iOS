//
//  NotificationView.swift
//  BanchExample
//
//  Created by User on 11.11.21.
//
import SnapKit
import UIKit

class NotificationView: UIView {

    static let duration: Double = 1.8

    private var height: CGFloat = 0

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.backgroundColor = .gray
        self.isHidden = true
        setupMessageLabel()
    }

    private func setupMessageLabel() {
        self.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.bottom.equalToSuperview().offset(-14)
            maker.top.equalToSuperview().offset(14)
        }
    }

    func present(message: String) {
        self.isHidden = false
        messageLabel.text = message
        self.superview?.layoutIfNeeded()
        height = self.frame.height

        let duration = 0.45
        let delay = 0.9
        let startPosition = self.frame.origin.y

        showAnimation(duration: duration, startPosition: startPosition) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.hideAnimation(duration: duration, startPosition: startPosition)
            }
        }
    }

    private func showAnimation(duration: Double, startPosition: CGFloat, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: 0,
                       options: .curveLinear,
                       animations: { [unowned self] in
                        self.frame.origin.y = startPosition + self.height
                       },
                       completion: completion)
    }

    private func hideAnimation(duration: Double, startPosition: CGFloat) {

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.frame.origin.y = startPosition
                       },
                       completion: nil)
    }
}
