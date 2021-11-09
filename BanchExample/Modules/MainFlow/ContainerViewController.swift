//
//  ViewController.swift
//  BanchExample
//
//  Created by User on 13.09.21.
//

import SafariServices
import UIKit

enum MenuState {
    case opened
    case closed

    mutating func toggle() {
        switch self {
        case .opened:
            self = .closed
        case .closed:
            self = .opened
        }
    }

    func isOpen() -> Bool {
        return self == .opened
    }

    func isClosed() -> Bool {
        return self == .closed
    }
}

enum MenuPosition {
    case up
    case down
}

// MARK: - ContainerViewController
final class ContainerViewController: UIViewController {
    
    // MARK: - Public Properties
    let animationDuration: Double = 0.35

    // MARK: - Private Properties
    private var sideMenuVC: SideMenuViewController!
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuShadowView: UIView!

    // You can change it before start
    private var menuState: MenuState = .closed
    private var menuPosition: MenuPosition = .up

    private var isGestureEnabled = false
    private var isDraggingEnabled = false

    private let sideMenuWidth: CGFloat = 200

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShadowView()
        setupSideMenuVC()
        addSubviews()
        setupGestureRecognizers()
        setupConstraints()
        showViewController(viewController: UINavigationController.self, storyboardName: "HomeNavigation")
    }

    // MARK: - Setup
    private func setupShadowView() {
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = menuPosition == .up ? .black : .clear
        self.sideMenuShadowView.tag = 13
        self.sideMenuShadowView.alpha = menuState == .opened ? 0.7 : 0.0
    }

    private func setupSideMenuVC() {
        if let vc = UIStoryboard(name: "SideMenu", bundle: Bundle.main).instantiateInitialViewController() as? SideMenuViewController {
            sideMenuVC = vc
        } else {
            sideMenuVC = SideMenuViewController()
        }
        sideMenuVC.delegate = self
        addChild(sideMenuVC)
        sideMenuVC.didMove(toParent: self)
    }

    private func addSubviews() {
        if menuPosition == .down {
            view.insertSubview(sideMenuVC.view, at: 0)
            view.insertSubview(sideMenuShadowView, at: 2)
        } else {
            view.insertSubview(sideMenuShadowView, at: 1)
            view.insertSubview(sideMenuVC.view, at: 2)
        }
    }

    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)

        if isGestureEnabled {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            panGestureRecognizer.delegate = self
            view.addGestureRecognizer(panGestureRecognizer)
        }
    }

    private func setupConstraints() {
        self.sideMenuVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.sideMenuVC.view.widthAnchor.constraint(equalToConstant: sideMenuWidth),
            self.sideMenuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuVC.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        self.sideMenuTrailingConstraint = self.sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.menuPosition == .up ? -sideMenuWidth : 0)
        if menuState == .opened {
            self.sideMenuTrailingConstraint.constant = 0
        }
        self.sideMenuTrailingConstraint.isActive = true
    }

    func showOpenSettingsAlert() {
        let title = LocalizeKeys.Alerts.continueTitle.localized()
        let message = LocalizeKeys.Alerts.photoLibraryMessage.localized()
        let settingsButtonTitle = LocalizeKeys.Alerts.openSettingsButton.localized()
        let noButtonTitle = LocalizeKeys.Alerts.noThanksButton.localized()

        let alert = CustomAlertController(title: title, message: message)

        alert.addAction(title: settingsButtonTitle) {
            let settingURLString = UIApplication.openSettingsURLString
            if let url = URL(string: settingURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        alert.addAction(title: noButtonTitle)

        self.present(alert, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc private func tappedView() {
        if menuState == .opened {
            toggleMenu()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let res = touch.view?.isDescendant(of: self.sideMenuVC.view), res {
            return false
        }
        return true
    }

    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard isGestureEnabled == true else { return }

        switch sender.state {
        case .began:
            beginGesture(sender)
        case .changed:
            changeGesture(sender)
        case .ended:
            endGesture(sender)
        default:
            break
        }
    }

    private func beginGesture(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self.view).x

        if velocity > 0, self.menuState.isOpen() { sender.state = .cancelled }

        if (velocity > 0 && self.menuState.isClosed()) || (velocity < 0 && self.menuState.isOpen()) {
            self.isDraggingEnabled = true
        }

        guard self.isDraggingEnabled else { return }

        if abs(velocity) > 550 {
            self.isDraggingEnabled = false
            self.toggleMenu()
            return
        }

    }

    private func changeGesture(_ sender: UIPanGestureRecognizer) {
        guard self.isDraggingEnabled else { return }

        let position = sender.translation(in: self.view).x

        switch self.menuPosition {
        case .up:
            let percentage = (position * 150 / self.sideMenuWidth) / self.sideMenuWidth

            if menuState.isClosed() {
                let alpha = percentage >= 0.7 ? 0.7 : percentage
                self.sideMenuShadowView.alpha = alpha

                if position <= self.sideMenuWidth {
                    self.sideMenuTrailingConstraint.constant = -self.sideMenuWidth + position
                }
            } else {
                let alpha = 0.7 + percentage >= 0 ? 0.7 + percentage : 0.0

                if alpha >= 0, alpha <= 0.7 {
                    self.sideMenuShadowView.alpha = alpha
                }

                if position <= 0 {
                    self.sideMenuTrailingConstraint.constant = position
                }
            }
        case .down:
            if let recogView = sender.view?.subviews[1] {
                if recogView.frame.origin.x <= self.sideMenuWidth, recogView.frame.origin.x >= 0 {
                    recogView.frame.origin.x += position
                    sender.setTranslation(CGPoint.zero, in: view)
                }
            }
        }
    }

    private func endGesture(_ sender: UIPanGestureRecognizer) {
        self.isDraggingEnabled = false
        // If the side menu is half Open/Close, then Expand/Collapse with animation
        switch self.menuPosition {
        case .up:
            if menuState.isClosed() {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuWidth * 0.5)
                self.menuState = movedMoreThanHalf ? .closed : .opened
            } else {
                let movedMoreThanHalf = abs(self.sideMenuTrailingConstraint.constant) > self.sideMenuWidth * 0.5
                self.menuState = movedMoreThanHalf ? .opened : .closed
            }
        case .down:
            if let recogView = sender.view?.subviews[1] {
            let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuWidth * 0.5
            self.menuState = movedMoreThanHalf ? .closed : .opened
            }
        }
        self.toggleMenu()
    }
}

// MARK: - HomeViewControllerDelegate
extension ContainerViewController: HomeViewControllerDelegate {
    func tappedMenuButton() {
        toggleMenu()
    }

    func toggleMenu(completion: (() -> Void)? = nil) {
        switch menuState {
        case .opened:
            _ = view.subviews.map { if $0.tag == 99 { $0.isUserInteractionEnabled = true }}
            if menuPosition == .up {
                animateSideMenu(x: -sideMenuWidth, completion: completion)
            } else {
                animateSideMenu(x: 0, completion: completion)
            }
            animateShadow(isDark: false)
        case .closed:
            _ = view.subviews.map { if $0.tag == 99 { $0.isUserInteractionEnabled = false }}
            if menuPosition == .up {
                animateSideMenu(x: 0, completion: completion)
            } else {
                animateSideMenu(x: sideMenuWidth, completion: completion)
            }
            animateShadow(isDark: true)
        }
    }

    func animateSideMenu(x: CGFloat, completion: (() -> Void)? = nil) {
        sideMenuVC.enableTableViewUserIteraction(isEnabled: false)
        UIView.animate(withDuration: animationDuration) { [unowned self] in
            if menuPosition == .down {
                self.view.subviews[1].frame.origin.x = x
                sideMenuShadowView.frame.origin.x = x
            } else {
                self.sideMenuTrailingConstraint.constant = x
                self.view.layoutIfNeeded()
            }
        } completion: {[unowned self] done in
            if done {
                menuState.toggle()
                sideMenuVC.enableTableViewUserIteraction(isEnabled: true)
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }

    func animateShadow(isDark: Bool) {
        UIView.animate(withDuration: animationDuration) { [unowned self] in
            sideMenuShadowView.alpha = isDark ? 0.7 : 0.0
        }
    }

}

// MARK: - SideMenuViewControllerDelegate
extension ContainerViewController: SideMenuViewControllerDelegate {
    func selectRow(with option: String) {
        if menuPosition == .up {
            self.toggleMenu()
        }

        switch option {
        case LocalizeKeys.home:
            showViewController(viewController: UINavigationController.self, storyboardName: "HomeNavigation")
        case LocalizeKeys.info:
            showViewController(viewController: UINavigationController.self, storyboardName: "PHLibraryNavigation")
        case LocalizeKeys.googleMaps:
             showViewController(viewController: UINavigationController.self, storyboardName: "GoogleMaps")
        case LocalizeKeys.appleMaps:
            showViewController(viewController: UINavigationController.self, storyboardName: "AppleMaps")
        case LocalizeKeys.settings:
            showViewController(viewController: UINavigationController.self, storyboardName: "SettingsNavigation")
        default: break
        }

        if menuPosition == .down {
            self.toggleMenu()
        }
    }

    private func showViewController<Type: UIViewController>(viewController: Type.Type, storyboardName: String) {
        for subview in view.subviews where subview.tag == 99 {
            subview.removeFromSuperview()
        }

        for child in self.children {
            child.didMove(toParent: nil)
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateInitialViewController() as? Type else { return }

        self.addChild(vc)
        vc.view.tag = 99

        if menuPosition == .up {
            view.insertSubview(vc.view, at: 0)
        } else {
            view.insertSubview(vc.view, at: 1)
            if menuState == .opened {
                vc.view.frame.origin.x = sideMenuWidth
            }
        }
        vc.didMove(toParent: self)
    }

}
