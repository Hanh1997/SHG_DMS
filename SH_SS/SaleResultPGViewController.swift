//
//  SaleResultPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class SaleResultPGViewController: UIViewController,ItemDelegate,UITextFieldDelegate {

    var  ArrItem = [Item]()
    var arrSeach = [Item]()
    @IBOutlet weak var InfoCmp: UILabel!
    @IBOutlet weak var InfoCreateDate: UILabel!
    
    @IBOutlet weak var div7: UIView!
    @IBOutlet weak var div6: UIView!
    @IBOutlet weak var div5: UIView!
    @IBOutlet weak var div4: UIView!
    @IBOutlet weak var div3: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div1: UIView!
    
    @IBOutlet weak var textfiledItemCode: UITextField!
    @IBOutlet weak var textfiledsaleprice: UITextField!
    @IBOutlet weak var textfiedlsalequantity: UITextField!
    @IBOutlet weak var textfiledstockquantity: UITextField!
    @IBOutlet weak var textfiledshowroomstock: UITextField!
    
    var itemCode : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        div1.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div2.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div3.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div4.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div5.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div6.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div7.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        textfiedlsalequantity.delegate = self
        textfiledsaleprice.delegate = self
        textfiledstockquantity.delegate = self
        textfiledshowroomstock.delegate = self
        
        let cmpwwn = UserDefaults.standard.string(forKey: "cmp_wwnPG")
        if(cmpwwn == nil)
        {
            DispatchQueue.main.async {
                // create the alert
                let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chọn điểm bán", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        else
        {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            InfoCmp.text =  UserDefaults.standard.string(forKey: "cmp_namePG")!
            InfoCreateDate.text = formatter.string(from: date)
        }
    }
    
    @IBAction func ChosseCmpForPG(_ sender: Any) {
        let vc : PopUpSeachItemPCViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopUpSeachItemPC") as? PopUpSeachItemPCViewController)!
        vc.cmp =  UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == textfiledsaleprice {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else  if textField == textfiedlsalequantity {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else if textField == textfiledshowroomstock {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else  if textField == textfiledstockquantity {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfiledItemCode.resignFirstResponder()
        textfiledsaleprice.resignFirstResponder()
        textfiedlsalequantity.resignFirstResponder()
        textfiledstockquantity.resignFirstResponder()
        textfiledshowroomstock.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ss" {
            let vc : PopUpSeachItemPCViewController = segue.destination as! PopUpSeachItemPCViewController
            vc.cmp = UserDefaults.standard.string(forKey: "cmp_wwnPG")!
            vc.delegate = self
        }
    }
    
    func addItem(data: String) {
        itemCode = data
        textfiledItemCode.text  = data
        textfiedlsalequantity.becomeFirstResponder()
    }
    @IBAction func SaveAction(_ sender: Any) {
        let check = checkDataSave()
        if !check {
            self.addSavingPhotoView()
            SaveDMSSaleOutForPC()
        }
    }
    
    func checkDataSave() -> Bool
    {
        var error = false
        let salequantity  = textfiedlsalequantity.text
        let saleprice = textfiledsaleprice.text
        let stockquantity  = textfiledstockquantity.text
        let showroomstock = textfiledshowroomstock.text
        let title = "Thông báo"
        var message = ""
        if (itemCode.isEmpty) {
            error  = true
            message += "Bạn chưa chọn mã hàng"
            alertWithTitleNotForcus(title: title, message: message, ViewController: self)
        }
        else if (salequantity?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập số lượng"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.textfiedlsalequantity)
        }
        else if (saleprice?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập giá bán"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.textfiledsaleprice)
        }
        else if (stockquantity?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập tồn kho"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.textfiledstockquantity)
        }
        else if (showroomstock?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập trưng bày"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.textfiledshowroomstock)
        }
        return error
    }

    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    func alertWithTitleNotForcus(title: String!, message: String, ViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
    
    func SaveDMSSaleOutForPC()
    {
        textfiledsaleprice.resignFirstResponder()
        textfiedlsalequantity.resignFirstResponder()
        textfiledstockquantity.resignFirstResponder()
        textfiledshowroomstock.resignFirstResponder()
        
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let datenow = formatter.string(from: date)
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwnPG")!
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        let salequantity : String = textfiedlsalequantity.text!
        let saleprice : String = textfiledsaleprice.text!
        let stockquantity : String =  textfiledstockquantity.text!
        let showroomstock : String = textfiledshowroomstock.text!
        // create the request
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/SaveDMSSaleOutForPC/id?username=\(userLogin)&sdate=\(datenow)&cmp_wwn=\(cmp)&itemcode=\(itemCode)&saleprice=\(saleprice)&salequantity=\(salequantity)&stockquantity=\(stockquantity)&showroomstock=\(showroomstock)"
        
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
                            self.textfiedlsalequantity.text = ""
                            self.textfiledsaleprice.text = ""
                            self.textfiledshowroomstock.text = ""
                            self.textfiledstockquantity.text = ""
                            self.textfiledItemCode.text = ""
                            self.itemCode = ""
                            self.activityView.stopAnimating()
                            self.container.removeFromSuperview()
                        }
                        
                        DispatchQueue.main.async {
                            self.short(self.view, txt_msg: "Lưu thành công")
                        }
                    }
                    else if chek == "ERR"
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                
                                self.activityView.stopAnimating()
                                self.container.removeFromSuperview()
                                
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
                                
                                self.activityView.stopAnimating()
                                self.container.removeFromSuperview()
                                
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        
                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                        
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
        }
        task.resume()
    }
    
    var container: UIView = UIView()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
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
    open func short(_ view: UIView,txt_msg:String) {
        self.setup(view,txt_msg: txt_msg)
        //Animation
        UIView.animate(withDuration: 1, animations: {
            self.overlayView.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.overlayView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    DispatchQueue.main.async(execute: {
                        self.overlayView.alpha = 0
                        self.lbl.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                    })
                })
            }
        }
    }
}

