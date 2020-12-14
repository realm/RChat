//
//  PhotoCaptureController.swift
//  RChat
//
//  Created by Andrew Morgan on 24/11/2020.
//

import UIKit
import SwiftUI
import RealmSwift

class PhotoCaptureController: UIImagePickerController {
    
    @EnvironmentObject var state: AppState

    private var photoTaken: ((PhotoCaptureController, Photo) -> Void)?
    private var photo = Photo()
    private let imageSizeThumbnails: CGFloat = 102
    private let maximumImageSize = 1024 * 1024 // 1 MB

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }

    static func show(source: UIImagePickerController.SourceType,
                     photoToEdit: Photo = Photo(),
                     photoTaken: ((PhotoCaptureController, Photo) -> Void)? = nil) {
        
        let picker = PhotoCaptureController()
        picker.photo = photoToEdit
        picker.setup(source)
        picker.photoTaken = photoTaken
        picker.present()
    }
    
    func setup(_ requestedSource: UIImagePickerController.SourceType) {
        if PhotoCaptureController.isSourceTypeAvailable(.camera) && requestedSource == .camera {
            sourceType = .camera
        } else {
            print("No camera found - using photo library instead")
            sourceType = .photoLibrary
        }
        allowsEditing = true
        delegate = self
    }
    
    func present() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
    }
    
    func hide() {
        photoTaken = nil
        dismiss(animated: true)
    }
    
    private func compressImageIfNeeded(image: UIImage) -> UIImage? {
        let resultImage = image
        
        if let data = resultImage.jpegData(compressionQuality: 1) {
            if data.count > maximumImageSize {
                
                let neededQuality = CGFloat(maximumImageSize) / CGFloat(data.count)
                if let resized = resultImage.jpegData(compressionQuality: neededQuality),
                   let resultImage = UIImage(data: resized) {
                    
                    return resultImage
                } else {
                    print("Fail to resize image")
                }
            }
        }
        return resultImage
    }
}

extension PhotoCaptureController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let editedImage = info[.editedImage] as? UIImage,
              let result = compressImageIfNeeded(image: editedImage) else {
            print("Could't get the camera/library image")
            return
        }
        
        photo.date = Date()
        photo.picture = result.jpegData(compressionQuality: 0.8)
        photo.thumbNail = result.thumbnail(size: imageSizeThumbnails)?.jpegData(compressionQuality: 0.8)
        photoTaken?(self, photo)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hide()
    }
}
