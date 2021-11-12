//
//  PHLibraryAuthorizationManager.swift
//  BanchExample
//
//  Created by User on 29.10.21.
//

import Foundation
import Photos

enum PhotoLibraryAuthorizationStatus {
    case notRequested
    case granted
    case unauthorized
}

typealias RequestPhotoLibraryAuthCompletionHandler = (PhotoLibraryAuthorizationStatus) -> Void

final class PHLibraryAuthorizationManager {

    static func requestAuthorization(completionHandler: @escaping RequestPhotoLibraryAuthCompletionHandler) {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    completionHandler(.unauthorized)
                    return
                }
                completionHandler(.granted)
            }
        }
    }

    static func getStatus() -> PhotoLibraryAuthorizationStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: return .granted
        case .notDetermined: return .notRequested
        default: return .unauthorized
        }
    }

}
