import Foundation
import AVKit
import Combine

final class VideoAnalyzerPresenter: ObservableObject {
    enum Inputs {
        case onAppear
        case tappedCameraButton
        case tappedCloseButton
        case onDisappear
    }

    init() {
        interactor.setupAVCaptureSession()
        interactor.setupAVCapture()
        
        bind()
    }

    deinit {
        cancellables.forEach { (cancellable) in
            cancellable.cancel()
        }
    }

    var previewLayer: CALayer {
        return interactor.previewLayer
    }

    @Published var photoImage: UIImage = UIImage()
    @Published var showSheet: Bool = false

    func apply(inputs: Inputs) {
        switch inputs {
            case .onAppear:
                interactor.startSession()
                break
            case .tappedCloseButton:
                showSheet = false
                break
            case .onDisappear:
                interactor.stopSession()
                
                interactor.setupAVCaptureSession()
                interactor.setupAVCapture()
//                interactor.teardownAVCapture()
                break
            case .tappedCameraButton:
                interactor.takePhoto()
                break
        }
    }

    // MARK: Privates
    private let interactor = VideoAnalyzerInteractor()
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
