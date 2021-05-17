//
//  SimpleVideoCapturePresenter.swift
//  SwiftUI-AVFundation
//
//  Created by satoutakeshi on 2020/06/13.
//  Copyright © 2020 satoutakeshi. All rights reserved.
//

import Foundation
import AVKit
import Combine

final class VideoCapturePresenter: ObservableObject {
    enum Inputs {
        case onAppear
        case tappedCameraButton
        case tappedCloseButton
        case onDisappear
    }

    init() {
        interactor.setupAVCaptureSession()
        bind()
    }

    deinit {
        cancellables.forEach { (cancellable) in
            cancellable.cancel()
        }
    }

    var previewLayer: CALayer {
        return interactor.previewLayer!
    }

    @Published var photoImage: UIImage = UIImage()
    @Published var showSheet: Bool = false

    func apply(inputs: Inputs) {
        switch inputs {
            case .onAppear:
                interactor.startSession()
            break
            case .tappedCameraButton:
                interactor.takePhoto()
            case .tappedCloseButton:
                showSheet = false
            case .onDisappear:
              interactor.stopSession()
        }
    }

    // MARK: Privates
    private let interactor = VideoCaptureInteractor()
    private var cancellables: [Cancellable] = []

    private func bind() {
        let photoImageObserver = interactor.$photoImage.sink { (image) in
            if let image = image {
                self.photoImage = image
            }
        }
        cancellables.append(photoImageObserver)

        let showPhotoObserver = interactor.$showPhoto.assign(to: \.showSheet, on: self)
        cancellables.append(showPhotoObserver)
    }
}
