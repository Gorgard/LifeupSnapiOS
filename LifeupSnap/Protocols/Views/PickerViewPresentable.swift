//
//  PickerViewPresentable.swift
//  LifeupSnap
//
//  Created by lifeup on 29/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

@objc internal protocol PickerViewPresentable: NSObjectProtocol {
    func numberOfComponents(pickerView: UIPickerView) -> Int
    func numberOfRowsInComponent(pickerView: UIPickerView, component: Int) -> Int
    
    @objc optional func viewForRow(pickerView: UIPickerView, row: Int, component: Int, view: UIView?) -> UIView
    @objc optional func didSelected(pickerView: UIPickerView, row: Int, component: Int)
}
