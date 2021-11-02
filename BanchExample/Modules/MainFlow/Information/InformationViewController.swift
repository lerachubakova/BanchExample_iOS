//
//  InformationViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import Photos
import UIKit

class Day {
    let day: Date
    var images: [UIImage?]

    init(day: Date, images: [UIImage?]) {
        self.day = day
        self.images = images
    }
}

class Month {
    let month: Date
    var days: [Day]

    var debugDescription: String {
        var res = ""
        res += " month: \(month)\n"
        res += " daysCount: \(days.count)\n"
        _ = days.map {
            res += " day \(DateFormatter(format: "dd.MM").string(from: $0.day)): images: \($0.images.count)\n"
        }

        return res
    }

    init(month: Date, days: [Day]) {
        self.month = month
        self.days = days
    }
}

final class InformationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backgroundMessageLabel: UILabel!

    private weak var delegate: HomeViewControllerDelegate?
    private weak var container: ContainerViewController?

    private let refreshControl = UIRefreshControl()

    private var photosCount = 50

    private var month: Month?

    private let dayFormatter = DateFormatter(format: "dd.MM.yyyy")
    private let monthFormatter = DateFormatter(format: "MM.yyyy")

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
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

      //  fetchOptions.fetchLimit = photosCount

        let startDate = NSDate(dateString: "01.10.2021", format:  "dd.MM.yyyy")
        let endDate = NSDate(dateString: "01.11.2021", format:  "dd.MM.yyyy")

        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, endDate)

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if fetchResult.count > 0 {
            fetchPhotoAtIndex(0, photosCount, fetchResult)
        } else {
            tableView.isHidden = true
            backgroundMessageLabel.isHidden = false
            backgroundMessageLabel.text = LocalizeKeys.Information.photoLibraryNoPhotoMessage.localized()
        }

        self.reloadTableView()
    }

    private func fetchPhotoAtIndex(_ index: Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        let object = fetchResult.object(at: index) as PHAsset
        let mode = PHImageContentMode.aspectFill
        let screenSize = view.frame.size

        PHImageManager.default().requestImage(for: object, targetSize: screenSize, contentMode: mode, options: requestOptions, resultHandler: { [unowned self] (image, _) in

            guard let objectDate = object.creationDate else { return }

            if month == nil {
                month = Month(month: objectDate, days: [])
            }

            guard let strongMonth = month else { return }

            if strongMonth.days.isEmpty {
                month?.days.append(Day(day: objectDate, images: []))
            } else if let lastDayDate = strongMonth.days.last?.day, dayFormatter.string(from: objectDate) != dayFormatter.string(from: lastDayDate) {
                month?.days.append(Day(day: objectDate, images: []))
            }

            if let lastDayDate = strongMonth.days.last?.day, dayFormatter.string(from: objectDate) == dayFormatter.string(from: lastDayDate) {
                month?.days.last?.images.append(image)
            }

            if index + 1 < fetchResult.count {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.refreshControl.endRefreshing()
                    self?.reloadTableView()
                }
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
        month = nil
        makePhotosArray()
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
        case 0: res = month?.days.count ?? 0
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

        if let day = month?.days[indexPath.row] {
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

        if let strMonth = month {
            titleLabel.text = monthFormatter.string(from: strMonth.month )
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
