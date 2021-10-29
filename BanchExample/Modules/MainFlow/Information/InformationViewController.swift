//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import UIKit

final class InformationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private weak var delegate: HomeViewControllerDelegate?
    private weak var container: ContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = navigationController?.parent as? HomeViewControllerDelegate
        container = navigationController?.parent as? ContainerViewController

        setLocalizedStrings()
        LanguageObserver.subscribe(self)

        let animationDuration = container?.animationDuration ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.checkAuthorization()
        }
    }

    private func configureTableView() {
        tableView.register(InfoTVCell.nib(), forCellReuseIdentifier: InfoTVCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.isHidden = false
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.info.localized()
    }

    private func checkAuthorization() {
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            makeAuthorizationRequest()
        case .granted:
            configureTableView()
        case .unauthorized:
            container?.showOpenSettingsAlert()
        }
    }

    private func makeAuthorizationRequest() {
        PHLibraryAuthorizationManager.requestPhotoLibraryAuthorization { status in
            switch status {
            case .granted:
                DispatchQueue.main.async { [weak self] in
                    self?.configureTableView()
                    self?.tableView.reloadData()
                }
            case .unauthorized:
                DispatchQueue.main.async { [weak self] in
                    self?.container?.showOpenSettingsAlert()
                }
            case .notRequested:
                break
            }
        }
    }

    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }
}

// MARK: - LanguageSubscriber
extension InformationViewController: LanguageSubscriber {
    func updateLanguage() {
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
        case 1: res = 2
        case 2: res = 4
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
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.darkGray
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: self.view.frame.size.width, height: 30))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = "Section \(section)"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collectionViewCellHeight: CGFloat = (self.view.frame.size.width - 20)/3
        return collectionViewCellHeight + 30 + 10
    }
}
