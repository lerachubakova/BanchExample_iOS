//
//  CameraViewController.swift
//  BanchExample
//
//  Created by User on 10.11.21.
//

import AVFoundation
import Foundation
import SnapKit

class CameraViewController: UIViewController {

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var videoPreviewView: VideoPreviewView = {
        let view = VideoPreviewView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(.none, action: #selector(touchDownCameraButton), for: .touchDown)
        button.backgroundColor = .clear
        let image = UIImage(named: "icCameraCircle")
        button.setImage(image, for: .normal)
        return button
    }()

    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()

    private lazy var notificationView: NotificationView = {
        let notification = NotificationView()
        return notification
    }()

    private var heightCameraViewConstraint: Constraint?
    private let buttonHeight: CGFloat = UIScreen.main.bounds.width * 0.25

    private var viewModel: CameraViewModel!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = CameraViewModel(vc: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - UISetup
    private func configureUI() {
        view.backgroundColor = .lightGray
        configureNavigationBar()
        configurePhotoImageView()
        configureVideoPreviewView()
        configureButtonWithBackground()
        configureNotificationView()
        view.layoutIfNeeded()
    }

    private func configureNavigationBar() {
        let saveBarButtonItem = UIBarButtonItem(title: LocalizeKeys.PHLibrary.saveButton.localized(), style: .done, target: self, action: #selector(tappedSaveButton))
        navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
    }

    private func configurePhotoImageView() {
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    private func configureVideoPreviewView() {
        view.addSubview(videoPreviewView)

        videoPreviewView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottom).offset(-(buttonHeight + 16))
        }
    }

    private func configureButtonWithBackground() {
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.addSubview(cameraButton)

        buttonBackgroundView.snp.makeConstraints { [weak self] maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            self?.heightCameraViewConstraint = maker.top.equalTo(view.snp.bottom).offset(-(buttonHeight + 16)).constraint
        }

        cameraButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-16)
            maker.height.equalTo(buttonHeight-16)
            maker.width.equalTo(cameraButton.snp.height)
        }
    }

    func configureNotificationView() {
        view.addSubview(notificationView)

        notificationView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        if let inset = navigationController?.navigationBar.frame.maxY {
            notificationView.snp.makeConstraints { maker in
                maker.bottom.equalTo(view.snp.top).offset(inset)
            }
        } else {
            notificationView.snp.makeConstraints { maker in
                maker.bottom.equalTo(view.snp.top)
            }
        }
    }

    // MARK: - Logic
    private func hideCameraButtonView() {

        heightCameraViewConstraint?.update(offset: 0)

        let hideAnimationDuration = TimeInterval(UINavigationController.hideShowBarDuration)

        UIView.animate(withDuration: hideAnimationDuration) { [unowned self] in
            buttonBackgroundView.superview?.layoutIfNeeded()
        }
    }

    func setSession(captureSession: AVCaptureSession) {
        videoPreviewView.videoPreviewLayer.session = captureSession
    }

    func setImage(image: UIImage?) {
        photoImageView.image = image
        navigationController?.setNavigationBarHidden(false, animated: true)
        hideCameraButtonView()
        videoPreviewView.isHidden = true
    }

    func showNotification(message: String) {
        notificationView.present(message: message)
        navigationItem.rightBarButtonItems?.first?.isEnabled = false
    }

    // MARK: - @IBActions

    @IBAction private func tappedSaveButton() {
        viewModel.savePicture()
    }

    @IBAction private func touchDownCameraButton() {
        viewModel.takePicture()
    }
    
}
