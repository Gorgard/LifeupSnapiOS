//
//  LFSGraphError.swift
//  LifeupSnap
//
//  Created by lifeup on 25/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

struct LFSGraphError: LFSGraphDecoder {
    var code: Int?
    var message: String?
    var error: String?
    
    init() {}
    
    init(json: [String : Any]) {
        if let _code = json["code"] as? Int {
            self.code = _code
        }
        
        if let _message = json["message"] as? String {
            self.message = _message
        }
    }
    
    func toJson() -> [String : Any]? {
        return nil
    }
}
