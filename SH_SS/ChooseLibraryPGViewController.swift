//
//  ChooseLibraryPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class ChooseLibraryPGViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource	 {

    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var imageColectionView: UICollectionView!
    
    override func viewDidLoad() {
         ChooseLibrary()
        super.viewDidLoad()
        
        imageColectionView.delegate = self
        imageColectionView.dataSource = self
        
        let layout = self.imageColectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.imageColectionView.frame.width - 20 ) / 1.6 , height: self.imageColectionView.frame.height / 2)
        
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.PhotoArray.removeAll()
        self.perform(#selector(ChooseLibraryPGViewController.getAllImages), with: nil, afterDelay: 0.1)
    }
    
    @IBAction func btnLibrary(_ sender: Any) {
        
        ChooseLibrary()
    }
    
    func ChooseLibrary()
    {
        let cmp_wwn :String = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? ""
        if cmp_wwn.isEmpty
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chọn điểm bán", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        else
        {
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 100
            
            bs_presentImagePickerController(vc, animated: true,
                                            select: { (asset: PHAsset) -> Void in
                                                
            }, deselect: { (asset: PHAsset) -> Void in
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                
            }, finish: { (assets: [PHAsset]) -> Void in
                for i in 0..<assets.count
                {
                    self.SelectedAssets.append(assets[i])
                }
            }, completion: nil)
        }
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        if PhotoArray.count == 0
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chọn ảnh từ thư viện", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông  báo", message: "Bạn có đồng ý tải ảnh không ?", preferredStyle: UIAlertController.Style.alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                        self.addSavingPhotoView(_titleActivity: "Tải ảnh")
                        self.func_UploadImage()
                    }
                    alert.addAction(OKAction)
                    let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(cancelAction)
                    
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    
    @IBOutlet weak var btnUploadImg: UIButton!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImgCollectionViewCell
        cell.imgReport.image = self.PhotoArray[indexPath.row]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn bỏ chọn ảnh này không", preferredStyle: UIAlertController.Style.alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
            self.PhotoArray.remove(at: indexPath.item)
            self.imageColectionView.deleteItems(at: [indexPath])
            self.SelectedAssets.remove(at: indexPath.item)
        }
        alert.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancelAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    //Upload image to server
    func func_UploadImage()
    {
        var err = false
        let arrayCount = PhotoArray.count
        let dispatchGroup = DispatchGroup()
        for itemCount in 0 ..< arrayCount
        {
            dispatchGroup.enter()
            if(err == true)
            {
                break
            }
            let username = "trieupv"
            let password = "phamtrieu"
            let login = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
            let base64Login = login.base64EncodedString()
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let  udate = formatter.string(from: date)
            let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? ""
            
            let image = (PhotoArray[itemCount] as UIImage)
            let img = image.jpegData(compressionQuality: 0.0)
            let boundary = UUID().uuidString
            let filename = "avatar.jpg"
            let userName :String = UserDefaults.standard.string(forKey: "UserName")!
            var urlRequest = URLRequest(url: URL(string: "http://appapi.sunhouse.com.vn/api/Document/PCRoundUploadImage?cmp_wwn=\(cmp_wwn)&username=\(userName)&udate=\(udate)")!)
            
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(img!)
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? NSDictionary
                    let ResponseStatus = json?["ResponseStatus"] as? String
                    if ResponseStatus == "OK"
                    {
                        dispatchGroup.leave()
                        if itemCount == arrayCount - 1
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    // create the alert
                                    let alert = UIAlertController(title: "Thông báo", message: "Tải ảnh thành công", preferredStyle: UIAlertController.Style.alert)
                                    
                                    let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                        self.back()
                                    })
                                    // add an action (button)
                                    alert.addAction(actionback)
                                    
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                    return
                                }
                            }
                            DispatchQueue.main.async {
                                self.boxView.removeFromSuperview()
                            }
                            
                        }
                    }
                    else if ResponseStatus == "ERR"
                    {
                        err = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                        DispatchQueue.main.async {
                            self.boxView.removeFromSuperview()
                        }
                    }
                    else
                    {
                        err = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                self.boxView.removeFromSuperview()
                                //self.Out_btnchechIn.isEnabled = true
                                // create the alert
                                let alert = UIAlertController(title: "Cảnh báo", message: "Lỗi uploadfile", preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                    }
                    
                    
                } catch _ as NSError {
                    err = true
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.boxView.removeFromSuperview()
                            // create the alert
                            let alert = UIAlertController(title: "Cảnh báo", message: "Lỗi uploadfile", preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }).resume()
        }
    }
    //Show box activity
    func addSavingPhotoView(_titleActivity : String) {
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = _titleActivity
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    @objc func getAllImages() -> Void {
        
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 1500 , height: 1000), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.PhotoArray.append(thumbnail)
            }
        }
        imageColectionView.reloadData()
    }
    func back()
    {
        navigationController?.popViewController( animated: true)
    }
}
