//
//  Camera.swift
//  LifeupSnap
//
//  Created by lifeup on 29/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

internal class Camera: NSObject {
    private var photoCaptureCompletionBlock: ((_ image: UIImage?) -> Void)?
    private var photoCaptureFailureBlock: ((_ error: Error?) -> Void)?
    
    private var movieCaptureCompletionBlock: ((_ url: URL?) -> Void)?
    private var movieCaptureFailureBlock: ((_ error: Error?) -> Void)?
    
    internal var captureSession: AVCaptureSession?
    internal var cameraPosition: CameraPosition?
    
    internal var frontCamera: AVCaptureDevice?
    internal var frontCameraInput: AVCaptureDeviceInput?
    
    internal var rearCamera: AVCaptureDevice?
    internal var rearCameraInput: AVCaptureDeviceInput?
    
    internal var micDevice: AVCaptureDevice?
    internal var micInput: AVCaptureDeviceInput?

    internal var previewLayer: AVCaptureVideoPreviewLayer?
    internal var currentView: UIView?
    
    internal var photoOutput: AVCapturePhotoOutput?
    internal var movieOutput: AVCaptureMovieFileOutput?
    
    internal static var flashMode: AVCaptureDevice.FlashMode = .off
    internal var maxDuration: Double = 30
    internal var initialed: Bool = false
    internal var isRecording: Bool = false
    internal var selfStop: Bool = false
    
    private var isSquare: Bool = false
    private var adjustingExposureContext: String = ""
    
    //MARK: Gesture
    private var focusTapGesture: UITapGestureRecognizer!
    private var exposureTapGesture: UITapGestureRecognizer!
    
    private var focusImageView: UIImageView!
    private var exposureImageView: UIImageView!
    
    override init() {
        super.init()
        setup()
    }

    fileprivate func setup() {
        focusTapGesture = UITapGestureRecognizer(target: self, action: #selector(focusTap(_:)))
        focusTapGesture.numberOfTapsRequired = 1
        
        exposureTapGesture = UITapGestureRecognizer(target: self, action: #selector(exposureTap(_:)))
        exposureTapGesture.numberOfTapsRequired = 2
        
        focusImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        focusImageView.image = #imageLiteral(resourceName: "ic_camera_focus.png")
        focusImageView.isHidden = true
        
        exposureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        exposureImageView.image = #imageLiteral(resourceName: "ic_camera_exposure.png")
        exposureImageView.isHidden = true
    }
    
    internal func prepare(completion: @escaping() -> Void, failure: @escaping(_ error: Error?) -> Void) {
        if initialed {
            completion()
            return
        }
        
        taskMain { [unowned self] in
            do {
                self.createCaptureSession()
                try self.configurationCaptureDevice()
                try self.configurationDeviceInputs()
                try self.configurationPhotoOutput()
                try self.configurationMicInput()
                try self.configurationMovieOutput()
            }
            catch {
                taskMain {
                    failure(error)
                }
                
                return
            }
            
            self.initialed = true
            
            completion()
        }
    }
}

//MARK: Configurations
extension Camera {
    fileprivate func createCaptureSession() {
        captureSession = AVCaptureSession()
    }
    
    fileprivate func configurationCaptureDevice() throws {
        var session: AVCaptureDevice.DiscoverySession
        
        if #available(iOS 10.2, *) {
            session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInMicrophone], mediaType: .video, position: .unspecified)
        } else {
            session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera, .builtInWideAngleCamera, .builtInMicrophone], mediaType: .video, position: .unspecified)
        }
        
        let cameras = session.devices
        
        guard !cameras.isEmpty else {
            throw CameraError.noCamerasAvailable
        }
        
        for camera in cameras {
            switch camera.position {
            case .front:
                frontCamera = camera
                break
            case .back:
                rearCamera = camera
                
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
                
                break
            default:
                break
            }
        }
    }
    
    fileprivate func configurationDeviceInputs() throws {
        guard let captureSession = captureSession else {
            throw CameraError.captureSessionIsMissing
        }
        
        if let rearCamera = rearCamera {
            rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            if captureSession.canAddInput(rearCameraInput!) {
                captureSession.addInput(rearCameraInput!)
            }
            
            cameraPosition = .rear
        }
        else if let frontCamera = frontCamera {
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
            }
            
            cameraPosition = .front
        }
        else {
            throw CameraError.noCamerasAvailable
        }
    }
    
    fileprivate func configurationPhotoOutput() throws {
        guard let captureSession = captureSession else {
            throw CameraError.captureSessionIsMissing
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput!) {
            captureSession.addOutput(photoOutput!)
        }
    }
    
    fileprivate func configurationMicInput() throws {
        guard let captureSession = captureSession else {
            throw CameraError.captureSessionIsMissing
        }

        guard let micDevice = AVCaptureDevice.default(for: .audio) else {
            throw CameraError.captureSessionIsMissing
        }

        do {
            micInput = try AVCaptureDeviceInput(device: micDevice)
        }
        catch {
            throw CameraError.invalidOperation
        }

        if captureSession.canAddInput(micInput!) {
            captureSession.addInput(micInput!)
        }
    }
    
    fileprivate func configurationMovieOutput() throws {
        guard let captureSession = captureSession else {
            throw CameraError.captureSessionIsMissing
        }
        
        let seconds = maxDuration
        let preferredTimeScale = 1
        let maxRecordDuration = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(preferredTimeScale))
        
        movieOutput = AVCaptureMovieFileOutput()
        movieOutput?.maxRecordedDuration = maxRecordDuration
        
        if captureSession.canAddOutput(movieOutput!) {
            captureSession.addOutput(movieOutput!)
        }
        
        taskMain { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    internal func renewMovieOutput() {
        taskBackground(label: "renewMovieOutputBackground", { [unowned self] in
            guard let captureSession = self.captureSession else {
                return
            }
            
            if captureSession.outputs.contains(self.movieOutput!) {
                captureSession.removeOutput(self.movieOutput!)
            }
            
            try? self.configurationMovieOutput()
        })
    }
}

//MARK: Manage
extension Camera {
    internal func displayPreview() throws {
        guard let captureSession = captureSession, !captureSession.isRunning else {
            throw CameraError.captureSessionIsMissing
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    internal func addPreviewLayer(view: UIView) {
        guard let connection = previewLayer?.connection else {
            return
        }
        
        connection.videoOrientation = currentVideoOrientation()
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)
        
        if !view.gestureRecognizers!.contains(focusTapGesture) || !view.gestureRecognizers!.contains(exposureTapGesture) {
            view.addGestureRecognizer(focusTapGesture)
            view.addGestureRecognizer(exposureTapGesture)
        }
        
        view.addSubview(focusImageView)
        view.addSubview(exposureImageView)
        
        currentView = view
    }
    
    internal func resetPreviewLayer(view: UIView) {
        guard let previewLayer = previewLayer else {
            return
        }
        
        previewLayer.removeFromSuperlayer()
        
        try? displayPreview()
        addPreviewLayer(view: view)
    }
    
    internal func begin() {
        taskQOS(qos: .userInteractive, { [weak self] in
            self?.captureSession?.startRunning()
        })
    }
    
    internal func switchCamera() throws {
        guard let cameraPosition = cameraPosition, let captureSession = captureSession, captureSession.isRunning else {
            throw CameraError.captureSessionIsMissing
        }
        
        captureSession.beginConfiguration()
        
        switch cameraPosition {
        case .front:
            try switchRearCamera(captureSession: captureSession)
            break
        case .rear:
            try switchFrontCamera(captureSession: captureSession)
            break
        }
        
        captureSession.commitConfiguration()
    }
    
    fileprivate func switchFrontCamera(captureSession: AVCaptureSession) throws {
        guard let rearCameraInput = rearCameraInput, captureSession.inputs.contains(rearCameraInput), let frontCamera = frontCamera else {
            throw CameraError.invalidOperation
        }
        
        frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        
        captureSession.removeInput(rearCameraInput)
        
        if captureSession.canAddInput(frontCameraInput!) {
            captureSession.addInput(frontCameraInput!)
            
            cameraPosition = .front
        }
        else {
            throw CameraError.invalidOperation
        }
    }
    
    fileprivate func switchRearCamera(captureSession: AVCaptureSession) throws {
        guard let frontCameraInput = frontCameraInput, captureSession.inputs.contains(frontCameraInput), let rearCamera = rearCamera else {
            throw CameraError.invalidOperation
        }
        
        rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        
        captureSession.removeInput(frontCameraInput)
        
        if captureSession.canAddInput(rearCameraInput!) {
            captureSession.addInput(rearCameraInput!)
            
            cameraPosition = .rear
        }
        else {
            throw CameraError.invalidOperation
        }
    }
}

//MARK: Capture
extension Camera {
    internal func captureImage(completion: @escaping(_ image: UIImage?) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            failure(CameraError.unknown)
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = Camera.flashMode
        
        guard let connection = photoOutput?.connection(with: .video) else {
            failure(CameraError.unknown)
            return
        }
        
        isSquare = false
        
        connection.videoOrientation = currentVideoOrientation()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
        photoCaptureFailureBlock = failure
    }
    
    internal func captureSquareImage(completion: @escaping(_ image: UIImage?) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            failure(CameraError.unknown)
            return
        }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = Camera.flashMode
        
        guard let connection = photoOutput?.connection(with: .video) else {
            failure(CameraError.unknown)
            return
        }
        
        isSquare = true
        
        connection.videoOrientation = currentVideoOrientation()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
        photoCaptureFailureBlock = failure
    }
}

//MARK: Record
extension Camera {
    internal func recordVideo(completion: @escaping(_ url: URL?) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        guard let connection = movieOutput?.connection(with: .video) else {
            failure(CameraError.unknown)
            return
        }
        
        connection.videoOrientation = currentVideoOrientation()
        
        let fileName = "\(LFSConstants.LFSVideoName.Snap.snapVideo)\(Date())"
        let path = LFSVideoModel.shared.outputPathURL(fileName: fileName, fileType: LFSConstants.LFSFileType.Snap.mp4)!
        
        movieOutput?.startRecording(to: path, recordingDelegate: self)
        
        movieCaptureCompletionBlock = completion
        movieCaptureFailureBlock = failure
        
        isRecording = true
        selfStop = false
    }
    
    internal func stopRecord() {
        movieOutput?.stopRecording()
        isRecording = false
    }
}

//MARK: Boomerang
extension Camera {
    func reverse(originalURL: URL, completion: @escaping(_ url: URL?) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        LFSVideoModel.shared.reverse(originalURL: originalURL, completion: completion, failure: failure)
    }
}

//MARK: Orientation
extension Camera {
    fileprivate func currentVideoOrientation() -> AVCaptureVideoOrientation {
        return LFSVideoModel.shared.orientation()
    }
}

//MARK: AVCapturePhotoCaptureDelegate
extension Camera: AVCapturePhotoCaptureDelegate {
    @available(iOS 10, *)
    internal func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error {
            photoCaptureFailureBlock?(error)
            return
        }

        if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
            let image = LFSPhotoModel.shared.generatePhoto(data: data, isSquare: isSquare)
            photoCaptureCompletionBlock?(image)
        }
        else {
            photoCaptureFailureBlock?(CameraError.unknown)
        }
    }
    
    @available(iOS 11.0, *)
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            let image = LFSPhotoModel.shared.generatePhoto(data: data, isSquare: isSquare)
            photoCaptureCompletionBlock?(image)
        }
        else {
            photoCaptureFailureBlock?(CameraError.unknown)
        }
    }
}

//MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension Camera: AVCaptureFileOutputRecordingDelegate {
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            if !outputFileURL.isFileURL {
                movieCaptureFailureBlock?(error)
                return
            }
        }
        
        LFSVideoModel.shared.saveVideoByURL(url: outputFileURL, completion: { [weak self] (video) -> Void in
            if video.duration.seconds >= 10.0 || video.duration.seconds >= 30.0 {
                self?.selfStop = true
                self?.isRecording = false
            }
            
            self?.movieCaptureCompletionBlock?(video.url)
        }, failure: { [weak self] (error) -> Void in
            self?.movieCaptureFailureBlock?(error)
        })
    }
}

//MARK: Handle Gesture
extension Camera {
    @objc fileprivate func focusTap(_ gesture: UITapGestureRecognizer) {
        focusFrontCamera(gesture: gesture)
        focusRearCamera(gesture: gesture)
    }
    
    @objc fileprivate func exposureTap(_ gesture: UITapGestureRecognizer) {
        exposureFrontCamera(gesture: gesture)
        exposureRearCamera(gesture: gesture)
    }
    
    //MARK: Focus
    fileprivate func focusFrontCamera(gesture: UITapGestureRecognizer) {
        if let frontCameraInput = frontCameraInput, let captureSession = captureSession, captureSession.inputs.contains(frontCameraInput) {
            if frontCameraInput.device.isFocusPointOfInterestSupported {
                if let previewLayer = previewLayer {
                    let point = gesture.location(in: currentView)
                    let pointOfInterest = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
                    
                    showMarker(point: point, marker: focusImageView)
                    focusAtPoint(point: pointOfInterest, input: frontCameraInput)
                }
            }
        }
    }
    
    fileprivate func focusRearCamera(gesture: UITapGestureRecognizer) {
        if let rearCameraInput = rearCameraInput, let captureSession = captureSession, captureSession.inputs.contains(rearCameraInput) {
            if rearCameraInput.device.isFocusPointOfInterestSupported {
                if let previewLayer = previewLayer {
                    let point = gesture.location(in: currentView)
                    let pointOfInterest = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
                    
                    showMarker(point: point, marker: focusImageView)
                    focusAtPoint(point: pointOfInterest, input: rearCameraInput)
                }
            }
        }
    }
    
    fileprivate func focusAtPoint(point: CGPoint, input: AVCaptureDeviceInput) {
        let device = input.device
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = point
                device.focusMode = .autoFocus
                device.unlockForConfiguration()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Exposure
    fileprivate func exposureFrontCamera(gesture: UITapGestureRecognizer) {
        if let frontCameraInput = frontCameraInput, let captureSession = captureSession, captureSession.inputs.contains(frontCameraInput) {
            if frontCameraInput.device.isFocusPointOfInterestSupported {
                if let previewLayer = previewLayer {
                    let point = gesture.location(in: currentView)
                    let pointOfInterest = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
                    
                    showMarker(point: point, marker: exposureImageView)
                    exposeAtPoint(point: pointOfInterest, input: frontCameraInput)
                }
            }
        }
    }
    
    fileprivate func exposureRearCamera(gesture: UITapGestureRecognizer) {
        if let rearCameraInput = rearCameraInput, let captureSession = captureSession, captureSession.inputs.contains(rearCameraInput) {
            if rearCameraInput.device.isFocusPointOfInterestSupported {
                if let previewLayer = previewLayer {
                    let point = gesture.location(in: currentView)
                    let pointOfInterest = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
                    
                    showMarker(point: point, marker: exposureImageView)
                    exposeAtPoint(point: pointOfInterest, input: rearCameraInput)
                }
            }
        }
    }
    
    fileprivate func exposeAtPoint(point: CGPoint, input: AVCaptureDeviceInput) {
        let device = input.device
        
        if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(.continuousAutoExposure) {
            DispatchQueue.main.async { [unowned self] in
                do {
                    try device.lockForConfiguration()
                    device.exposurePointOfInterest = point
                    device.exposureMode = .continuousAutoExposure
                    
                    if device.isExposureModeSupported(.locked) {
                        device.addObserver(self, forKeyPath: "adjustingExposure", options: NSKeyValueObservingOptions.new, context: &self.adjustingExposureContext)
                        device.unlockForConfiguration()
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &adjustingExposureContext {
            let device = object as! AVCaptureDevice
            
            if !device.isAdjustingExposure && device.isExposureModeSupported(.locked) {
                device.removeObserver(self, forKeyPath: "adjustingExposure", context: &adjustingExposureContext)
                
                DispatchQueue.main.async {
                    do {
                        try device.lockForConfiguration()
                        device.exposureMode = .locked
                        device.unlockForConfiguration()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            else {
                //super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
    
    fileprivate func showMarker(point: CGPoint, marker: UIImageView) {
        marker.center = point
        marker.isHidden = false
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            marker.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
        }, completion: { (finished) -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                marker.isHidden = true
                marker.transform = .identity
            })
        })
    }
}
