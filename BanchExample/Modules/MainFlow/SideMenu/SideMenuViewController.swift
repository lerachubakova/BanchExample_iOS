//
//  SideMenuViewController.swift
//  BanchExample
//
//  Created by User on 13.09.21.
//

import UIKit

enum MenuOptions: String, CaseIterable {
    case home = "Home"
    case info = "Information"
    case appRating = "App Rating"
    case shareApp = "Share App"
    case settings = "Settings"
}

protocol SideMenuViewControllerDelegate: AnyObject {
    func selectRow(with option: MenuOptions)
}

class SideMenuViewController: UIViewController {

    @IBOutlet private weak var sideMenuTableView: UITableView!

    weak var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView.register(SideMenuTVCell.nib, forCellReuseIdentifier: SideMenuTVCell.identifier)
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }

    public func enableTableViewUserIteraction(isEnabled: Bool) {
        sideMenuTableView.isUserInteractionEnabled = isEnabled
    }
}

    // MARK: - UITableViewDelegate
    extension SideMenuViewController: UITableViewDelegate {

    }

    // MARK: - UITableViewDataSource
    extension SideMenuViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return MenuOptions.allCases.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTVCell.identifier, for: indexPath) as? SideMenuTVCell else {
                fatalError("\(String(describing: self) ): xib doesn't exist")
            }

            cell.setTitle(title: MenuOptions.allCases[indexPath.item].rawValue)

            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.2300506075, green: 0.2300506075, blue: 0.2300506075, alpha: 1)
            cell.selectedBackgroundView = myCustomSelectionColorView
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.selectRow(with: MenuOptions.allCases[indexPath.item])
        }
    }
