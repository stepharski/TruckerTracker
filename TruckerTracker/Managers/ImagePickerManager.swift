//
//  ImagePickerManager.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/10/23.
//

import UIKit
import Photos
import AVFoundation

class ImagePickerManager: NSObject, UINavigationControllerDelegate {
    
    private var viewController: UIViewController?
    private var imagePicker = UIImagePickerController()
    private var completionHandler: ((UIImage?) -> Void)?
    
    // Select action camera/library
    func showImagePicker(in controller: UIViewController, completionHandler: @escaping (UIImage?) -> Void) {
        self.viewController = controller
        self.completionHandler = completionHandler
        let alertController = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take photo", style: .default) { _ in
                self.checkCameraPermission()
            }
            alertController.addAction(cameraAction)
        }
        
        let galleryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.checkPhotoLibraryPermission()
        }
        alertController.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true)
    }
    
    // Open camera/gallery
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            viewController?.present(imagePicker, animated: true)
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                viewController?.present(imagePicker, animated: true)
        }
    }
    
    // Permissions
    private func checkCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            requestCameraPermission()
        case .restricted, .denied:
            alertAccessNeeded(access: "Camera")
        case .authorized:
            openCamera()
        default:
            break
        }
    }
    
    private func checkPhotoLibraryPermission() {
        let photolibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photolibraryAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self?.openGallery()
                    }
                }
            })
        case .authorized:
            self.openGallery()
        case .denied, .restricted:
            self.alertAccessNeeded(access: "Library")
        default:
            break
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            guard accessGranted == true else { return }
            DispatchQueue.main.async { [weak self] in
                self?.openCamera()
            }
        })
    }
    
    // Ask access
    private func alertAccessNeeded(access: String) {
        guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        let alert = UIAlertController(title: "\(access) Access Denied",
                                      message: "\(access) access is required to change your profile picture.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        alert.modalPresentationStyle = .currentContext
        viewController?.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ImagePickerManager: UIImagePickerControllerDelegate {
    //Did finish
    func imagePickerController(_ picker: UIImagePickerController,
           didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        completionHandler?(selectedImage)
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    // Did cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completionHandler?(nil)
        viewController?.dismiss(animated: true)
    }
}
