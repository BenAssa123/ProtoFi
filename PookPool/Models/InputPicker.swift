//
//  Picker.swift
//  PookPool
//
//  Created by Assa Bentzur on 03/08/2022.
//

import Foundation
import UIKit

enum InputPicker {
    enum Source: String {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
    }
}

