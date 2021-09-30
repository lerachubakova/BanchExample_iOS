//
//  ViewController.swift
//  BanchExample
//
//  Created by User on 13.09.21.
//

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
    private var homeNVC: UINavigationController!
    private var homeVC: HomeViewController!

    private var infoNVC: UINavigationController!
    private var infoVC: InformationViewController!

    private var appRatingVC: AppRatingViewController!
    private var settingVC: SettingsViewController!

    private var menuState: MenuState = .closed
    private var menuPosition: MenuPosition = .up

    private let sideMenuWidth: CGFloat = 200
    private let animationDuration: Double = 0.35
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuShadowView: UIView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        setupShadowView()

        setupChildVC()

        addVCSubviews()

        setupTapGestureRecognizer()

        setupConstraints()
    }

    // MARK: - Setup
    private func setupShadowView() {
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        sideMenuShadowView.isUserInteractionEnabled = false
    }

    private func setupChildVC() {
        setupSideMenuVC()
        setupHomeVC()
        setupInfoVC()
        setupAppRatingVC()
        setupSettingsVC()
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

    private func setupHomeVC() {
        let homeNavVC = UIStoryboard(name: "HomeNavigation", bundle: Bundle.main).instantiateViewController(identifier: "MainNavVC") as UINavigationController
        homeNVC = homeNavVC
        homeNVC.view.tag = 99
        if let vc = homeNavVC.viewControllers[0] as? HomeViewController {
            homeVC = vc
        } else {
            homeVC = HomeViewController()
        }
        homeVC.delegate = self

        addChild(homeNavVC)
        homeNavVC.didMove(toParent: self)
    }

    private func setupInfoVC() {
        let infoNavVC = UIStoryboard(name: "Information", bundle: Bundle.main).instantiateViewController(identifier: "InfoNavVC") as UINavigationController
        infoNVC = infoNavVC

        if let vc = infoNavVC.viewControllers[0] as? InformationViewController {
            infoVC = vc
        } else {
            infoVC = InformationViewController()
        }
        infoVC.delegate = self
        infoNVC.view.tag = 99
    }

    private func setupAppRatingVC() {
        if let vc = UIStoryboard(name: "AppRating", bundle: Bundle.main).instantiateInitialViewController() as? AppRatingViewController {
            appRatingVC = vc
        } else {
            appRatingVC = AppRatingViewController()
        }
    }

    private func setupSettingsVC() {
        if let vc = UIStoryboard(name: "Settings", bundle: Bundle.main).instantiateInitialViewController() as? SettingsViewController {
            settingVC = vc
        } else {
            settingVC = SettingsViewController()
        }
    }

    private func addVCSubviews() {
        if menuPosition == .down {
            view.insertSubview(sideMenuVC.view, at: 0)
            view.insertSubview(homeNVC.view, at: 1)
        } else {
            view.insertSubview(homeNVC.view, at: 0)
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

        if self.menuPosition == .up {
            self.sideMenuTrailingConstraint = self.sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideMenuWidth)
            self.sideMenuTrailingConstraint.isActive = true
        } else {
            self.sideMenuTrailingConstraint = self.sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
            self.sideMenuTrailingConstraint.isActive = true
        }
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

    func showViewController<Type: UIViewController>(viewController: Type.Type, storyboardName: String, storyboardId: String) {
        // Remove the previous View
        for subview in view.subviews where subview.tag == 99 {
            subview.removeFromSuperview()
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Type else { return }
        vc.view.tag = 99
       // view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        print("\n LOG vc.view.frame.origin.x: \(vc.view.frame.origin.x)")

//        if !self.revealSideMenuOnTop {
//            if isExpanded {
//                vc.view.frame.origin.x = 260.0
//            }
//            if self.sideMenuShadowView != nil {
//                vc.view.addSubview(self.sideMenuShadowView)
//            }
//        }
        vc.didMove(toParent: self)
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
            addNewAndRemoveOld(vc: homeNVC)
        case .info:
            addNewAndRemoveOld(vc: infoNVC)
        case .appRating:
            addNewAndRemoveOld(vc: appRatingVC)
        case .shareApp:
            break
        case .settings:
            addNewAndRemoveOld(vc: settingVC)
        }

        if menuPosition == .down {
            self.toggleMenu()
        }
    }

    private func addNewAndRemoveOld(vc: UIViewController) {
        for subview in view.subviews where subview.tag == 99 {
            subview.removeFromSuperview()
        }

        for child in homeVC.children {
            child.didMove(toParent: nil)
        }

        self.addChild(vc)
        vc.view.tag = 99

        if menuPosition == .up {
            view.insertSubview(vc.view, at: 0)
        } else {
            view.insertSubview(vc.view, at: 1)
            vc.view.frame.origin.x = sideMenuWidth
        }
        vc.didMove(toParent: self)
    }

}
