//
//  PCRoundBusinessViewController.swift
//  SH_SS
//
//  Created by Hung on 6/2/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PCRoundBusinessViewController: UIViewController,CmpDelegate {
    func GetCmp(data: String) {
        self.btnCmp.setTitle(data, for: .normal)
    }

    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var btnCmp: UIButton!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var btnResultReport: UIButton!
    @IBOutlet weak var btnImageReport: UIButton!
    @IBOutlet weak var btnReportError: UIButton!
    @IBOutlet weak var ViewContainer: UIView!
    
    var istable = false
    var cmp_wwn : String = ""
    var model = [StrCmp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCheckIn.leftImage(image: UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
        btnCheckOut.leftImage(image:UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
        btnResultReport.leftImage(image:UIImage(named: "icons8-finance-report-64")!, renderMode: .alwaysOriginal)
        btnImageReport.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
        btnCmp.leftImage(image:UIImage(named: "icons8-3d-farm-64")!, renderMode: .alwaysOriginal)
        btnReportError.leftImage(image:UIImage(named: "icons8-box-64")!, renderMode: .alwaysOriginal)
        
        btnCmp.setGradientBackground(colorOne: Colors.lightGrey, colorTwo: Colors.white)
        btnCheckIn.setGradientBackground(colorOne: Colors.red, colorTwo: Colors.white)
        btnCheckOut.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.white)
        btnResultReport.setGradientBackground(colorOne: Colors.green, colorTwo: Colors.white)
        btnImageReport.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.white)
        btnReportError.setGradientBackground(colorOne: Colors.brightOrange, colorTwo: Colors.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CheckCheciIn()
        self.GetListPCRoundUploadImage()
        self.GetListDataSaleOutForPCRound()
    }
    @IBAction func acbtnCheckOut(_ sender: UIButton) {
        sender.pulsate()
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let Latitude = UserDefaults.standard.double(forKey: "Latitude")
            let longitude =  UserDefaults.standard.double(forKey: "Longitude")
            
            let vc :  CheckOutViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOut") as? CheckOutViewController)!
            vc.cmp_wwn = cmp_wwn
            vc.LatCus =  Latitude
            vc.LongCus = longitude
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
        
    }
    @IBAction func ActionCheckIn(_ sender: UIButton) {
        sender.pulsate()
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let Latitude = UserDefaults.standard.double(forKey: "Latitude")
            let longitude =  UserDefaults.standard.double(forKey: "Longitude")
            
            let vc : CheckInViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckIn") as? CheckInViewController)!
            vc.cmp_wwn = cmp_wwn
            vc.LatCus =  Latitude
            vc.LongCus = longitude
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
    }
    @IBAction func AcbtnResultReport(_ sender: UIButton) {
        sender.pulsate()
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let vc : ListSaleResultViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListSaleResult") as? ListSaleResultViewController)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
    }
    @IBAction func ReportError(_ sender: UIButton) {
        sender.pulsate()
        
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let vc :  ListNGItemForPGViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListNGItemForPG") as? ListNGItemForPGViewController)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
    }
    
    @IBAction func acBtnImgReport(_ sender: UIButton) {
        sender.pulsate()
        
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let vc : ConfirmReportImgViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmReportImg") as? ConfirmReportImgViewController)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
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
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueChosseCmp" {
            let vc : ListCmpViewController = segue.destination as! ListCmpViewController

            vc.delegate = self
        }
    }

    func PassData()
    {
        let man2 : MapViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController)!
        //vc.userlatitude = userlatitude
        //vc.userlongitude = userlongitude
        self.navigationController?.pushViewController(man2, animated: true)
        self.navigationController?.isNavigationBarHidden = true;
        
    }
    
    func func_moveController()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CheckIn")
        //self.navigationController?.pushViewController(newViewController, animated: true)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    var listDataJson = [CheckIn]()
    var arrCheckIn = [CheckIn]()
    var arrCheckOut = [CheckIn]()
    //check xem đã checkin chưa
    func CheckCheciIn()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        let userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetCheckInData?cmp_wwn=\(cmp_wwn)&username=\(userName)&fromdate=\(udate)&todate=\(udate)")!
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
                        if JsonData.count > 0
                        {
                            for dic in JsonData
                            {
                                self.listDataJson.append(CheckIn(dic))
                            }
                            for str in self.listDataJson
                            {
                                let range = str.ActionCode.lowercased().range(of: "CheckIn", options: .caseInsensitive, range: nil, locale: nil)
                                
                                if range != nil
                                {
                                    self.arrCheckIn.append(str)
                                    break
                                }
                            }
                            
                            for str in self.listDataJson
                            {
                                let range = str.ActionCode.lowercased().range(of: "CheckOut", options: .caseInsensitive, range: nil, locale: nil)
                                
                                if range != nil
                                {
                                    self.arrCheckOut.append(str)
                                    break
                                }
                            }
                            
                            if (self.arrCheckIn.count > 0)
                            {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    DispatchQueue.main.async {
                                        self.btnCheckIn.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
                                        self.btnCheckIn.isEnabled = false
                                        self.btnImageReport.isEnabled = true
                                        self.btnResultReport.isEnabled = true
                                        self.btnCheckOut.isEnabled = true
                                        self.btnReportError.isEnabled = true
                                        
                                        self.btnImageReport.alpha = 1
                                        self.btnResultReport.alpha = 1
                                        self.btnCheckOut.alpha = 1
                                        self.btnReportError.alpha = 1
                                    }
                                }
                            }
                            if(self.arrCheckOut.count > 0)
                            {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    DispatchQueue.main.async {
                                        self.btnCheckOut.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
                                        self.btnCheckOut.isEnabled = false
                                    }
                                }
                            }
                            else
                            {
                                self.btnCheckOut.leftImage(image:UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
                                self.btnCheckOut.isEnabled = true
                            }
                        }
                        else
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    self.btnCheckOut.leftImage(image:UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
                                    self.btnCheckIn.leftImage(image:UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
                                    self.btnCheckIn.isEnabled = true
                                    self.btnImageReport.isEnabled = false
                                    self.btnResultReport.isEnabled = false
                                    self.btnCheckOut.isEnabled = false
                                     self.btnReportError.isEnabled = false
                                    
                                    
                                    self.btnImageReport.alpha = 0.5
                                     self.btnResultReport.alpha = 0.5
                                     self.btnCheckOut.alpha = 0.5
                                     self.btnReportError.alpha = 0.5
                                }
                            }
                        }
                    }
                    else
                    {
                        
                        self.btnCheckIn.isEnabled = true
                        self.btnCheckIn.leftImage(image:UIImage(named: "icons8-client-management-64")!, renderMode: .alwaysOriginal)
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    //Check xem đã báo cáo hình ảnh chưa
    func GetListPCRoundUploadImage()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        // create the request
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/Document/GetListPCRoundUploadImage?cmp_wwn=\(cmp_wwn)&username=\(userLogin)&udate=\(udate)"
        
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
                        let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                        if JsonData.count > 0
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    self.btnImageReport.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
                                }
                            }
                            
                        }
                        else
                        {
                           self.btnImageReport.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
                        }
                        
                    }
                    else if chek == "ERR"
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                self.btnImageReport.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                self.btnImageReport.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    //Check đã nhập kết quả chưa
    func GetListDataSaleOutForPCRound()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        // create the request
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/GetListDataSaleOutForPCRound?fromdate=\(udate)&todate=\(udate)&cmp_wwn=\(cmp_wwn)&username=\(userLogin)"
        
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
                        let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                        if JsonData.count > 0
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    self.btnResultReport.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
                                }
                            }
                        }
                        else
                        {
                            DispatchQueue.global(qos: .userInitiated).async {
                                DispatchQueue.main.async {
                                    self.btnResultReport.leftImage(image:UIImage(named: "icons8-finance-report-64")!, renderMode: .alwaysOriginal)
                                }
                            }
                            
                        }
                    }
                    else if chek == "ERR"
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                 self.btnResultReport.leftImage(image:UIImage(named: "icons8-finance-report-64")!, renderMode: .alwaysOriginal)
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
struct Colors {
    
    static let brightOrange     = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let red              = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    static let orange           = UIColor(red: 255.0/255.0, green: 175.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    static let blue             = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let green            = UIColor(red: 91.0/255.0, green: 197.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    static let darkGrey         = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    static let veryDarkGrey     = UIColor(red: 13.0/255.0, green: 13.0/255.0, blue: 13.0/255.0, alpha: 1.0)
    static let lightGrey        = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
    static let black            = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let white            = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}
extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        setImage(image.withRenderingMode(renderMode), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: image.size.width / 2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width * 2,bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.95
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0.1
        pulse.initialVelocity = 0.2
        pulse.damping = 0.1
        
        layer.add(pulse, forKey: "pulse")
    }
}

class ButtonGradient : UIButton {
    override func layoutSubviews() {
        
        let layer : CAGradientLayer = CAGradientLayer()
        let color0 = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let color1 = UIColor(red: 91.0/255.0, green: 197.0/255.0, blue: 159.0/255.0, alpha: 1.0).cgColor
        layer.frame = self.bounds
        //layer.frame.origin = CGPoint(x: 0, y: 0)
        layer.locations = [0.0,0.2,0.4,1.0]
        layer.startPoint = CGPoint(x: 1.0, y: 0.5)
        layer.endPoint = CGPoint(x: 0.0,y: 0.0)
        layer.colors = [color0,color1,color1,color0]
        self.setTitle("Điểm bán", for: .normal)
        self.layer.insertSublayer(layer, at: 0)
    }
}

extension  UIView{
    func setGradientBackground(colorOne: UIColor,colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0,y: 0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setMutileGradientBackground(colorOne: UIColor, colorTwo: UIColor,colorThree: UIColor, colorFour: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor,colorThree.cgColor,colorFour.cgColor]
        gradientLayer.locations = [0.0,0.2,0.4,1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0,y: 0.0)
        
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
