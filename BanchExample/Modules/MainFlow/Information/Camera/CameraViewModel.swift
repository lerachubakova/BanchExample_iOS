//
//  CameraViewModel.swift
//  BanchExample
//
//  Created by User on 11.11.21.
//

import AVFoundation
import Photos
import Foundation

class CameraViewModel: NSObject {

    private var image: UIImage? {
        willSet {
            controller?.setImage(image: newValue)
        }
    }

    private weak var controller: CameraViewController?

    private let captureSession = AVCaptureSession()
    private var captureDeviceInput: AVCaptureDeviceInput!
    private let captureOutput = AVCapturePhotoOutput()

    init(vc: CameraViewController) {
        super.init()
        controller = vc
        if setupSession() {
            controller?.setSession(captureSession: captureSession)
            startSession()
        }
    }

    func takePicture() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        captureOutput.capturePhoto(with: settings, delegate: self)
    }

    func savePicture() {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            guard let image = image else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageError), nil)
        }
    }

    // MARK: - Setup Camera
    private func setupSession() -> Bool {
        captureSession.sessionPreset = AVCaptureSession.Preset.high

        guard let camera = AVCaptureDevice.default(for: AVMediaType.video) else {
            return false
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            guard captureSession.canAddInput(input) else { return false }
            captureSession.addInput(input)
            captureDeviceInput = input

            guard captureSession.canAddOutput(captureOutput) else { return false }
            captureSession.addOutput(captureOutput)

        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        return true
    }

    private func startSession() {
        guard !captureSession.isRunning else { return }
        self.captureSession.startRunning()
    }

    private func stopSession() {
        guard captureSession.isRunning else { return }
        self.captureSession.stopRunning()
    }

    @objc private func saveImageError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard let error = error else {
            return
        }
        print("### PhotoViewController: saveError: \(error)")
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }

        guard let image = UIImage(data: data) else { return }
        self.image = image
    }
}
