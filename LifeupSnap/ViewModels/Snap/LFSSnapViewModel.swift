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
    
    internal var receivedFeature: ((_ index: Int) -> Void)?
    internal var hiddenBlurView: ((_ alpha: CGFloat) -> Void)?
    internal var changeSnapButtonColor: ((_ color: UIColor) -> Void)?
    internal var enableAllView: ((_ enable: Bool) -> Void)?
    internal var changeSnapButtonRadius: ((_ radius: CGFloat, _ bounds: CGRect) -> Void)?
    internal var changeImageFlashButton: ((_ image: UIImage) -> Void)?
    internal var changeImageSnapButton: ((_ image: UIImage?) -> Void)?
    internal var changeSquareViewHeight: ((_ height: CGFloat) -> Void)?
    internal var hiddenLoadingView: ((_ hidden: Bool) -> Void)?
    
    //MARK: Camera value
    private var image: UIImage?

    init(delegate: LFSSnapViewModelDelegate) {
        super.init()
        self.delegate = delegate
        camera = Camera()
    }
    
    deinit {
        removeAll()
    }
}

//MARK: Base
extension LFSSnapViewModel {
    internal func setup() {
        viewFeatures = [LFSFeature]()
        
        features = features.sorted(by: { $0.rawValue > $1.rawValue })
        
        if let features = features, features.count > 0 {
            for feature in features {
                let viewFeature = LFSFeature(name: feature.rawValue, isCurrent: false)
                viewFeatures.append(viewFeature)
            }
        }
        else {
            viewFeatures.append(LFSFeature(name: CameraFeature.original.rawValue, isCurrent: false))
            features = [.original]
        }
    }
    
    internal func binding() {
        if !initialed {
            if features.contains(.original) {
                currentIndex = features.index(of: .original)!
                feature = .original
            }
            else {
                currentIndex = features.count - 1
                feature = features[currentIndex]
            }
            
            initialed = true
        }
        
        feature = features[currentIndex]
        
        viewFeatures[currentIndex].isCurrent = true
        
        receivedFeature?(currentIndex)
        
        taskMainAfter(deadline: .now() + 1, { [unowned self] in
            self.hiddenBlurView?(0)
        })
        
        changeSnapButtonColor?(feature.rawValue == CameraFeature.video.rawValue ? .red : .white)
        changeImageSnapButton?(feature.rawValue == CameraFeature.boomerang.rawValue ? #imageLiteral(resourceName: "ic_main_infinity.png") : nil)
        changeSquareViewHeight?(feature.rawValue == CameraFeature.square.rawValue ? 60 : 0)
        
        if let camera = camera {
            camera.resetPreviewLayer(view: view!)
        }
        
        if !(feature.rawValue == CameraFeature.video.rawValue || feature.rawValue == CameraFeature.boomerang.rawValue) {
            removeCircularProgress()
        }
        
        if feature.rawValue == CameraFeature.video.rawValue {
            setupVideo()
        }
        
        if feature.rawValue == CameraFeature.boomerang.rawValue {
            setupBoomerang()
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
        taskMain { [unowned self] in
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
        taskMain { [unowned self] in
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
            self.addPreviewLayer(view: self.view)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    fileprivate func addPreviewLayer(view: UIView?) {
        if let view = view {
            camera.addPreviewLayer(view: view)
        }
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
        camera.recordVideo(completion: { [weak self] (url) -> Void in
            self?.handleRecord(url: url)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func handleRecord(url: URL?) {
        taskMain { [unowned self] in
            self.hiddenLoadingView?(false)
        }
        
        if camera.selfStop {
            finishedSnapBoomerang()
        }
        
        if let _url = url {
            camera.reverse(originalURL: _url, completion: { (reversedURL) -> Void in
                self.boomerangPreview(url: reversedURL!)
            }, failure: { (error) -> Void in
                print(error?.localizedDescription ?? "")
            })
        }
    }
    
    private func stopBoomerangRecord() {
        camera.stopRecord()
        finishedSnapBoomerang()
    }
    
    fileprivate func finishedSnapBoomerang() {
        taskMain { [unowned self] in
            self.changeSnapButtonRadius?(self.snapButtonBounds.size.height / 2, self.snapButtonBounds)
            self.enableAllView?(true)
        }
        
        removeCircularProgress()
    }
    
    fileprivate func boomerangPreview(url: URL) {
        let lfsVideoPreviewViewController = LFSVideoPreviewViewController()
        lfsVideoPreviewViewController.url = url
        
        taskMain { [unowned self] in
            self.hiddenLoadingView?(true)
            self.viewController?.present(lfsVideoPreviewViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupBoomerang() {
        self.camera.maxDuration = 10
        self.camera.renewMovieOutput()
    }
}

//MARK: Manage Camera Original
extension LFSSnapViewModel {
    private func captureOriginal() {
        camera.captureImage(completion: { [weak self] (image) -> Void in
            self?.handleOriginalCapture(image: image)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    fileprivate func handleOriginalCapture(image: UIImage?) {
        self.image = image
        
        let lfsPhotoPreviewViewController = LFSPhotoPreviewViewController()
        lfsPhotoPreviewViewController.image = self.image
        
        viewController?.present(lfsPhotoPreviewViewController, animated: true, completion: nil)
    }
}

//MARK: Manage Camera Square
extension LFSSnapViewModel {
    private func captureSquare() {
        camera.captureSquareImage(completion: { [weak self] (image) -> Void in
            self?.handleSquareCapture(image: image)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    fileprivate func handleSquareCapture(image: UIImage?) {
        self.image = image
        
        let lfsPhotoPreviewViewController = LFSPhotoPreviewViewController()
        lfsPhotoPreviewViewController.image = self.image
        
        viewController?.present(lfsPhotoPreviewViewController, animated: true, completion: nil)
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
        camera.recordVideo(completion: { [weak self] (url) -> Void in
            self?.handleVideoRecord(url: url)
        }, failure: { (error) -> Void in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func handleVideoRecord(url: URL?) {
        taskMain { [unowned self] in
            self.hiddenLoadingView?(false)
        }
        
        if camera.selfStop {
            finishedSnapVideo()
        }
        
        if let _url = url {
            videoPreview(url: _url)
        }
    }
    
    private func stopVideoRecord() {
        camera.stopRecord()
        finishedSnapVideo()
    }
    
    fileprivate func finishedSnapVideo() {
        taskMain { [unowned self] in
            self.changeSnapButtonRadius?(self.snapButtonBounds.size.height / 2, self.snapButtonBounds)
            self.enableAllView?(true)
        }
        
        removeCircularProgress()
    }
    
    fileprivate func videoPreview(url: URL) {
        let lfsVideoPreviewViewController = LFSVideoPreviewViewController()
        lfsVideoPreviewViewController.url = url
        
        taskMain { [unowned self] in
            self.hiddenLoadingView?(true)
            self.viewController?.present(lfsVideoPreviewViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupVideo() {
        camera.maxDuration = 30
        camera.renewMovieOutput()
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

//MARK: Remove all
extension LFSSnapViewModel {
    fileprivate func removeAll() {
        delegate = nil
        viewFeatures = nil
        features = nil
        feature = nil
        camera = nil
        circularProgress = nil
        snapButtonBounds = nil
        coverCaptureViewBounds = nil
        receivedFeature = nil
        hiddenBlurView = nil
        changeSnapButtonColor = nil
        enableAllView = nil
        changeSnapButtonRadius = nil
        changeImageFlashButton = nil
        changeImageSnapButton = nil
        changeSquareViewHeight = nil
        hiddenLoadingView = nil
    }
}
