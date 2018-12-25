//
//  LFSJsonUtils.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal class LFSJsonUtils: NSObject {
    static func convertDictToJsonString(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue) as String?
            
            return jsonString
        }
    }
    
    static func dataToDictionary(data: Data) -> [String: Any]? {
        do {
            let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            let dictionary = convertJsonStringToDictionary(json: jsonString!)
            
            return dictionary
        }
    }
    
    static func convertJsonStringToDictionary(json: String) -> [String: Any]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
