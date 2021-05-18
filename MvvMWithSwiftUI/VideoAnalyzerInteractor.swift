import AVFoundation
import Vision
import UIKit
import CoreVideo

final class VideoAnalyzerInteractor: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
//    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private var captureDevice: AVCaptureDevice?
    @Published var showPhoto: Bool = false
    @Published var photoImage: UIImage?
    private let videoDataOutput = AVCaptureVideoDataOutput()
//    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    let videoDataOutputQueue = DispatchQueue(label: "sampleBufferQueue")
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var bufferSize: CGSize = .zero
    var rootLayer = CALayer()
    private var previewView: UIView!
    
    var lastTimestamp = CMTime()
    public var fps = 15
    
//    let yoloModel = YOLOv3()
    let context = CIContext()
    
    // VISION
    private var requests = [VNRequest]()
    private var detectionOverlay: CALayer! = nil
//    var rootLayer: CALayer! = nil

    // - Tag: CreateCaptureSession
     func setupAVCaptureSession() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            return
        }
        captureDevice = device
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice!) else {
            #if DEBUG
                print("ERROR: Could not init capture device")
            #endif
            return
        }
        
        // start captureSession configuration
        captureSession.beginConfiguration()
//        captureSession.sessionPreset = .medium
        captureSession.sessionPreset = .vga640x480
        
        guard captureSession.canAddInput(captureDeviceInput) else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(captureDeviceInput)
        
        let settings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCMPixelFormat_32BGRA)
        ]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.videoSettings = settings
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        // kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        
        // add videoDataOutput to the session
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
//        let curDeviceOrientation = UIDevice.current.orientation
//
//        switch curDeviceOrientation {
//        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
//            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .portraitUpsideDown
//        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
//            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .landscapeLeft
//        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
//            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .landscapeRight
//        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
//            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
//        default:
//            videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
//        }
        
        videoDataOutput.connection(with: AVMediaType.video)?.videoOrientation = .portraitUpsideDown
        
        // set connection
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.isEnabled = true
        
        // set buffer size
        do {
          try captureDevice!.lockForConfiguration()
          let dimensions = CMVideoFormatDescriptionGetDimensions((captureDevice?.activeFormat.formatDescription)!)
          bufferSize.width = CGFloat(dimensions.width)
          bufferSize.height = CGFloat(dimensions.height)
          captureDevice!.unlockForConfiguration()
        } catch {
          print(error)
        }
        
        // commit captureSession Configuration
        captureSession.commitConfiguration()

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = previewLayer.bounds
        
        
     }

    func startSession() {
        sessionQueue.async {
            if self.captureSession.isRunning { return }
            self.captureSession.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async {
            if !self.captureSession.isRunning { return }
            self.captureSession.stopRunning()
        }
    }
    
    func takePhoto() {
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
//        previewLayer.removeFromSuperlayer()
//        previewLayer = nil
    }
}

extension VideoAnalyzerInteractor: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)

        // Throttle capture rate based on assigned fps
        let elapsedTime = timestamp - lastTimestamp
        if elapsedTime >= CMTimeMake(value: 1, timescale: Int32(fps)) {
            // update timestamp
            lastTimestamp = timestamp
            
            // get pixelBuffer from generated samplebuffer
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            //testing
            guard let scaledPixelBuffer = CIImage(cvImageBuffer: pixelBuffer).resize(size: CGSize(width: 416, height: 416)).toPixelBuffer(context: context) else {
                return
            }

            let curDeviceOrientation = UIDevice.current.orientation
            let exifOrientation: CGImagePropertyOrientation

            switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .up
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .left
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .right
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .down
            default:
                exifOrientation = .down
            }

            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: scaledPixelBuffer, orientation: exifOrientation, options: [:])
            
            do {
//                requests.forEach({ request in
//                    (request as! VNCoreMLRequest).imageCropAndScaleOption = .centerCrop
//                })
                try imageRequestHandler.perform(requests)
            } catch {
                print(error)
            }
            
            //testing
//            do {
//                let input_ = YOLOv3Input(image: scaledPixelBuffer)
//                let outFeatures = try yoloModel.prediction(input: input_, options: MLPredictionOptions())
//                let names = YOLOv3Output(features: outFeatures).featureNames
//                names.forEach({ name in
//                    print(name.propertyList())
//                    print(name.description)
//                })
//            } catch {
//                print(error)
//            }
        }
        
        
    }
}

// MARK: - Private
extension VideoAnalyzerInteractor {
    @discardableResult
    func setupVision() -> NSError? {
        #if DEBUG
            print(#function)
        #endif
        
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
//            let visionModel = try VNCoreMLModel(for: model.model)
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                
                DispatchQueue.main.async {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                }
            })
            
//            objectRecognition.usesCPUOnly = false
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func setupAVCapture() {
        #if DEBUG
            print(#function)
        #endif
        
        setupLayers()
        updateLayerGeometry()
        setupVision()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: previewLayer.bounds.midX, y: previewLayer.bounds.midY)
        previewLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry() {
            let bounds = previewLayer.bounds
            var scale: CGFloat
            
            let xScale: CGFloat = bounds.size.width / bufferSize.height
            let yScale: CGFloat = bounds.size.height / bufferSize.width
            
            scale = fmax(xScale, yScale)
            if scale.isInfinite {
                scale = 1.0
            }
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            // rotate the layer into screen orientation and scale and mirror
            detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
            // center the layer
            detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
            
            CATransaction.commit()
        }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
            let textLayer = CATextLayer()
            textLayer.name = "Object Label"
            let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
            let largeFont = UIFont(name: "Helvetica", size: 24.0)!
            formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
            textLayer.string = formattedString
            textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
            textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            textLayer.shadowOpacity = 0.7
            textLayer.shadowOffset = CGSize(width: 2, height: 2)
            textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
            textLayer.contentsScale = 2.0 // retina rendering
            // rotate the layer into screen orientation and scale and mirror
            textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
            return textLayer
        }
        
        func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
            let shapeLayer = CALayer()
            shapeLayer.bounds = bounds
            shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            shapeLayer.name = "Found Object"
            shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
            shapeLayer.cornerRadius = 7
            return shapeLayer
        }
    
}
