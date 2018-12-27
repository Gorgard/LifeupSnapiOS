//
//  AlertController.swift
//  LifeupSnap
//
//  Created by lifeup on 27/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

internal class AlertController: NSObject {
    private var _title: String?
    private var message: String?
    private var acceptButtonTitle: String?
    private var cancelButtonTitle: String?
    
    internal var shouldHaveCancelButton: Bool = true
    
    internal init(title: String?, message: String?, acceptButtonTitle: String?, cancelButtonTitle: String?) {
        self._title = title
        self.message = message
        self.acceptButtonTitle = acceptButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        super.init()
    }
    
    internal func show(viewController: UIViewController, accept: ((UIAlertAction) -> Void)?, cancel: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: _title, message: message, preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: acceptButtonTitle ?? "", style: .default, handler: accept)
        let cancelButton = UIAlertAction(title: cancelButtonTitle ?? "", style: .cancel, handler: cancel)
        
        if shouldHaveCancelButton {
            alertController.addAction(cancelButton)
        }
        
        alertController.addAction(acceptButton)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
