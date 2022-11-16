//
//  PGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/16/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import LGButton

class PGViewController: UIViewController,CmpDelegate {
    var cmp_wwn : String = ""
    
  
    @IBOutlet weak var btnChooseCmp: LGButton!
    @IBOutlet weak var btnCheckIn: LGButton!
    @IBOutlet weak var btnImageReport: LGButton!
    @IBOutlet weak var btnProductReport: LGButton!
    @IBOutlet weak var btnSaleResult: LGButton!
    @IBOutlet weak var btnCheckOut: LGButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func didChooseCmp(_ sender: Any) {
        performSegue(withIdentifier: "segueChooseCmpForPG", sender: self)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.CheckCheciIn()
        //self.GetListPCUploadImage()
        //self.GetListDataSaleOutForPC()
    }
    
    //Protocol
    func GetCmp(data: String) {
        btnChooseCmp.titleString = data;
        //self.btnCmpPG.setTitle(data, for: .normal)
    }
    
   
    
    @IBAction func ACT_CheckIn(_ sender: Any) {

        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
         if (cmp_wwn != "noCmp")
         {
             let Latitude = UserDefaults.standard.double(forKey: "LatitudePG")
             let longitude =  UserDefaults.standard.double(forKey: "LongitudePG")
             
             let vc : CheckInPGViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckInPG") as? CheckInPGViewController)!
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
    
    @IBAction func ACT_ImageReport(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
              if (cmp_wwn != "noCmp")
              {
                  let vc : PC_UploadImageViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PC_UploadImage") as? PC_UploadImageViewController)!
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
    @IBAction func ACT_ProductReport(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
              if (cmp_wwn != "noCmp")
              {
                  let vc : PC_UploadImageViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PC_UploadImage") as? PC_UploadImageViewController)!
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
    @IBAction func ACT_SaleResult(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
           if (cmp_wwn != "noCmp")
           {
               let vc : ListSaleResultPGViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListSaleResultPG") as? ListSaleResultPGViewController)!
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
    @IBAction func ACT_CheckOut(_ sender: Any) {
        cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
              if (cmp_wwn != "noCmp")
              {
                  let Latitude = UserDefaults.standard.double(forKey: "LatitudePG")
                  let longitude =  UserDefaults.standard.double(forKey: "LongitudePG")
                  
                  let vc :  CheckOutPGViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CheckOutPG") as? CheckOutPGViewController)!
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
 
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueChooseCmpForPG" {
            let vc : ListCmpViewController = segue.destination as! ListCmpViewController
            vc.flagCheck = true
            vc.delegate = self
        }
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
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
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
                                    self.btnCheckIn.leftIconString = "lock_open"
                                }
                                else{
                                    self.btnCheckIn.leftIconString = "lock"
                                    
                                }
                            }
                              DispatchQueue.main.async {
                                if(self.arrCheckOut.count > 0)
                                {
                                    self.btnCheckOut.leftIconString = "lock_open"
                                }
                                else
                                {
                                    self.btnCheckOut.leftIconString = "lock"
                                }
                            }
                        }
                        else
                        {
                        }
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
    //Check đã nhập kết quả chưa
    func GetListDataSaleOutForPC()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
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
//                            DispatchQueue.global(qos: .userInitiated).async {
//                                DispatchQueue.main.async {
//                                    self.btnSaleResultPG.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
//                                }
//                            }
                        }
                        else
                        {
//                            DispatchQueue.global(qos: .userInitiated).async {
//                                DispatchQueue.main.async {
//                                    self.btnSaleResultPG.leftImage(image:UIImage(named: "icons8-finance-report-64")!, renderMode: .alwaysOriginal)
//                                }
//                            }
                            
                        }
                    }
                    else if chek == "ERR"
                    {
//                        DispatchQueue.global(qos: .userInitiated).async {
//                            DispatchQueue.main.async {
//                                self.btnSaleResultPG.leftImage(image:UIImage(named: "icons8-finance-report-64")!, renderMode: .alwaysOriginal)
//                            }
//                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    //Check xem đã báo cáo hình ảnh hay chưa
    func GetListPCUploadImage()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp_wwn = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        // create the request
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/Document/GetListPCUploadImage?cmp_wwn=\(cmp_wwn)&username=\(userLogin)&udate=\(udate)"
        
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
//                            DispatchQueue.global(qos: .userInitiated).async {
//                                DispatchQueue.main.async {
//                                    self.btnReportImagePG.leftImage(image:UIImage(named: "ok-icon")!, renderMode: .alwaysOriginal)
//                                }
//                            }
                            
                        }
                        else
                        {
//                            self.btnReportImagePG.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
                        }
                        
                    }
                    else if chek == "ERR"
                    {
//                        DispatchQueue.global(qos: .userInitiated).async {
//                            DispatchQueue.main.async {
//                                self.btnReportImagePG.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
//                            }
//                        }
                    }
                    else
                    {
//                        DispatchQueue.global(qos: .userInitiated).async {
//                            DispatchQueue.main.async {
//                                self.btnReportImagePG.leftImage(image:UIImage(named: "icons8-folders-with-image-64")!, renderMode: .alwaysOriginal)
//                            }
//                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
