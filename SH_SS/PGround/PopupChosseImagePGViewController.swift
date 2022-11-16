//
//  PopupChosseImagePGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/27/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class PopupChosseImagePGViewController: UIViewController {

    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var delegate : ImageDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenLibrary()
    }
    
    func OpenLibrary()
    {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 3
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            }
            
            for i in 0..<self.SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: self.SelectedAssets[i], targetSize: CGSize(width: 150 , height: 100), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.PhotoArray.append(thumbnail)
            }
            self.delegate?.addImage(data: self.PhotoArray)
            self.navigationController?.popViewController( animated: true)
            
        }, completion: nil)
    }
}

protocol ImageDelegate {
    func addImage(data:Array<Any>)
}
