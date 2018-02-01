//
//  PhotoLibraryManager.swift
//  HangJia/Users/luo/Desktop/SVN/demo-swift/demo-swift/Manager/PhotoLibraryManager/PhotoLibraryManager.swift
//
//  Created by Alvin on 16/2/15.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import AssetsLibrary

@objc protocol PhotoLibraryManagerDelegate {
    func delegatePhotoLibraryManager(_ manager: PhotoLibraryManager, didPickedImage image: UIImage?)
}

class PhotoLibraryManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = PhotoLibraryManager()
    weak var delegate: PhotoLibraryManagerDelegate?
    
    fileprivate override init() {
    
    }
    
    /// 通过相机加图片
    func browseFromCamera() {
        if canLoadPhotoAlbum() {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                imagePicker.sourceType = .camera
                let ctrl: UIViewController = self.delegate as! UIViewController
                ctrl.present(imagePicker, animated: true, completion: { () -> Void in
                })
            } else {
                BFunction.shared.showErrorMessage("抱歉！您的设备不支持拍照")
            }
            
        } else {
            
            var infoDictionary: [AnyHashable: Any] = Bundle.main.infoDictionary!
            let appName: String = (infoDictionary["CFBundleDisplayName"] as! String)
            let alert: UIAlertView = UIAlertView(title: "提示", message: "\(appName)没有权限读取您的相片。要赋予权限，请打开：设置>隐私>相机>\(appName)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "我知道了")
            alert.show()
        }
    }
    
    /// 通过照片库添加图片
    func browseFromLibrary() {
        
        if canLoadPhotoAlbum() {
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) || UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                imagePicker.sourceType = .photoLibrary
                let ctrl: UIViewController = self.delegate as! UIViewController
                ctrl.present(imagePicker, animated: true, completion: { () -> Void in
                })
            } else {
                BFunction.shared.showErrorMessage("抱歉！您的相册内没有图片")
            }
            
        } else {
            var infoDictionary: [AnyHashable: Any] = Bundle.main.infoDictionary!
            let appName: String = (infoDictionary["CFBundleDisplayName"] as! String)
            let alert: UIAlertView = UIAlertView(title: "提示", message: "\(appName)没有权限读取您的相片。要赋予权限，请打开：设置>隐私>照片>\(appName)", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "我知道了")
            alert.show()
        }
    }
    
    /// 是否有打开相机相册的权限
    func canLoadPhotoAlbum() -> Bool {
        
        switch ALAssetsLibrary.authorizationStatus() {
            
        case ALAuthorizationStatus.authorized:
            NSLog("ALAuthorizationStatusAuthorized")
            return true
        case ALAuthorizationStatus.denied:
            NSLog("ALAuthorizationStatusDenied")
            return false
        case ALAuthorizationStatus.notDetermined:
            NSLog("ALAuthorizationStatusNotDetermined")
            return true
        case ALAuthorizationStatus.restricted:
            NSLog("ALAuthorizationStatusRestricted")
            return false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let img = info[UIImagePickerControllerEditedImage] as? UIImage
        self.delegate?.delegatePhotoLibraryManager(self, didPickedImage: img)
        
        let ctrl: UIViewController? = self.delegate as? UIViewController
        ctrl?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let ctrl: UIViewController = self.delegate as! UIViewController
        ctrl.dismiss(animated: true, completion: nil)
    }
}
