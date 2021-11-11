//
//  VideoPreviewView.swift
//  BanchExample
//
//  Created by User on 11.11.21.
//

import AVFoundation
import Foundation

class VideoPreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as? AVCaptureVideoPreviewLayer ?? AVCaptureVideoPreviewLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer.frame = UIScreen.main.bounds
        videoPreviewLayer.videoGravity = .resizeAspect
    }
}
