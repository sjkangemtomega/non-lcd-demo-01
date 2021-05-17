//
//  PreviewView.swift
//  MvvMWithSwiftUI
//
//  Created by kangseoju on 2021/05/12.
//

import Foundation
import UIKit
import AVFoundation

class PreviewView: UIView, AVCaptureFileOutputRecordingDelegate {
    
    private var captureSession: AVCaptureSession?
    private var shakeCountdown: Timer?
    
    let videoFileOutput = AVCaptureMovieFileOutput()
    var recordingDelegate: AVCaptureFileOutputRecordingDelegate!
    
    var recorded = 0
    var secondsToReachGoal = 30
    
    var onRecord: ((Int,Int) -> ())?
    var onReset: (() ->())?
    var onComplete: (() -> ())?
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    init() {
        super.init(frame: .zero)
        
        // check access to camera
        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()
        
        if !allowedAccess {
            print("ERROR: Could not init camera")
        }
        
        // setup device and session
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device), session.canAddInput(videoDeviceInput) else {
            print("ERRPR: No camera deteced.")
            return
        }
        
        session.addInput(videoDeviceInput)
        session.commitConfiguration()
        captureSession = session
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        recordingDelegate = self
        startTimers()
        
        if self.superview != nil {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspect
            self.captureSession?.startRunning()
            self.startRecording()
        } else {
            captureSession?.stopRunning()
        }
    }
    
    func startTimers() {
        if shakeCountdown == nil {
            shakeCountdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
                self?.onTimerFires()
            }
        }
    }
    
    private func onTimerFires() {
        print("🟢 STARTING.. \(videoFileOutput.isRecording) ")
        secondsToReachGoal -= 1
        recorded += 1
        onRecord?(secondsToReachGoal, recorded)
        
        if(secondsToReachGoal == 0) {
            stopRecording()
            
            shakeCountdown?.invalidate()
            shakeCountdown = nil
            
            onComplete?()
            videoFileOutput.stopRecording()
        }
    }
    
    func startRecording() {
        captureSession?.addOutput(videoFileOutput)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("VIDEO")
        
        videoFileOutput.startRecording(to: filePath, recordingDelegate: recordingDelegate)
    }
    
    func stopRecording() {
        videoFileOutput.stopRecording()
        print("🔴 STOPPING.. \(videoFileOutput.isRecording)")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL.absoluteString)
    }
}
