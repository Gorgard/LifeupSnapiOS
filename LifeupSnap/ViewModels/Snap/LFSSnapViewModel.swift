//
//  LFSSnapViewModel.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVKit

internal class LFSSnapViewModel: LFSViewModel {
    private weak var delegate: LFSSnapViewModelDelegate?
    
    internal var viewFeatures: [LFSFeature]!
    internal var features: [CameraFeature]!
    
    private var feature: CameraFeature!
    
    internal var camera: Camera!
    internal var circularProgress: CircularProgress!
    
    internal var snapButtonBounds: CGRect!
    internal var coverCaptureViewBounds: CGRect!
    
    private var currentIndex: Int = 1
    private var initialed: Bool = false
    
    open var receivedFeature: ((_ index: Int) -> Void)?
    open var hiddenBlurView: ((_ alpha: CGFloat) -> Void)?
    open var changeSnapButtonColor: ((_ color: UIColor) -> Void)?
    open var enableAllView: ((_ enable: Bool) -> Void)?
    open var changeSnapButtonRadius: ((_ radius: CGFloat, _ bounds: CGRect) -> Void)?
    open var changeImageFlashButton: ((_ image: UIImage) -> Void)?
    open var changeImageSnapButton: ((_ image: UIImage?) -> Void)?
    open var changeSquareViewHeight: ((_ height: CGFloat) -> Void)?
    
    //MARK: Camera value
    private var image: UIImage?

    init(delegate: LFSSnapViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
    }
}

//MARK: Base
extension LFSSnapViewModel {
    internal func setup() {
        viewFeatures = [LFSFeature]()
        
        features = features.sorted(by: { $0.rawValue > $1.rawValue })
        
        if let features = features {
            for feature in features {
                let viewFeature = LFSFeature(name: feature.rawValue, isCurrent: false)
                viewFeatures.append(viewFeature)
            }
        }
        else {
           features = [.original]
        }
    }
    
    internal func binding() {
        if !initialed {
            currentIndex = features.index(of: .original)!
            feature = .original
            initialed = true
        }
        
        feature = features[currentIndex]
        
        viewFeatures[currentIndex].isCurrent = true
        
        receivedFeature?(currentIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [unowned self] in
            self.hiddenBlurView?(0)
        })
        
        changeSnapButtonColor?(feature.rawValue == CameraFeature.video.rawValue ? .red : .white)
        changeImageSnapButton?(feature.rawValue == CameraFeature.boomerang.rawValue ? #imageLiteral(resourceName: "ic_main_infinity.png") : nil)
        changeSquareViewHeight?(feature.rawValue == CameraFeature.square.rawValue ? (coverCaptureViewBounds.size.width / 4) - 20 : 0)
        
        if let camera = camera {
            camera.resetPreviewLayer(view: view!)
        }
        
        if !(feature.rawValue == CameraFeature.video.rawValue || feature.rawValue == CameraFeature.boomerang.rawValue) {
            removeCircularProgress()
        }
    }
}

//MARK: PickerViewPresentable
extension LFSSnapViewModel: PickerViewPresentable {
    func numberOfComponents(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfRowsInComponent(pickerView: UIPickerView, component: Int) -> Int {
        return features.count
    }
    
    func viewForRow(pickerView: UIPickerView, row: Int, component: Int, view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.text = features[row].rawValue
        label.textColor = viewFeatures[row].isCurrent ? UIColor.yellow : UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        return label
    }
    
    func didSelected(pickerView: UIPickerView, row: Int, component: Int) {
        hiddenBlurView?(1)
        
        currentIndex = row
        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
}

//MARK: ACTION Handle
extension LFSSnapViewModel {
    internal func flip() {
        flipCamera()
    }
    
    internal func flash() {
        if Camera.flashMode == .off {
            changeImageFlashButton?(#imageLiteral(resourceName: "ic_main_flash_on.png"))
        }
        else {
            changeImageFlashButton?(#imageLiteral(resourceName: "ic_main_flash_off.png"))
        }
        
        flashCamera()
    }
    
    internal func snap() {
        switch feature {
        case .boomerang:
            snapBoomerang()
            break
        case .original:
            snapOriginal()
            break
        case .square:
            snapSquare()
            break
        case .video:
            snapVideo()
            break
        default:
            break
        }
    }
    
    fileprivate func snapBoomerang() {
        DispatchQueue.main.async { [unowned self] in
            self.changeSnapButtonRadius?(8, CGRect(x: 0, y: 0, width: 40, height: 40))
            self.enableAllView?(false)
        }
        
        startProgressBoomerang()
        captureBoomerang()
    }
    
    fileprivate func snapOriginal() {
        captureOriginal()
    }
    
    fileprivate func snapSquare() {
        captureSquare()
    }
    
    fileprivate func snapVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.changeSnapButtonRadius?(8, CGRect(x: 0, y: 0, width: 40, height: 40))
            self.enableAllView?(false)
        }
        
        startProgressVideo()
        captureVideo()
    }
}

//MARK: Handle SwipeGesture
extension LFSSnapViewModel {
    internal func handleSwipeRight() {
        if currentIndex == NSNotFound {
            return
        }
        
        currentIndex += 1
        
        if currentIndex > viewFeatures.count - 1 {
            currentIndex = viewFeatures.count - 1
        }
    
        if currentIndex == viewFeatures.count {
            return
        }
        
        hiddenBlurView?(1)
        
        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
    
    internal func handleSwipeLeft() {
        if currentIndex == 0 || currentIndex == NSNotFound {
            return
        }
        
        currentIndex -= 1
        
        hiddenBlurView?(1)

        setNotCurrent(currentIndex: currentIndex)
        
        binding()
    }
}

//MARK: Handle Methods
extension LFSSnapViewModel {
    fileprivate func setNotCurrent(currentIndex: Int) {
        for i in 0..<viewFeatures.count {
            viewFeatures[i].isCurrent = false
        }
    }
}

//MARK: Manage Camera
extension LFSSnapViewModel {
    internal func prepareCamera() {
        camera.prepare(completion: { [unowned self] () -> Void in
            try? self.camera.displayPreview()
            self.camera.addPreviewLayer(view: self.view!)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    internal func beginCamera() {
        if camera.initialed {
            camera.begin()
        }
    }
    
    private func flipCamera() {
        try? camera.switchCamera()
    }
    
    private func flashCamera() {
        if Camera.flashMode == .on {
            Camera.flashMode = .off
        }
        else {
            Camera.flashMode = .on
        }
    }
}

//MARK: Manage Camera Boomerang
extension LFSSnapViewModel {
    @objc private func captureBoomerang() {
        if camera.isRecording {
            stopBoomerangRecord()
            return
        }
        
        startBoomerangRecord()
    }
    
    private func startBoomerangRecord() {
        camera.maxDuration = 10
        camera.renewMovieOutput()
        
        camera.recordVideo(completion: { [weak self] (url) -> Void in
            self?.handleRecord(url: url)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func handleRecord(url: URL?) {
        if camera.selfStop {
            finishedSnapBoomerang()
        }
        
        if let _url = url {
            camera.reverse(originalURL: _url, completion: { (reversedURL) -> Void in
                self.playWithUrl(url: reversedURL!)
            }, failure: { (error) -> Void in
                print(error?.localizedDescription ?? "")
            })
        }
    }
    
    private func playWithUrl(url: URL) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        DispatchQueue.main.async {
            self.viewController?.present(playerViewController, animated: true, completion: {
                playerViewController.player?.play()
            })
        }
    }
    
    private func stopBoomerangRecord() {
        camera.stopRecord()
        finishedSnapBoomerang()
    }
    
    fileprivate func finishedSnapBoomerang() {
        DispatchQueue.main.async { [unowned self] in
            self.changeSnapButtonRadius?(self.snapButtonBounds.size.height / 2, self.snapButtonBounds)
            self.enableAllView?(true)
        }
        
        removeCircularProgress()
    }
}

//MARK: Manage Camera Original
extension LFSSnapViewModel {
    private func captureOriginal() {
        camera.captureImage(completion: { [weak self] (image) -> Void in
            self?.image = image
            
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

//MARK: Manage Camera Square
extension LFSSnapViewModel {
    @objc private func captureSquare() {
        camera.captureImage(completion: { [weak self] (image) -> Void in
            self?.image = image
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
}

//MARK: Manage Camera Video
extension LFSSnapViewModel {
    private func captureVideo() {
        if camera.isRecording {
            stopVideoRecord()
            return
        }
        
        startVideoRecord()
    }
    
    private func startVideoRecord() {
        camera.maxDuration = 30
        camera.renewMovieOutput()
        
        camera.recordVideo(completion: { [weak self] (url) -> Void in
            self?.handleVideoRecord()
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func handleVideoRecord() {
        if camera.selfStop {
            finishedSnapVideo()
        }
    }
    
    private func stopVideoRecord() {
        camera.stopRecord()
        finishedSnapVideo()
    }
    
    fileprivate func finishedSnapVideo() {
        DispatchQueue.main.async { [unowned self] in
            self.changeSnapButtonRadius?(self.snapButtonBounds.size.height / 2, self.snapButtonBounds)
            self.enableAllView?(true)
        }
        
        removeCircularProgress()
    }
}

//MARK: Circular Progress
extension LFSSnapViewModel {
    fileprivate func startProgressVideo() {
        circularProgress.duration = 30
        circularProgress.bgColor = UIColor.clear.cgColor
        circularProgress.strokeColor = UIColor.orange.cgColor
        circularProgress.lineWidth = 4
        circularProgress.animateProgressView()
    }
    
    fileprivate func startProgressBoomerang() {
        circularProgress.duration = 10
        circularProgress.bgColor = UIColor.clear.cgColor
        circularProgress.strokeColor = UIColor.orange.cgColor
        circularProgress.lineWidth = 4
        circularProgress.animateProgressView()
    }
    
    fileprivate func removeCircularProgress() {
        if let _ = circularProgress {
            circularProgress.hideProgressView()
        }
    }
}
