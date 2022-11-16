//
//  PC_ChooseImageInCameraViewController.swift
//  SH_SS
//
//  Created by Hung on 7/30/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PC_ChooseImageInCameraViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UICollectionViewDelegate,
UICollectionViewDataSource {


    @IBOutlet weak var imgColectionView: UICollectionView!
    var imgArray = [UIImage]()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        ShowCamera()
        //imgColectionView.delegate = self
        //imgColectionView.dataSource = self
        
        let layout = self.imgColectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.imgColectionView.frame.width - 20 ) / 1.6 , height: self.imgColectionView.frame.height / 2)
        
        
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        let editImage    = UIImage(named: "icons8-plus-24")!
        
        let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action:  #selector(ShowCamera))
        let saveButton   = UIBarButtonItem(title: "Lưu lại", style: .plain, target: self, action: #selector(UpLoadImg))
        
        navigationItem.rightBarButtonItems = [saveButton,editButton]
    }
    
    //Hiển thị camera
    @objc func ShowCamera()
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
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                imagePicker.cameraDevice = .rear
                
                self.present(imagePicker, animated:true,completion:nil)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pigkedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.imgArray.append(pigkedImage)
            
            imgColectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func UpLoadImg() {
        if imgArray.count == 0
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
            // create the alert
            let alert = UIAlertController(title: "Thông  báo", message: "Bạn có đồng ý tải ảnh không ?", preferredStyle: UIAlertController.Style.alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                self.addSavingPhotoView()
                DispatchQueue.global(qos: .default).async {
                    self.func_UploadImage()
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                }
            }
            alert.addAction(OKAction)
            let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(cancelAction)
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    //Upload image to server
    func func_UploadImage()
    {
        var err = false
        let arrayCount = imgArray.count
        for itemCount in 0 ..< arrayCount
        {
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
            let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? ""
            
            let image = (imgArray[itemCount] as UIImage)
            let img = image.jpegData(compressionQuality: 0.0)
            let boundary = UUID().uuidString
            let filename = "avatar.jpg"
            let userName :String = UserDefaults.standard.string(forKey: "UserName")!
            var urlRequest = URLRequest(url: URL(string: "http://appapi.sunhouse.com.vn/api/Document/PCUploadImage?cmp_wwn=\(cmp_wwn)&username=\(userName)&udate=\(udate)")!)
            
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
                        if itemCount == arrayCount - 1
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    // create the alert
                                    let alert = UIAlertController(title: "Thông báo", message: "Tải ảnh thành công", preferredStyle: UIAlertController.Style.alert)
                                    
                                    // add an action (button)
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
    func back()
    {
        navigationController?.popViewController( animated: true)
    }
    
    //Show box activity
    var container: UIView = UIView()
    func addSavingPhotoView() {
        
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 50, height: 50))
        boxView.backgroundColor = UIColor.black
        boxView.alpha = 1
        boxView.layer.cornerRadius = 10
        boxView.center = view.center
        boxView.translatesAutoresizingMaskIntoConstraints = false
        
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        boxView.addSubview(activityView)
        container.addSubview(boxView)
        view.addSubview(container)
        activityView.startAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImgPC", for: indexPath) as! ImageReportCollectionViewCell
        cell.img.image = self.imgArray[indexPath.row]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn xoá ảnh này không", preferredStyle: UIAlertController.Style.alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
            self.imgArray.remove(at: indexPath.item)
            self.imgColectionView.deleteItems(at: [indexPath])
        }
        alert.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancelAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        return
        
    }
}
