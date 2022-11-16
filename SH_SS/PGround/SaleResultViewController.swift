//
//  SaleResultViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 4/17/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class SaleResultViewController: UIViewController,UITabBarDelegate,UITextFieldDelegate,ItemDelegate{
    @IBOutlet weak var txtTK: UITextField!
    @IBOutlet weak var txtTB: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtCmp: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var btnChosseItem: UIButton!
    @IBOutlet weak var div3: UIView!
    @IBOutlet weak var div1: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div7: UIView!
    @IBOutlet weak var div6: UIView!
    @IBOutlet weak var div5: UIView!
    @IBOutlet weak var div4: UIView!
    @IBOutlet weak var textfiledItemCode: UITextField!
    
    var istable = false
    var  ArrItem = [Item]()
    var arrSeach = [Item]()
    var itemCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        div1.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div2.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div3.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div4.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div5.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div6.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div7.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        let cmpwwn = UserDefaults.standard.string(forKey: "cmp_wwn")
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
     
            txtCmp.text =  UserDefaults.standard.string(forKey: "cmp_name")!
            txtDate.text = formatter.string(from: date)
            
            txtTK.delegate = self
            txtTB.delegate = self
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == txtTK {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        else  if textField == txtTB {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @IBAction func SaveAction(_ sender: Any) {
        let check = checkDataSave()
        if !check {
            self.addSavingPhotoView()
            SaveDMSSaleOutForPCRound()
        }
    }

    func addItem(data: String) {
        itemCode = data
        textfiledItemCode.text  = data

        txtTK.becomeFirstResponder()
    }

    @IBAction func ChosseCmpAction(_ sender: Any) {
        let vc : PopUpSeachItemPCViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopUpSeachItemPC") as? PopUpSeachItemPCViewController)!
        vc.cmp =  UserDefaults.standard.string(forKey: "cmp_wwn") ?? ""
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "seguePGChosseItem" {
            let vc : PopUpSeachItemPCViewController = segue.destination as! PopUpSeachItemPCViewController
            vc.delegate = self
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func checkDataSave() -> Bool
    {
        var error = false
        let TK = txtTK.text
        let TB = txtTB.text
        let title = "Thông báo"
        var message = ""
        if (itemCode.isEmpty) {
            error  = true
            message += "Bạn chưa chọn mã hàng"
           alertWithTitleNotForcus(title: title, message: message, ViewController: self)
        }
        else if (TK?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập tồn kho"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtTK)
        }
        else if (TB?.isEmpty)!
        {
            error  = true
            message += "Bạn chưa nhập trưng bày"
            self.alertWithTitle(title: title, message: message, ViewController: self, toFocus:self.txtTB)
        }
        return error
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtTB.resignFirstResponder()
        txtTK.resignFirstResponder()
    }
   
    func addImg( text : UITextField, addimg img:UIImage)
    {
        let leftimg = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftimg.image = img
        text.leftView = leftimg
        text.leftViewMode = .always
    }
    
    //Danh sách itemcode theo điểm bán PC ROund
    func SaveDMSSaleOutForPCRound()
    {
        txtTB.resignFirstResponder()
        txtTK.resignFirstResponder()
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let datenow = formatter.string(from: date)
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwn")!
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        let stockquantity : Int =  Int(txtTK.text!)!
        let showroomstock : Int = Int(txtTB.text!)!
        // create the request

        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/SaveDMSSaleOutForPCRound?sdate=\(datenow)&cmp_wwn=\(cmp)&itemcode=\(itemCode)&stockquantity=\(stockquantity)&showroomstock=\(showroomstock)&username=\(userLogin)"
        
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
                            self.txtTK.text = ""
                            self.txtTB.text = ""
                            self.textfiledItemCode.text = ""
                            //self.btnChosseItem.setTitle("Chưa chọn", for: .normal)
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
    
    open func long(_ view: UIView,txt_msg:String) {
        self.setup(view,txt_msg: txt_msg)
        //Animation
        UIView.animate(withDuration: 2, animations: {
            self.overlayView.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 2, animations: {
                self.overlayView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 2, animations: {
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

class Item {
    var ItemCode : String
    var ItemName : String
    
    init(_ dictionary: [String: Any]) {
        self.ItemCode = dictionary["ItemCode"] as? String ?? ""
        self.ItemName = dictionary["ItemName"] as? String ?? ""
    }
}

extension UITextField
{
    func setPadding()
    {
        let paddingView = UIView(frame: CGRect(x: 0,y: 0, width: 5, height: self.frame.height / 2))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setborderButon()
    {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
