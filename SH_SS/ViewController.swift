//
//  ViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 2/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    var flagCheckVesion : Bool = false//Check vesion update
    @IBAction func btnLogin(_ sender: Any) {
        let user =  txtUser.text
        let pass = txtPass.text
        if(user == "" || pass == "" )
        {
            let alert = UIAlertController(title: "Cảnh báo", message: "Tài khoản và mật khẩu không để trống", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        func_checkLogin(_user: user!, _pass: pass!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        fucn_changeBackground()
        
       //Hiển thị thông báo update vesion
        if flagCheckVesion == true
        {
            alertUpdateVesion()
        }
        
    }
    //Thông báo update vesion
    func alertUpdateVesion()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                // create the alert
                let alert = UIAlertController(title: "Thông báo", message: "Bạn vui lòng cập nhật phiên bản mới để trải nghiệm tính năng", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                let actionUpdate = UIAlertAction(title: "Cập nhật", style: .destructive, handler:{ (action) in
                    let AppstoreURL = URL(string: "itms-apps://itunes.apple.com/vn/app/id1467130384")!
                    UIApplication.shared.open(AppstoreURL, options: [:], completionHandler: nil)
                })
                alert.addAction(actionUpdate)
                // show the alert
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }


    //Change background is image
    func fucn_changeBackground()
    {
        let imageView = UIImageView(image: UIImage(named: "panel.png")!)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(imageView, at: 0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 2
        btnLogin.layer.borderColor = UIColor.white.cgColor
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
    
    //Check login
    func func_checkLogin(_user : String, _pass :String)
    {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        //activity
        addSavingPhotoView()
        
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        //let  model : String = UIDevice.modelName
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/Account/Login?appid=351A66D7-9640-442D-9DAB-69DA59631F06&username=\(_user)&password=\(_pass)&deviceinfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        //making the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let names = json?["FullName"] as? String {
                    let User = json?["UserName"] as? String
                    let TokenKey = json?["AccessToken"] as? String
                   
                    UserDefaults.standard.setValue(User, forKey: "UserName")
                    UserDefaults.standard.setValue(names, forKey: "FullName")
                    UserDefaults.standard.setValue(TokenKey, forKey: "AccessToken")
                     let jobtitle = json?["job_title"] as? String
                    UserDefaults.standard.setValue(jobtitle, forKey: "jobtitle")
                    
                    DispatchQueue.main.async(execute: self.func_moveController)
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.view.removeFromSuperview()
                    }
                }
                else if let errorMessage = json?["messenger"] as? String
                {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                    }
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            // create the alert
                            let alert = UIAlertController(title: "Cảnh báo", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    //Move on viewindex
    func func_moveController()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController")
        self.present(newViewController, animated: true, completion: nil)
    }
}
extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}
extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let youtubeRed = UIColor(hex: 0xe62117)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

