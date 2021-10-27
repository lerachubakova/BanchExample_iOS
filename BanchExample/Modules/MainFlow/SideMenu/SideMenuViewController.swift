//
//  SideMenuViewController.swift
//  BanchExample
//
//  Created by User on 13.09.21.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    func selectRow(with option: String)
}

final class SideMenuViewController: UIViewController {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var sideMenuTableView: UITableView!

    weak var delegate: SideMenuViewControllerDelegate?

    let options: [String] = [LocalizeKeys.home,
                             LocalizeKeys.info,
                             LocalizeKeys.googleMaps,
                             LocalizeKeys.shareApp,
                             LocalizeKeys.settings]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setLocalizedStrings()
        LanguageObserver.subscribe(self)
    }

    private func configureTableView() {
        sideMenuTableView.register(SideMenuTVCell.nib, forCellReuseIdentifier: SideMenuTVCell.identifier)
        sideMenuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        sideMenuTableView.isScrollEnabled = false
    }

    private func setLocalizedStrings() {
        footerLabel.text = LocalizeKeys.footer.localized()
        headerLabel.text = LocalizeKeys.header.localized()
        DispatchQueue.main.async { [weak self] in
            self?.sideMenuTableView.reloadData()
        }
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
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTVCell.identifier, for: indexPath) as? SideMenuTVCell else {
            fatalError("\(String(describing: self) ): xib doesn't exist")
        }

        cell.setTitle(title:options[indexPath.item].localized())

        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.2300506075, green: 0.2300506075, blue: 0.2300506075, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectRow(with: options[indexPath.item])
        if options[indexPath.item] == LocalizeKeys.settings || options[indexPath.item] == LocalizeKeys.shareApp {
            sideMenuTableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

// MARK: - LanguageSubscriber
extension SideMenuViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}
