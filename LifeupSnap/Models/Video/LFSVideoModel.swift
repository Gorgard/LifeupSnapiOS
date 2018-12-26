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
    internal func mergeEditedVideo(url: URL, originalVideo: Bool, view: UIView, completion: @escaping(_ url: URL?) -> Void) {
        let videoAsset = AVAsset(url: url)
        let mixComposition = AVMutableComposition()
        
        guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else { return}
        guard let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first else { return }
        
        var audioTrack: AVMutableCompositionTrack? = nil
        var audioAssetTrack: AVAssetTrack? = nil
        
        if originalVideo {
            audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            audioAssetTrack = videoAsset.tracks(withMediaType: .audio).first
        }
        
        let timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        
        do {
            try videoTrack.insertTimeRange(timeRange, of: videoAssetTrack, at: kCMTimeZero)
            
            if originalVideo {
                try audioTrack?.insertTimeRange(timeRange, of: audioAssetTrack!, at: kCMTimeZero)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = timeRange
        
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        
        var videoOrientation: UIImageOrientation = .up
        var isVideoAssetPortrait: Bool = false
        
        let videoTransform = videoAssetTrack.preferredTransform
        
        if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoOrientation = .right
            isVideoAssetPortrait = true
        }
        if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoOrientation = .left
            isVideoAssetPortrait = true
        }
        if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoOrientation = .up
        }
        if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoOrientation = .down
        }
        
        videoLayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: kCMTimeZero)
        videoLayerInstruction.setOpacity(0.0, at: videoAsset.duration)
        
        mainInstruction.layerInstructions = [videoLayerInstruction]
        
        let mainComposition = AVMutableVideoComposition()
        
        let naturalSize: CGSize
        
        if isVideoAssetPortrait {
            naturalSize = CGSize(width: videoAssetTrack.naturalSize.height, height: videoAssetTrack.naturalSize.width)
        }
        else {
            naturalSize = videoAssetTrack.naturalSize
        }
        
        let renderWidth = naturalSize.width
        let renderHeight = naturalSize.height
        
        mainComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(1, 30)
        
        addViewToVideo(compostion: mainComposition, view: view, size: naturalSize)
        
        let fileName = "\(LFSConstants.LFSVideoName.Snap.snapMergeEditedVideo)\(Date())"
        let outputURL = super.outputPathURL(fileName: fileName, fileType: "mp4")
        
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        exporter.exportAsynchronously {
            taskMain {
                completion(exporter.outputURL)
            }
        }
    }

    fileprivate func addViewToVideo(compostion: AVMutableVideoComposition, view: UIView, size: CGSize) {
        let image = LFSEditModel.shared.renderImage(view: view)
        
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        overlayLayer.contents = image.cgImage
        overlayLayer.masksToBounds = true
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        compostion.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
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
            
            videoTrack?.preferredTransform = videoAssetTrack.preferredTransform
            
            let scaleDuration = CMTimeMultiplyByFloat64(videoAssetTrack.timeRange.duration, Float64(0.5))
            videoTrack?.scaleTimeRange(CMTimeRangeMake(currentVideoTime, videoAssetTrack.timeRange.duration), toDuration: scaleDuration)
            currentVideoTime = CMTimeAdd(currentVideoTime, scaleDuration)
        }

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

