//
//  PunishViewController.swift
//  SH_SS
//
//  Created by Hung on 2/3/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class PunishViewController: UIViewController,UserDelegate,PunishCategoryDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func PunishCategoryAdd(Id: String, PunishGroupName: String, SubtractLv1: Double, SubtractLv2: Double, SubtractLv3: Double){
        txtPunishCategory.text = PunishGroupName
        PunishCatId = Id
        arrMoney = []
        arrMoney.append(SubtractLv1)
        arrMoney.append(SubtractLv2)
        arrMoney.append(SubtractLv3)
        
        self.moneyPicker.reloadAllComponents()
    
        self.txtMission.text = ""
        self.txtMoney.text = ""
    
        self.SubtractMoney = 0
        
        self.PhotoArray = []
        self.imageCollection.reloadData()
    }
    

    func GetUser(UserName: String, FullName: String, job_title: String, costcenter: String) {
        txtUser.text = FullName
        EmpTarget = UserName
        jobtitle = job_title
        

        self.txtPunishCategory.text = ""
        self.txtMission.text = ""
        self.txtMoney.text = ""
        
        self.PunishCatId = ""
        self.SubtractMoney = 0
        
        self.PhotoArray = []
        self.imageCollection.reloadData()
    }
    
    var PunishCatId : String = ""
    var EmpTarget : String = ""
    var arrMoney = [Double]()
    var jobtitle : String = ""
    @IBOutlet weak var txtMoney: UITextField!
    @IBOutlet weak var txtMission: UITextField!
    @IBOutlet weak var txtPunishCategory: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var div1: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div3: UIView!
    @IBOutlet weak var div4: UIView!
    @IBOutlet weak var div5: UIView!
    @IBOutlet weak var div6: UIView!
    @IBOutlet weak var div9: UIView!
    @IBOutlet weak var div10: UIView!
    @IBOutlet weak var div7: UIView!
    @IBOutlet weak var div8: UIView!
    var picker = UIView()
    var moneyPicker = UIPickerView()
    var PhotoArray = [UIImage]()
    var arrPathImage : [String] = []
    var SelectedAssets = [PHAsset]()
    var recordid : String = ""
    var activityView = UIActivityIndicatorView()
    @IBOutlet weak var imageCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        div2.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div3.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div4.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div6.addBorder(.bottom, color: .lightGray, thickness: 0.5)

        self.hideKeyboardWhenTappedAround()
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        let saveButton   = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(SaveAction))
        
        navigationItem.rightBarButtonItems = [saveButton]
    }
    

    @IBAction func ChosseImage(_ sender: Any) {
        OpenLibrary()
    }

    
    //Chọn đối tượng
    @IBAction func chooseUser(_ sender: Any) {
        let vc : ListInterActiveUserViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListInterActiveUserViewController") as? ListInterActiveUserViewController)!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Chọn nhóm lỗi
    @IBAction func choosePunishCategory(_ sender: Any) {
        let vc : PunishCategoryViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PunishCategoryViewController") as? PunishCategoryViewController)!
        vc.delegate = self
        vc.jobtitle = jobtitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellErrorImg", for: indexPath) as! ImageErrorCollectionViewCell
        cell.Image.image = self.PhotoArray[indexPath.row]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
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
            self.PhotoArray = []
            self.arrPathImage = []
            self.SelectedAssets = []
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
            self.imageCollection.reloadData()
            
        }, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 20.0)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = getNumberWithFormat(arrMoney[row] as NSNumber, format: "###,###") + " VNĐ"
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrMoney.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(arrMoney[row])
    }

    @IBAction func ActionChooseMoney(_ sender: Any) {
        
        picker = UIView(frame: CGRect(x: 0, y: view.frame.height - 260, width: view.frame.width, height: 260))
        
        // Toolbar
        let btnDone = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: self, action: #selector(self.Done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ bỏ", style: .plain, target: self, action: #selector(self.removeview))
        
        let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: picker.frame.width, height: 44))
        barAccessory.barTintColor = Colors.lightGrey
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = false
        barAccessory.items = [cancelButton, spaceButton, btnDone]
        picker.addSubview(barAccessory)
        
        // Month UIPIckerView
        moneyPicker = UIPickerView(frame: CGRect(x: 0, y: barAccessory.frame.height, width: view.frame.width, height: picker.frame.height-barAccessory.frame.height))
        moneyPicker.delegate = self
        moneyPicker.dataSource = self
        moneyPicker.backgroundColor = UIColor.gray
        picker.addSubview(moneyPicker)
        
        moneyPicker.setValue(UIColor.white, forKey: "textColor")
        self.view.addSubview(picker)
    }
    
    @objc func removeview()
    {
        self.picker.removeFromSuperview()
    }
    var SubtractMoney :Double = 0
    @objc func Done()
    {
        let index = moneyPicker.selectedRow(inComponent: 0)
        txtMoney.text = getNumberWithFormat(arrMoney[index] as NSNumber, format: "###,###") + " VNĐ"
        SubtractMoney = arrMoney[index]
        self.picker.removeFromSuperview()
    }
    
    func checkDataSave() -> Bool
    {
        var error = false
        var message = ""
        let PunishReason = txtMission.text
        if (EmpTarget.isEmpty)
        {
            error  = true
            message += "Bạn chưa chọn đối tượng"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if (PunishCatId.isEmpty)
        {
            error  = true
            message += "Bạn chưa chọn nhóm lỗi"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if (PunishReason == "")
        {
            error  = true
            message += "Bạn chưa nhập lý do"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if jobtitle == "NVBHST" && SubtractMoney == 0
        {
            error  = true
            message += "Bạn chưa chọn mức phạt"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        return error
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.cancel,handler: {_ in
         
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    //Lưu thông tin đánh giá 360
    @objc func SaveAction() {
        arrPathImage = []
        let check = checkDataSave()
        if !check {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn lưu lại hay không?", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(cancelAction)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                         self.recordid = UUID().uuidString
                         self.addSavingPhotoView()
                        if self.PhotoArray.count > 0
                        {
                            self.func_UploadImage(recordid: self.recordid)
                        }
                        else
                        {
                            self.SaveKPIPunish()
                        }
                      
                    }
                    alert.addAction(OKAction)
             
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    //Upload image to server
    private var dispatchSemaphore = DispatchSemaphore(value: 1)
    func func_UploadImage(recordid : String)
    {
        let arrayCount = PhotoArray.count
        for itemCount in 0 ..< arrayCount
        {
            let username = "trieupv"
            let password = "phamtrieu"
            let login = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
            let base64Login = login.base64EncodedString()
            let image = (PhotoArray[itemCount] as UIImage)
            let img = image.jpegData(compressionQuality: 0.0)
            let boundary = UUID().uuidString
            let r = arc4random()
            let filename = "image\(r).jpg"
            let userName :String = UserDefaults.standard.string(forKey: "UserName")!
            var urlRequest = URLRequest(url: URL(string: "http://appapi.sunhouse.com.vn/api/Document/UploadFile?appid=b4e56f2e-e1f1-4366-b678-7e23e157639a&username=\(userName)&filetype=image&recordid=\(recordid)")!)
            
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
                        DispatchQueue.main.async {
                            if itemCount == arrayCount - 1
                            {
                                self.SaveKPIPunish()
                            }
                        }
                        
                    }
                    else if ResponseStatus == "ERR"
                    {
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
                            self.activityView.stopAnimating()
                            self.container.removeFromSuperview()
                        }
                    }
                    else
                    {
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
    
    //Format number
    func getNumberWithFormat(_ number : NSNumber, format : String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.usesGroupingSeparator = true
        
        numberFormatter.positiveFormat = format
        return numberFormatter.string(from: number)!
    }
    
    var boxView = UIView()
    var container: UIView = UIView()
    //Show box activity
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
    
    //Lưu dữ liệu  đánh giá 360
    func SaveKPIPunish()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let PunishReason : String = txtMission.text ?? ""
        
        let parameters = "Id=\(recordid)&AllowPardon=0&EmpTarget=\(EmpTarget)&PunishReason=\(PunishReason)&PunishCatId=\(PunishCatId)&Pardoned=0&SubtractMoney=\(SubtractMoney)"
        let postData =  parameters.data(using: .utf8)
        
        var urlRequest = URLRequest(url: URL(string: "http://appapi.sunhouse.com.vn/api/KPI/SaveKPIPunish?loginUser=\(userLogin)")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = postData
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                    if(chek == "OK")
                    {
                        DispatchQueue.main.async {
                            // create the alert
                            let alert = UIAlertController(title: "Thông báo", message: "Lưu thành công", preferredStyle: UIAlertController.Style.alert)
                            
                            let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                
                                self.txtUser.text = ""
                                self.txtPunishCategory.text = ""
                                self.txtMission.text = ""
                                self.txtMoney.text = ""

                                
                                self.jobtitle = ""
                                self.EmpTarget = ""
                                self.PunishCatId = ""
                                self.SubtractMoney = 0
                                
                                self.PhotoArray = []
                                self.imageCollection.reloadData()
                            })
                            
                             alert.addAction(actionback)
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        
                        }
                    }
                    else
                    {
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
                }
            } catch let error as NSError{
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        // create the alert
                        let alert = UIAlertController(title: "Thông báo", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        })
        task.resume()
    }
}
