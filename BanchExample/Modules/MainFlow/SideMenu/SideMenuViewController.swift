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

    weak var delegate: SideMenuViewControllerDelegate?

    private let sideMenuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SideMenuTVCell.nib, forCellReuseIdentifier: SideMenuTVCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .darkGray
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(sideMenuTableView)
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sideMenuTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 44 , width: view.bounds.size.width, height: view.bounds.size.height)
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
