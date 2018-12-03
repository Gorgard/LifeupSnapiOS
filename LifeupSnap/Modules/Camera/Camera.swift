//
//  Camera.swift
//  LifeupSnap
//
//  Created by lifeup on 29/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class Camera: NSObject {
    private var photoCaptureCompletionBlock: ((_ image: UIImage?) -> Void)?
    private var photoCaptureFailureBlock: ((_ error: Error?) -> Void)?
    
    internal var captureSession: AVCaptureSession?
    internal var cameraPosition: CameraPosition?
    
    internal var frontCamera: AVCaptureDevice?
    internal var frontCameraInput: AVCaptureDeviceInput?
    
    internal var rearCamera: AVCaptureDevice?
    internal var rearCameraInput: AVCaptureDeviceInput?
    
    internal var previewLayer: AVCaptureVideoPreviewLayer?
    
    internal var photoOutput: AVCapturePhotoOutput?
    
    internal static var flashMode: AVCaptureDevice.FlashMode = .off
    internal var initialed: Bool = false

    internal func prepare(completion: @escaping() -> Void, failure: @escaping(_ error: Error?) -> Void) {
        DispatchQueue.main.async { [unowned self] in
            do {
                self.createCaptureSession()
                try self.configurationCaptureDevice()
                try self.configurationDeviceInputs()
                try self.configurationPhotoOutput()
            }
            catch {
                DispatchQueue.main.async {
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
            session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        } else {
            session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDuoCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
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
        
        captureSession.startRunning()
    }
}

//MARK: Manage
extension Camera {
    internal func displayPreview() throws {
        guard let captureSession = captureSession, captureSession.isRunning else {
            throw CameraError.captureSessionIsMissing
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
    }
    
    internal func addPreviewLayer(view: UIView) {
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)
    }
    
    internal func begin() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
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
        
        photoOutput?.capturePhoto(with: settings, delegate: self)
        photoCaptureCompletionBlock = completion
        photoCaptureFailureBlock = failure
    }
}

//MARK: AVCapturePhotoCaptureDelegate
extension Camera: AVCapturePhotoCaptureDelegate {
    internal func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                                   resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error {
            photoCaptureFailureBlock?(error)
            return
        }

        if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
            let image = UIImage(data: data)
            photoCaptureCompletionBlock?(image)
        }
        else {
            photoCaptureFailureBlock?(CameraError.unknown)
        }
    }
}
