//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import Photos
import UIKit

struct Day {
    let date: Int
    let images: [UIImage?]
}

final class InformationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backgroundMessageLabel: UILabel!

    private weak var delegate: HomeViewControllerDelegate?
    private weak var container: ContainerViewController?

    private let refreshControl = UIRefreshControl()
    private var photos: [UIImage?] = []
    private var photosCount = 10

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
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.register(InfoTVCell.nib(), forCellReuseIdentifier: InfoTVCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.isHidden = false

        makePhotosArray()

        if photos.count == 0 {
            tableView.isHidden = true
            backgroundMessageLabel.isHidden = false
            backgroundMessageLabel.text = LocalizeKeys.Information.photoLibraryNoPhotoMessage.localized()
        }
    }

    private func setLocalizedStrings() {
        title = LocalizeKeys.info.localized()
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            break
        case .granted:
            backgroundMessageLabel.text = LocalizeKeys.Information.photoLibraryNoPhotoMessage.localized()
        case .unauthorized:
            backgroundMessageLabel.text = LocalizeKeys.Information.photoLibraryNoPermission.localized()
        }
    }

    private func checkAuthorization() {
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            makeAuthorizationRequest()
        case .granted:
            configureTableView()
        case .unauthorized:
            setNoPermissionBackgroundLabel()
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
                    self?.setNoPermissionBackgroundLabel()
                    self?.container?.showOpenSettingsAlert()
                }
            case .notRequested:
                break
            }
        }
    }

    private func makePhotosArray() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]

        fetchOptions.fetchLimit = photosCount

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if fetchResult.count > 0 {
            fetchPhotoAtIndex(0, photosCount, fetchResult)
        }

        self.reloadTableView()
    }

    private func fetchPhotoAtIndex(_ index: Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        let object = fetchResult.object(at: index) as PHAsset

        let mode = PHImageContentMode.aspectFill

        PHImageManager.default().requestImage(for: object, targetSize: view.frame.size, contentMode: mode, options: requestOptions, resultHandler: { [unowned self] (image, _) in

            self.photos.append(image)

//            if let image = image {
//                print("\t LOG image.count += 1 \(image)")
//            } else {
//                print("\t LOG image is nil \(String(describing: some))")
//            }

            if index + 1 < fetchResult.count && self.photos.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            }
        })
    }

    private func setNoPermissionBackgroundLabel() {
        backgroundMessageLabel.isHidden = false
        backgroundMessageLabel.text = LocalizeKeys.Information.photoLibraryNoPermission.localized()
    }

    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc private func refresh() {
        DispatchQueue.main.async { [weak self] in

            self?.refreshControl.endRefreshing()
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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let infoTVCell = tableView.dequeueReusableCell(withIdentifier: InfoTVCell.identifier) as? InfoTVCell else { return UITableViewCell() }
        infoTVCell.configure(images: photos)
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
