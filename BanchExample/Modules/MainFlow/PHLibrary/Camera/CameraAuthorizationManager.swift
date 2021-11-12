//
//  CameraAuthorizationManager.swift
//  BanchExample
//
//  Created by User on 12.11.21.
//

import AVFoundation
import Foundation

enum CameraAuthorizationStatus {
    case notRequested
    case granted
    case unauthorized
}

typealias RequestCameraAuthCompletionHandler = (CameraAuthorizationStatus) -> Void

class CameraAuthorizationManager {

    static func requestAuthorization(completionHandler: @escaping RequestCameraAuthCompletionHandler) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            DispatchQueue.main.async {
                guard granted else {
                    completionHandler(.unauthorized)
                    return
                }
                completionHandler(.granted)
            }
        })
    }

    static func getStatus() -> CameraAuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized: return .granted
        case .notDetermined: return .notRequested
        default: return .unauthorized
        }
    }

}
