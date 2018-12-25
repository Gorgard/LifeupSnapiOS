//
//  LFSBaseModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import Photos

internal class LFSBaseModel: NSObject, URLSessionDelegate {
    
    func sendRequestWith<T: LFSGraphDecoder>(method: LFSHTTPMethods, server: LFSConfig.Server, urlSuffixs: String, params: [String: Any]?, responseType: T.Type, completion: @escaping(_ graph: T?) -> Void, failure: @escaping(_ error: LFSGraphError?) -> Void) {
        let url = server.rawValue + urlSuffixs
        
        requestWith(method: method, url: url, params: params, responseType: responseType, completion: { (graph) -> Void in
            completion(graph)
        }, failure: { (error) -> Void in
            failure(error)
        })
    }
    
    private func requestWith<T: LFSGraphDecoder>(method: LFSHTTPMethods, url: String, params: [String: Any]?, responseType: T.Type, completion: @escaping(_ graph: T?) -> Void, failure: @escaping(_ error: LFSGraphError?) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        
        if let _params = params {
            urlRequest.httpBody = LFSJsonUtils.convertDictToJsonString(dictionary: _params)?.data(using: .utf8)
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0
        configuration.timeoutIntervalForResource = 15.0
        
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                let message = "Send \(method) is error: \(String(describing: error?.localizedDescription))"
                let error = self.handleLocalError(message: message, code: ((error as NSError?)?.code) ?? 0)
                
                taskMain {
                    failure(error)
                }
                
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                case 200...299:
                    let graph = self.decoder(data: data!, responseType: responseType)
                    
                    taskMain {
                        completion(graph)
                    }
                    
                    break
                default:
                    let error = self.decoder(data: data!, responseType: LFSGraphError.self)
                    
                    taskMain {
                        failure(error)
                    }
                    
                    break
                }
            }
        })
        
        dataTask.resume()
    }
    
    internal func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
    
    //MARK: Docoder
    private func decoder<T: LFSGraphDecoder>(data: Data?, responseType: T.Type) -> T? {
        if let _data = data {
            let json = LFSJsonUtils.dataToDictionary(data: _data)
            let decoded = responseType.init(json: json!)
            
            return decoded
        }
        
        return nil
    }
    
    //MARK: Handle Error
    private func handleError(with json: [String: Any]) -> LFSGraphError? {
        let error = LFSGraphError(json: json)
        return error
    }
    
    private func handleLocalError(message: String?, code: Int) -> LFSGraphError? {
        var error = LFSGraphError()
        error.message = message
        error.code = code
        error.error = "Local Error"
        
        return error
    }

    internal func outputPathURL(fileName: String, fileType: String) -> URL? {
        let tempPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)?.appendingPathComponent(fileName).appendingPathExtension(fileType)
        
        if FileManager.default.fileExists(atPath: tempPath?.absoluteString ?? "") {
            do {
                try FileManager.default.removeItem(at: tempPath!)
            }
            catch {
                print(error)
            }
        }
        
        return tempPath
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
}
