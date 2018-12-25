//
//  LFSVideoModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit

internal class LFSVideoModel: LFSBaseModel {
    internal static let shared: LFSVideoModel = LFSVideoModel()
    
    private override init() {}
    
    func thumnailImage(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    internal func saveVideoByURL(url: URL, completion: @escaping(_ video: AVURLAsset) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { (saved, error) -> Void in
            if let error = error {
                failure(error)
                return
            }
            
            if saved {
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                let fetchResult = PHAsset.fetchAssets(with: .video, options: options).lastObject
                let imageManager = PHImageManager()
                
                imageManager.requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) -> Void in
                    let video = avurlAsset as! AVURLAsset
                    
                    taskMain {
                        completion(video)
                    }
                })
            }
        })
    }
    
    internal func playSimpleVideo(url: URL, viewController: UIViewController) {
        let player = AVPlayer(url: url)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        viewController.present(playerController, animated: true, completion: {
            playerController.player!.play()
        })
    }
    
    internal func orientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = .portrait
            break
        case .landscapeRight:
            orientation = .landscapeLeft
            break
        case .landscapeLeft:
            orientation = .landscapeRight
            break
        default:
            orientation = .portrait
            break
        }
        
        return orientation
    }
}

//MARK: Merge Video
extension LFSVideoModel {
    internal func mergeEditedVideo(url: URL, view: UIView, completion: @escaping(_ url: URL?) -> Void) {
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: url)
        
        let tracks = asset.tracks(withMediaType: .video)
        
        if let videoTrack = tracks.last {
            let timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
            
            let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: videoTrack.trackID)
            
            do {
                try compositionVideoTrack?.insertTimeRange(timeRange, of: videoTrack, at: kCMTimeZero)
                compositionVideoTrack?.preferredTransform = videoTrack.preferredTransform
            }
            catch {
                print(error.localizedDescription)
            }
            
            let size = videoTrack.naturalSize
            
            let overlayView = LFSEditModel.shared.renderImage(view: view)
            
            let overlayLayer = CALayer()
            overlayLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            overlayLayer.contents = overlayView.cgImage
            overlayLayer.opacity = 1
            
            let videoLayer = CALayer()
            videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let parentLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            parentLayer.addSublayer(videoLayer)
            parentLayer.addSublayer(overlayLayer)
            
            let layerComposition = AVMutableVideoComposition()
            layerComposition.frameDuration = CMTimeMake(1, 30)
            layerComposition.renderSize = CGSize(width: size.width, height: size.height)
            layerComposition.renderScale = 1.0
            layerComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
            
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
            instruction.layerInstructions = [layerInstruction]
            
            layerComposition.instructions = [instruction]
            
            let fileName = "\(LFSConstants.LFSVideoName.Snap.snapMergeEditedVideo)\(Date())"
            let outputURL = super.outputPathURL(fileName: fileName, fileType: "mp4")
            
            guard let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else { return }
            assetExport.videoComposition = layerComposition
            assetExport.outputFileType = .mp4
            assetExport.outputURL = outputURL
            
            assetExport.exportAsynchronously {
                completion(outputURL)
            }
        }
    }
}

//MARK: Reversed
extension LFSVideoModel {
    internal func reverse(originalURL: URL, completion: @escaping(_ url: URL?) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        let original = AVAsset(url: originalURL)
        
        var reader: AVAssetReader!
        
        do {
            reader = try AVAssetReader(asset: original)
        } catch {
            failure(CameraError.inputsAreInvalid)
            return
        }
        
        guard let videoTrack = original.tracks(withMediaType: .video).last else {
            failure(CameraError.inputsAreInvalid)
            return
        }
        
        let readerOutputSettings: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        let readerOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: readerOutputSettings)
        reader.add(readerOutput)
        
        reader.startReading()
        
        var samples: [CMSampleBuffer] = []
        while let sample = readerOutput.copyNextSampleBuffer() {
            samples.append(sample)
        }
        
        let fileName = "\(LFSConstants.LFSVideoName.Snap.snapReversedVideo)\(Date())"
        let reversePath = LFSVideoModel.shared.outputPathURL(fileName: fileName, fileType: LFSConstants.LFSFileType.Snap.mov)!
        
        let writer: AVAssetWriter
        
        do {
            writer = try AVAssetWriter(outputURL: reversePath, fileType: .mov)
        } catch let error {
            failure(error)
            return
        }
        
        let videoCompositionProps = [AVVideoAverageBitRateKey: videoTrack.estimatedDataRate]
        
        let writerOutputSettings = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: videoTrack.naturalSize.width,
            AVVideoHeightKey: videoTrack.naturalSize.height,
            AVVideoCompressionPropertiesKey: videoCompositionProps] as [String : Any]
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: writerOutputSettings)
        writerInput.expectsMediaDataInRealTime = false
        writerInput.transform = videoTrack.preferredTransform
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
        
        writer.add(writerInput)
        writer.startWriting()
        writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(samples.first!))
        
        for (index, sample) in samples.enumerated() {
            let presentationTime = CMSampleBufferGetPresentationTimeStamp(sample)
            let imageBufferRef = CMSampleBufferGetImageBuffer(samples[samples.count - 1 - index])
            while !writerInput.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.1)
            }
            pixelBufferAdaptor.append(imageBufferRef!, withPresentationTime: presentationTime)
            
        }
        
        writer.finishWriting { [unowned self] in
            self.mergeReversed(originalURL: originalURL, reversePath: reversePath, completion: completion)
        }
    }
    
    private func mergeReversed(originalURL: URL, reversePath: URL, completion: @escaping(_ url: URL?) -> Void) {
        let videos = [originalURL, reversePath]
        
        let composition = AVMutableComposition()
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var currentVideoTime = kCMTimeZero
        
        for video in videos {
            let asset = AVAsset(url: video)
            let videoAssetTrack = asset.tracks(withMediaType: .video).first!
            
            do {
                try videoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: currentVideoTime)
            }
            catch {
                print("Cannot merged reversed video.")
            }
            
            let scaleDuration = CMTimeMultiplyByFloat64(videoAssetTrack.timeRange.duration, Float64(0.5))
            videoTrack?.scaleTimeRange(CMTimeRangeMake(currentVideoTime, videoAssetTrack.timeRange.duration), toDuration: scaleDuration)
            currentVideoTime = CMTimeAdd(currentVideoTime, scaleDuration)
        }
        
        videoTrack?.preferredTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        let fileName = "\(LFSConstants.LFSVideoName.Snap.snapMergedVideo)\(Date())"
        let mergedPath = LFSVideoModel.shared.outputPathURL(fileName: fileName, fileType: LFSConstants.LFSFileType.Snap.mov)!
        
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = mergedPath
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.outputFileType = .mov
        
        exporter?.exportAsynchronously {
            taskMain {
                completion(exporter?.outputURL)
            }
        }
    }
}

