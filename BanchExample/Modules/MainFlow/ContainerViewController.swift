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
    private let sideMenuVC = SideMenuViewController()
    private var homeVC: HomeViewController!
    private var infoVC: InformationViewController!

    private var menuState: MenuState = .closed
    private var menuPosition: MenuPosition = .up

    private let sideMenuWidth: CGFloat = 200
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var sideMenuShadowView: UIView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red

        setupShadowView()

        sideMenuVC.delegate = self
        addChild(sideMenuVC)

        if menuPosition == .down {
            view.addSubview(sideMenuVC.view)
        }

        sideMenuVC.didMove(toParent: self)

        setupHomeVC()

        setupInfoVC()

        if menuPosition == .up {
            view.addSubview(sideMenuShadowView)
            view.addSubview(sideMenuVC.view)
        }

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

    private func setupHomeVC() {
        let homeNavVC = UIStoryboard(name: "HomeNavigation", bundle: Bundle.main).instantiateViewController(identifier: "MainNavVC") as UINavigationController

        if let vc = homeNavVC.viewControllers[0] as? HomeViewController {
            homeVC = vc
        } else {
            homeVC = HomeViewController()
        }
        homeVC.delegate = self

        addChild(homeNavVC)
        view.addSubview(homeNavVC.view)
        homeNavVC.didMove(toParent: self)
    }

    private func setupInfoVC() {
        if let vc = UIStoryboard(name: "Information", bundle: Bundle.main).instantiateViewController(identifier: "InformationVC") as? InformationViewController {
            infoVC = vc
        } else {
            infoVC = InformationViewController()
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
        UIView.animate(withDuration: 0.5) { [unowned self] in
            if menuPosition == .down {
                self.homeVC.navigationController?.view.frame.origin.x = x
            } else {
                self.sideMenuTrailingConstraint.constant = x
                self.view.layoutIfNeeded()
            }
        } completion: {[unowned self] done in
            if done {
                menuState.toggle()
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }

    func animateShadow(isDark: Bool) {
        UIView.animate(withDuration: 0.5) { [unowned self] in
            sideMenuShadowView.alpha = isDark ? 0.7 : 0.0
        }
    }

}
// MARK: - SideMenuViewControllerDelegate
extension ContainerViewController: SideMenuViewControllerDelegate {
    func selectRow(with option: MenuOptions) {
        self.toggleMenu()
        switch option {
        case .home:
            self.resetToHome()
        case .info:
            self.addInfoVC()
        case .appRating:
            break
        case .shareApp:
            break
        case .settings:
            break
        }
    }

    private func addInfoVC() {
        homeVC.addChild(infoVC)
        homeVC.view.addSubview(infoVC.view)
        infoVC.view.frame = homeVC.view.bounds
        infoVC.didMove(toParent: homeVC)
        homeVC.title = "Information"

        // let infoNVC = UINavigationController(rootViewController: infoVC)
        // self?.present(infoNVC, animated: true, completion: nil)
    }

    private func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        homeVC.title = "Home"
    }

}
