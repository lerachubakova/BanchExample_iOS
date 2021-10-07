//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let container = self.navigationController?.parent as? HomeViewControllerDelegate {
            delegate = container
        }

        setLocalizedStrings()
        configureTableView()
        LanguageObserver.subscribe(self)
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.info.localized()
    }

    private func configureTableView() {
        tableView.register(InfoTVCell.nib(), forCellReuseIdentifier: InfoTVCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }
}

// MARK: - LanguageSubscriber
extension InformationViewController: LanguageSubscriber {
    func update() {
        self.setLocalizedStrings()
    }
}

// MARK: - UITableViewDelegate
extension InformationViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension InformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var res = 0
        switch section {
        case 0: res = 3
        case 1: res = 1
        case 2: res = 2
        default: break
        }
        return res
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoTVCell = tableView.dequeueReusableCell(withIdentifier: InfoTVCell.identifier) as? InfoTVCell else { return UITableViewCell() }
        return infoTVCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.red
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 44))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = String(section)
        return headerView
    }

}
