//
//  ReportErrorPCRoundViewController.swift
//  SH_SS
//
//  Created by Hung on 5/26/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class ReportErrorPCRoundViewController:
UIViewController,ItemDelegate,TypeErrorDelegate,DayDelegate,UICollectionViewDataSource,UICollectionViewDelegate,
    UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate
{

    var arrType = [NGType]()
    var arrNGtype = ["NGItem","NGDebt"]
    
    func addDay(data: String) {
        produceDate = data
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from: data)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateF  = dateFormatter.string(from: date!)

        textFieldProduceDate.text = dateF
    }

    @IBOutlet weak var textFieldNGitem: UITextField!
    @IBOutlet weak var textFieldImage: UITextField!
    @IBOutlet weak var textFieldProduceDate: UITextField!
    @IBOutlet weak var textFieldTypeError: UITextField!
    @IBOutlet weak var textfieldItemCode: UITextField!
    @IBOutlet weak var ChosseTypeError: UIButton!
    @IBOutlet weak var ChosseItem: UIButton!
    @IBOutlet weak var ChoseDay: UIButton!
    @IBOutlet weak var ChoseImage: UIButton!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var txtQuantity: UITextField!

 
    @IBOutlet weak var div7: UIView!
    @IBOutlet weak var div1: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div6: UIView!
    @IBOutlet weak var div5: UIView!
    @IBOutlet weak var div3: UIView!
    @IBOutlet weak var div4: UIView!
    
    var ItemCode  : String = ""
    var typeError : String = ""
    var ngitem : String = ""
    var produceDate : String  = ""
    var recordid : String = ""
    var arrayPhoto = [UIImage]()
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var boxView = UIView()
    var monthPicker = UIPickerView()
    var picker = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GetListNGReason()
        //div1.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div7.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div2.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div3.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div4.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div5.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        
        let itemSize = UIScreen.main.bounds.width / 3 - 3
        let layout = self.imageCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.itemSize = CGSize(width: itemSize, height:  itemSize)
        
        self.hideKeyboardWhenTappedAround()
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        txtQuantity.delegate = self
    }
    @IBAction func ChosseItemAction(_ sender: Any) {
        let vc : PopUpSeachItemPCViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopUpSeachItemPC") as? PopUpSeachItemPCViewController)!
        vc.cmp =  UserDefaults.standard.string(forKey: "cmp_wwn") ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == txtQuantity {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }

        return true
    }
    @IBAction func TypeErrorAction(_ sender: Any) {

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
        monthPicker = UIPickerView(frame: CGRect(x: 0, y: barAccessory.frame.height, width: view.frame.width, height: picker.frame.height-barAccessory.frame.height))
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthPicker.backgroundColor = UIColor.white
        picker.addSubview(monthPicker)
        self.view.addSubview(picker)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrType[row].value
    }
    
    @objc func removeview()
    {
        self.picker.removeFromSuperview()
    }
    @objc func Done()
    {
        let index = monthPicker.selectedRow(inComponent: 0)
        let titleType : String = arrType[index].value
        textFieldTypeError.text = titleType
        typeError = arrType[index].key
        self.picker.removeFromSuperview()
    }

    func addError(data: String) {
        typeError = data
        textFieldTypeError.text = data
    }
    
    func addItem(data: String) {
        ItemCode = data
        textfieldItemCode.text = data
    }

    @IBAction func SaveAction(_ sender: Any) {
        arrPathImage = []
        let check = checkDataSave()
        if !check {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn lưu lại hay không?", preferredStyle: UIAlertController.Style.alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                        self.addSavingPhotoView(_titleActivity: "Tải ảnh")
                        self.recordid = UUID().uuidString
                        self.func_UploadImage(recordid: self.recordid)
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
    
    //Danh sách loại lỗi
    func GetListNGReason()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListNGReason")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                            let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                            for dic in JsonData
                            {
                                self.arrType.append(NGType(dic))
                            }
                            DispatchQueue.main.sync {
                                self.monthPicker.reloadAllComponents()
                            }
                        
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
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
    @IBAction func ChosseImage(_ sender: Any) {
        OpenLibrary()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueSeachItemPC" {
            let vc : PopUpSeachItemPCViewController = segue.destination as! PopUpSeachItemPCViewController
            vc.delegate = self
        }
        else if segue.identifier == "segueSeachErrorPG" {
            let vc : PopUpSeachErrorPGViewController = segue.destination as! PopUpSeachErrorPGViewController
            vc.delegate = self
        }
        else if segue.identifier == "segueChosseDayPG" {
            let vc : PopupChosseDayPGViewController = segue.destination as! PopupChosseDayPGViewController
            vc.delegate = self
        }
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
            if self.PhotoArray.count > 0
            {
                let  title :String = "\(self.PhotoArray.count) Ảnh"
                self.textFieldImage.text = title
            }

        }, completion: nil)
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                // create the alert
                let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn lưu lại hay không?", preferredStyle: UIAlertController.Style.alert)
                
                // Create OK button
                let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                    self.addSavingPhotoView(_titleActivity: "Tải ảnh")
                    let recordid = UUID().uuidString
                    self.func_UploadImage(recordid: recordid)
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
    
    func checkDataSave() -> Bool
    {
        var error = false
        let quantity = txtQuantity.text
        let  description = textDescription.text
        let image = PhotoArray.count
        var message = ""
        if (ItemCode.isEmpty)
        {
            error  = true
            message += "Bạn chưa chọn mã hàng"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        else if (quantity?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập số lượng"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if (typeError.isEmpty)
        {
                error  = true
                message += "Bạn chưa  chọn loại lỗi"
                self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if (description?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập mô tả"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        if (produceDate.isEmpty)
        {
            error  = true
            message += "Bạn chưa chọn ngày sản xuất"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
         if (image < 3)
        {
            error  = true
            message += "Bạn phải chọn tối thiểu 3 ảnh"
            self.alertWithTitle(title: title, message: message, ViewController: self)
        }
        return error
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            //toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    
    //Upload image to server
    var arrPathImage : [String] = []
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
                        //let itemsArray: NSArray   = json!.object(forKey: "ResponseData") as! NSArray
                           DispatchQueue.main.async {
                                if itemCount == arrayCount - 1
                                {
                                    self.SaveDMSNGItems()
                                    DispatchQueue.main.async {
                                        self.boxView.removeFromSuperview()
                                    }
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
                            self.boxView.removeFromSuperview()
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
    
    var sdate : String = ""
    //Danh sách itemcode theo điểm bán PC ROund
    func SaveDMSNGItems()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwn")!
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        
        let Quantity : String = txtQuantity.text!
        let Descrip : String = textDescription.text!
        let urlString  =  "http://appapi.sunhouse.com.vn/api/DMS/SaveDMSNGItems/\(recordid)?ngtype=\("NGItem")&cmp_wwn=\(cmp)&itemcode=\(ItemCode)&quantity=\(Quantity)&producedate=\(produceDate)&description=\(Descrip)&reason=\(typeError)&username=\(userLogin)&ngItemGroup=&ngItemErrorGroup="
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        DispatchQueue.main.async {
                            self.boxView.removeFromSuperview()
                        }
                        
                        DispatchQueue.main.async {
                            self.textfieldItemCode.text = ""
                            self.txtQuantity.text = ""
                            self.textFieldTypeError.text = ""
                            self.textFieldProduceDate.text = ""
                            self.textDescription.text = ""
                            self.textFieldImage.text = ""
                            
                            self.ItemCode = ""
                            self.typeError = ""
                            self.produceDate = ""
                            self.PhotoArray = []
                            self.imageCollection.reloadData()
                            
                            short(self.view, txt_msg: "Lưu thành công")
                        }
                    }
                    else if chek == "ERR"
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
                            self.boxView.removeFromSuperview()
                        }
                    }
                    else
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
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
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func appendPath(itemsArray :NSArray)
    {
        dispatchSemaphore.wait()
        for item in itemsArray as! [Dictionary<String, AnyObject>]
        {
            let keyData : String  = (item["Key"] as? String)!
            if keyData == "SavedFile"
            {
                let value : String = (item["Value"] as? String)!
                arrPathImage.append(value)
                break
            }
        }
        dispatchSemaphore.signal()
    }
}

var overlayView = UIView()
var backView = UIView()
var lbl = UILabel()
func setup(_ view: UIView,txt_msg:String)
{
    let white = UIColor ( red: 1/255, green: 0/255, blue:0/255, alpha: 0.0 )
    
    backView.frame = CGRect(x: 0, y: 0, width: 100 , height: 200)
    backView.center = view.center
    backView.backgroundColor = white
    view.addSubview(backView)
    
    overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 50)
    overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
    overlayView.backgroundColor = UIColor.black
    overlayView.clipsToBounds = true
    overlayView.layer.cornerRadius = 10
    overlayView.alpha = 0
    
    lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
    lbl.numberOfLines = 0
    lbl.textColor = UIColor.white
    lbl.center = overlayView.center
    lbl.text = txt_msg
    lbl.textAlignment = .center
    lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
    overlayView.addSubview(lbl)
    
    view.addSubview(overlayView)
}

public func short(_ view: UIView,txt_msg:String) {
    setup(view,txt_msg: txt_msg)
    //Animation
    UIView.animate(withDuration: 1, animations: {
        overlayView.alpha = 1
    }) { (true) in
        UIView.animate(withDuration: 1, animations: {
            overlayView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                DispatchQueue.main.async(execute: {
                    overlayView.alpha = 0
                    lbl.removeFromSuperview()
                    overlayView.removeFromSuperview()
                    backView.removeFromSuperview()
                })
            })
        }
    }
}



extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}

public struct  NGType {
    var key : String
    var value : String
    var ParrentID : String
    init(_ dictionary: [String: Any]) {
        self.key = dictionary["key"] as? String ?? ""
        self.value = dictionary["value"] as? String ?? ""
        self.ParrentID = dictionary["ParrentID"] as? String ?? ""
    }
}
