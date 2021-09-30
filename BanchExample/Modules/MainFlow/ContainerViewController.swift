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
}

enum MenuPosition {
    case up
    case down
}

// MARK: - ContainerViewController
class ContainerViewController: UIViewController {

    // MARK: - Private Properties
    private var sideMenuVC: SideMenuViewController!
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuShadowView: UIView!

    // You can change it before start
    private var menuState: MenuState = .closed
    private var menuPosition: MenuPosition = .down

    private let sideMenuWidth: CGFloat = 200
    private let animationDuration: Double = 0.35

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupShadowView()

        setupSideMenuVC()

        addSubviews()

        setupTapGestureRecognizer()

        setupConstraints()

        showViewController(viewController: UINavigationController.self, storyboardName: "HomeNavigation")

    }

    // MARK: - Setup
    private func setupShadowView() {
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.tag = 13
        self.sideMenuShadowView.alpha = menuState == .opened ? 0.7 : 0.0
        sideMenuShadowView.isUserInteractionEnabled = false
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
        } else {
            view.insertSubview(sideMenuShadowView, at: 1)
            view.insertSubview(sideMenuVC.view, at: 2)
        }
    }

    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
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
}

// MARK: - HomeViewControllerDelegate
extension ContainerViewController: HomeViewControllerDelegate {
    func tappedMenuButton() {
        toggleMenu()
    }

    func toggleMenu(completion: (() -> Void)? = nil) {
        switch menuState {
        case .opened:
            if menuPosition == .up {
                animateSideMenu(x: -sideMenuWidth, completion: completion)
            } else {
                animateSideMenu(x: 0, completion: completion)
            }
            animateShadow(isDark: false)
        case .closed:
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
    func selectRow(with option: MenuOptions) {
        if menuPosition == .up {
            self.toggleMenu()
        }

        switch option {
        case .home:
            showViewController(viewController: UINavigationController.self, storyboardName: "HomeNavigation")
        case .info:
            showViewController(viewController: UINavigationController.self, storyboardName: "Information")
        case .appRating:
            // showViewController(viewController: UIViewController.self, storyboardName: "AppRating")
            let safariVC = SFSafariViewController(url: URL(string: "http://vironit.timesummary.com")!)
            present(safariVC, animated: true)
        case .shareApp:
            break
        case .settings:
            self.present(UIStoryboard(name: "Settings", bundle: Bundle.main).instantiateInitialViewController()!, animated: true)
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
