//
//  PhotoPicker.swift
//  PookPool
//
//  Created by Assa Bentzur on 03/08/2022.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import SwiftUI

class PhotoPickerManager: ObservableObject {
    
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: InputPicker.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !InputPicker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
}
