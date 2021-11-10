//
//  PHLibraryViewController.swift
//  BanchExample
//
//  Created by User on 16.09.21.
//

import Photos
import SnapKit
import UIKit

// MARK: Day
class Day {
    let day: Date
    var images: [UIImage?]

    init(day: Date, images: [UIImage?]) {
        self.day = day
        self.images = images
    }
}

// MARK: Month
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

    // MARK: - Private Properties
    private weak var delegate: HomeViewControllerDelegate?
    private weak var container: ContainerViewController?

    private var month: Month?

    private let dayFormatter = DateFormatter(format: "dd.MM.yyyy")
    private let monthFormatter = DateFormatter(format: "MM.yyyy")

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = navigationController?.parent as? HomeViewControllerDelegate
        container = navigationController?.parent as? ContainerViewController

        setLocalizedStrings()
        configureUIElements()

        LanguageObserver.subscribe(self)

        let animationDuration = container?.animationDuration ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.checkAuthorization()
        }
    }

    // MARK: - UISetup
    private func configureUIElements() {
        view.backgroundColor = .lightGray
        configureNavigationBar()
        configureBackgroundMessageLabel()
        configureTableView()
    }

    private func configureNavigationBar() {
        let menuBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(tappedMenuButton))
        menuBarButtonItem.tintColor = .black
        menuBarButtonItem.image = UIImage(systemName: "line.horizontal.3")
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: true)

        let cameraBarButtonItem =  UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(tappedCameraButton))
        cameraBarButtonItem.tintColor = .black
        cameraBarButtonItem.image = UIImage(systemName: "camera")
        navigationItem.setRightBarButton(cameraBarButtonItem, animated: true)
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

    private func checkAuthorization() {
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            makeAuthorizationRequest()
        case .granted:
            makePhotosArray()
        case .unauthorized:
            setNoPermissionBackgroundLabel()
            container?.showOpenSettingsAlert()
        }
    }
    
    // MARK: - Logic
    private func makeAuthorizationRequest() {
        PHLibraryAuthorizationManager.requestPhotoLibraryAuthorization { status in
            switch status {
            case .granted:
                DispatchQueue.main.async { [weak self] in
                    self?.makePhotosArray()
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

      //  fetchOptions.fetchLimit = 30

        let startDate = NSDate(dateString: "01.10.2021", format:  "dd.MM.yyyy")
        let endDate = NSDate(dateString: "01.11.2021", format:  "dd.MM.yyyy")

        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, endDate)

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if fetchResult.count > 0 {
            tableView.isHidden = false
            fetchPhotoAtIndex(0, fetchResult)
        } else {
            tableView.isHidden = true
            backgroundMessageLabel.isHidden = false
            backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPhotoMessage.localized()
        }

        self.reloadTableView()
    }

    private func fetchPhotoAtIndex(_ index: Int, _ fetchResult: PHFetchResult<PHAsset>) {

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
                self.fetchPhotoAtIndex(index + 1, fetchResult)
            } else {
                self.reloadTableView()
            }
        })
    }

    private func setNoPermissionBackgroundLabel() {
        backgroundMessageLabel.isHidden = false
        backgroundMessageLabel.text = LocalizeKeys.PHLibrary.photoLibraryNoPermission.localized()
    }

    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
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
