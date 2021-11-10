//
//  PHLibraryViewModel.swift
//  BanchExample
//
//  Created by User on 10.11.21.
//

import Foundation
import Photos

// MARK: - Day
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

// MARK: -
final class PHLibraryViewModel {

    // MARK: Properties
    var month: Month?
    let monthFormatter = DateFormatter(format: "MM.yyyy")

    private weak var controller: PHLibraryViewController?

    private var screenSize = CGSize()
    private let dayFormatter = DateFormatter(format: "dd.MM.yyyy")
    private let queue = DispatchQueue.global(qos: .utility)

    // MARK: LifeCycle
    init(vc: PHLibraryViewController) {
        self.controller = vc
        self.screenSize = controller?.view.frame.size ?? CGSize()

        let animationDuration = controller?.container?.animationDuration ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.checkAuthorization()
        }
    }

    // MARK: Logic
    func checkAuthorization() {
        let status = PHLibraryAuthorizationManager.getPhotoLibraryAuthorizationStatus()
        switch status {
        case .notRequested:
            makeAuthorizationRequest()
        case .granted:
           doIfGranted()
        case .unauthorized:
            doIfNoPermissions()
        }
    }

    private func makeAuthorizationRequest() {
        PHLibraryAuthorizationManager.requestPhotoLibraryAuthorization { [weak self] status in
            switch status {
            case .granted:
                DispatchQueue.main.async { [weak self] in
                    self?.doIfGranted()
                }
            case .unauthorized:
                DispatchQueue.main.async { [weak self] in
                    self?.doIfNoPermissions()
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
            DispatchQueue.main.async { [weak self] in
                self?.controller?.startLoadingAnimation()
            }
            fetchPhotoAtIndex(0, fetchResult)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.doIfEmpty()
            }
        }

    }

    private func fetchPhotoAtIndex(_ index: Int, _ fetchResult: PHFetchResult<PHAsset>) {

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        let object = fetchResult.object(at: index) as PHAsset
        let mode = PHImageContentMode.aspectFill

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
                DispatchQueue.main.async { [weak self] in
                    self?.doAfterLoading()
                }
            }
        })
    }

    private func doIfGranted() {
        queue.async { [weak self] in
            self?.makePhotosArray()
        }
    }

    private func doIfNoPermissions() {
        controller?.setNoPermissionBackgroundLabel()
        controller?.container?.showOpenSettingsAlert()
    }

    private func doIfEmpty() {
        controller?.setNoPhotoMessageLabel()
    }

    private func doAfterLoading() {
        controller?.stopLoadingAnimation()
        controller?.hideTableView(isHidden: false)
        controller?.reloadTableView()
        controller?.showCameraButton()
    }
}
