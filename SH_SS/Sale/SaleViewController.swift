//
//  SaleViewController.swift
//  SH_SS
//
//  Created by Hung on 6/19/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import LGButton
class SaleViewController: UIViewController,CmpDelegate {
    func GetCmp(data: String) {
        self.btnCmpSale.titleString = data
    }
    
    @IBOutlet weak var btnCheckInSale: LGButton!
    @IBOutlet weak var btnCmpSale: LGButton!
    @IBOutlet weak var btnCheckOutSale: LGButton!
    @IBOutlet weak var btnImageReportSale: LGButton!
    @IBOutlet weak var btnReportErrorSale: LGButton!
    @IBOutlet weak var btn360Sale: LGButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didChooseCmp(_ sender: Any) {
        performSegue(withIdentifier: "segueChosseCmpForSale", sender: self)
    }
    @IBAction func didCheckIn(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let Latitude = UserDefaults.standard.double(forKey: "Latitude")
            let longitude =  UserDefaults.standard.double(forKey: "Longitude")
            
            let vc : CheckInViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckIn") as? CheckInViewController)!
            vc.cmp_wwn = cmp_wwn
            vc.LatCus =  Latitude
            vc.LongCus = longitude
            vc.appID = "54a89973-d266-4920-97bd-d487a29452a0"
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
    @IBAction func didImageReport(_ sender: Any) {
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
    @IBAction func didProductError(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let vc :  ListNGItemViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListNGItem") as? ListNGItemViewController)!
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
    @IBAction func didKpiPunish(_ sender: Any) {
        performSegue(withIdentifier: "segueKPIPunish", sender: self)

    }
    @IBAction func didCheckOut(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        if (cmp_wwn != "noCmp")
        {
            let Latitude = UserDefaults.standard.double(forKey: "Latitude")
            let longitude =  UserDefaults.standard.double(forKey: "Longitude")
            
            let vc :  CheckOutViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOut") as? CheckOutViewController)!
            vc.cmp_wwn = cmp_wwn
            vc.LatCus =  Latitude
            vc.LongCus = longitude
            vc.appID = "54a89973-d266-4920-97bd-d487a29452a0"
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
        
        if segue.identifier == "segueChosseCmpForSale" {
            let vc : ListCmpViewController = segue.destination as! ListCmpViewController
            
            vc.delegate = self
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.CheckCheciIn()
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.CheckCheciIn()
        //self.GetListSaleloadImage()
    }
    
    var listDataJson = [CheckIn]()
    var arrCheckIn = [CheckIn]()
    var arrCheckOut = [CheckIn]()
    //check xem đã checkin chưa
    func CheckCheciIn()
    {
        self.btnCheckInSale.leftIconString = "lock"
        self.btnCheckOutSale.leftIconString = "lock"
        listDataJson = []
        arrCheckIn = []
        arrCheckOut = []
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
                            
                          
                            DispatchQueue.main.async {
                                if (self.arrCheckIn.count > 0)
                                {
                                    self.btnCheckInSale.leftIconString = "lock_open"
                                }
                                else{
                                    self.btnCheckInSale.leftIconString = "lock"
                                    
                                }
                            }

                            
                             DispatchQueue.main.async {
                                if (self.arrCheckOut.count > 0)
                                {
                                    self.btnCheckOutSale.leftIconString = "lock_open"
                                }
                                else{
                                    self.btnCheckOutSale.leftIconString = "lock"
                                    
                                }
                            }
                        }
                        else
                        {
                            //self.btnCheckInSale.leftIconString = "lock"
                           
                            
                        }
                    }
                    else
                    {
                        //self.btnCheckInSale.leftIconString = "lock"
                       // self.btnCheckOutSale.leftIconString = "lock"
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    //Check xem đã báo cáo hình ảnh chưa
    func GetListSaleloadImage()
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
                            
                        }
                        else
                        {

                        }
                    }
                    else if chek == "ERR"
                    {

                        
                    }
                    else
                    {

                        
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    var cmp_wwn :String = ""
    @IBAction func CheckInAction(_ sender: Any) {
      
    }
    
    @IBAction func CheckOutAction(_ sender: Any) {
      
    }
    //Báo lỗi sản phẩm
    @IBAction func ReportErrorAction(_ sender: Any) {
        
       
    }
    @IBAction func ImageReportAction(_ sender: Any) {


    }
}
