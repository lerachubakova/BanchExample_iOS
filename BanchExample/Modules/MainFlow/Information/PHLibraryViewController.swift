//
//  PHLibraryViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import Lottie
import SnapKit
import UIKit

final class PHLibraryViewController: UIViewController {
    // MARK: UIElements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InfoTVCell.nib(), forCellReuseIdentifier: InfoTVCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.isHidden = true
        tableView.backgroundColor = .clear
        return tableView
    }()

    private lazy var backgroundMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()

    private lazy var bigAnimationView: AnimationView = {
        let animationView = AnimationView(name: "loading-state")
        animationView.isHidden = true
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        return animationView
    }()

    // MARK: - Private Properties
    private weak var delegate: HomeViewControllerDelegate?
    private var viewModel: PHLibraryViewModel!

    // MARK: - Internal Properties
    weak var container: ContainerViewController?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PHLibraryViewModel(vc: self)
        delegate = navigationController?.parent as? HomeViewControllerDelegate
        container = navigationController?.parent as? ContainerViewController

        setLocalizedStrings()
        configureUIElements()

        LanguageObserver.subscribe(self)
    }

    // MARK: - UISetup
    private func configureUIElements() {
        view.backgroundColor = .lightGray
        configureMenuBarButtonItem()
        configureBackgroundMessageLabel()
        configureTableView()
        configureAnimationView()
    }

    private func configureMenuBarButtonItem() {
        let menuBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(tappedMenuButton))
        menuBarButtonItem.tintColor = .black
        menuBarButtonItem.image = UIImage(systemName: "line.horizontal.3")
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: true)
    }

    private func configureBackgroundMessageLabel() {
        self.view.addSubview(backgroundMessageLabel)
        backgroundMessageLabel.translatesAutoresizingMaskIntoConstraints = false

        backgroundMessageLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalTo(264)
        }
    }

    private func configureTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.top.equalToSuperview()
        }
    }

    private func configureAnimationView() {
        self.view.addSubview(bigAnimationView)
        bigAnimationView.translatesAutoresizingMaskIntoConstraints = false

        bigAnimationView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.4)
            maker.height.equalTo(bigAnimationView.snp.width)
        }
    }

    // MARK: - Setup
    private func setLocalizedStrings() {
        title = LocalizeKeys.info.localized()
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            break
        case .granted:
            backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPhotoMessage.localized()
        case .unauthorized:
            backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPermission.localized()
        }
    }
    
    // MARK: - Logic
    func setNoPermissionBackgroundLabel() {
        backgroundMessageLabel.isHidden = false
        backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPermission.localized()
    }

    func setNoPhotoMessageLabel() {
        backgroundMessageLabel.isHidden = false
        backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPhotoMessage.localized()
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func hideTableView(isHidden: Bool) {
        tableView.isHidden = isHidden
    }

    func startLoadingAnimation() {
        bigAnimationView.isHidden = false
        bigAnimationView.play()
    }

    func stopLoadingAnimation() {
        bigAnimationView.isHidden = true
        bigAnimationView.stop()
    }

    func showCameraButton() {
        let cameraBarButtonItem =  UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(tappedCameraButton))
        cameraBarButtonItem.tintColor = .black
        cameraBarButtonItem.image = UIImage(systemName: "camera")
        navigationItem.setRightBarButton(cameraBarButtonItem, animated: true)
    }
    
    // MARK: - @IBActions
    @IBAction private func tappedMenuButton() {
        delegate?.tappedMenuButton()
    }

    @IBAction private func tappedCameraButton() { }
}

// MARK: - LanguageSubscriber
extension PHLibraryViewController: LanguageSubscriber {
    func updateLanguage() {
        self.setLocalizedStrings()
    }
}

// MARK: - UITableViewDelegate
extension PHLibraryViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource
extension PHLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var res = 0
        switch section {
        case 0: res = viewModel.month?.days.count ?? 0
        case 1: res = 0
        case 2: res = 0
        default: break
        }
        return res
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoTVCell = tableView.dequeueReusableCell(withIdentifier: InfoTVCell.identifier) as? InfoTVCell else { return UITableViewCell() }

        if let day = viewModel.month?.days[indexPath.row] {
            infoTVCell.configure(by: day)
            infoTVCell.reloadCollectionView()
        }

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

        if let strMonth = viewModel.month {
            titleLabel.text = viewModel.monthFormatter.string(from: strMonth.month )
        } else {
            titleLabel.text = "Section \(section)"
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collectionViewCellHeight: CGFloat = (self.view.frame.size.width - 20)/3
        return collectionViewCellHeight + 30 + 10
    }
}
