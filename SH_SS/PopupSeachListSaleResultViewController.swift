//
//  PopupSeachListSaleResultViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 4/18/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import GCCalendar

extension PopupSeachListSaleResultViewController: GCCalendarViewDelegate {
    
  
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
       
      
        if IsCalender == "txtFromDate" {
              print(DateFrom)
            if(DateFrom != udate)
            {
                txtFromDate.text = udate
                DateFrom = txtFromDate.text!
                //IsCalender = ""
            }

        }
        if IsCalender == "txtToDate"
        {
              print(DateFrom)
            if DateTo != udate
            {
                if txtToDate.text != udate
                {
                    txtToDate.text = udate
                    DateTo = txtToDate.text!
                    //IsCalender = ""
                }
                
            }
        }
    }

}


protocol TaskDelegate {
    func addTask(data:Array<Any>)
}


class PopupSeachListSaleResultViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var viewCalendar: UIView!
    var delegate:TaskDelegate? = nil
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var tblCalendar : NSLayoutConstraint!
    @IBOutlet weak var viewButton : NSLayoutConstraint!
    fileprivate var calendarView: GCCalendarView!
    fileprivate var calendarView2: GCCalendarView!
    var  listData = [ListDataSaleOut]()
    var err : Bool = false
    var DateFrom : String = ""
    var DateTo: String = ""
    @IBAction func BtnChooseToday(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSeach(_ sender: Any) {
        DispatchQueue.main.async {
            self.GetListDataSaleOutForPCRound() {response in
                if response == false
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        txtFromDate.delegate = self
        txtToDate.delegate = self
    }

    var ISRemoveSubview : Bool = false
    var IsCalender : String = ""
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFromDate {
            IsCalender = "txtFromDate"
            if ISRemoveSubview == true
            {
                self.calendarView2.removeFromSuperview()
            }
            self.addCalendarView()
            self.addConstraints()
            ISRemoveSubview = true
        }
        if textField == txtToDate {
             IsCalender = "txtToDate"
            if ISRemoveSubview == true
            {
                self.calendarView.removeFromSuperview()
            }
            self.addCalendarView2()
            self.addConstraints2()
            ISRemoveSubview = true
           
        }
    }
    

    func addCalendarView() {
        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.calendarView)
    }
    
    func addCalendarView2() {
        self.calendarView2 = GCCalendarView()
        self.calendarView2.delegate = self
        self.calendarView2.displayMode = .month
        self.calendarView2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.calendarView2)
    }
    func addConstraints2() {
        self.calendarView2.topAnchor.constraint(equalTo: self.viewCalendar.topAnchor, constant: 4).isActive = true
        self.calendarView2.leftAnchor.constraint(equalTo: self.viewCalendar.leftAnchor).isActive = true
        self.calendarView2.rightAnchor.constraint(equalTo: self.viewCalendar.rightAnchor).isActive = true
        self.calendarView2.heightAnchor.constraint(equalTo: self.viewCalendar.heightAnchor,constant: 4).isActive = true
    }
    
    func addConstraints() {
        self.calendarView.topAnchor.constraint(equalTo: self.viewCalendar.topAnchor, constant: 4).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.viewCalendar.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.viewCalendar.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalTo: self.viewCalendar.heightAnchor,constant: 4).isActive = true
    }

    //Danh sách itemcode theo điểm bán PC ROund
    func GetListDataSaleOutForPCRound(completion: @escaping (Bool)->())
    {
        
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwn")!
        //let cmp : String = "9D9427FC-A9F8-4DFF-B66C-795C16A3BC1C"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        let fromDate = txtFromDate.text!
        let toDate = txtToDate.text!
        // create the request
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/GetListDataSaleOutForPCRound?fromdate=\(fromDate)&todate=\(toDate)&cmp_wwn=\(cmp)&username=\(userLogin)"
        
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
                            for dic in JsonData
                            {
                                self.listData.append(ListDataSaleOut(dic))
                            }
                            self.delegate?.addTask(data: self.listData)
                            completion(false)
                            return
                        }
                        else
                        {
                            completion(false)
                            return
                        }
                    }
                    else if chek == "ERR"
                    {
                         self.err = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                completion(true)
                                return
                            }
                        }
                       
                    }
                    else
                    {
                         self.err = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                completion(true)
                                return
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
 class  ListDataSaleOut {
    var Id : String
    var ItemName : String
    var ItemCode : String
    var StockQuantity : Int
    var ShowroomStock : Int
    var SaleQuantity : Int
    var SalePrice : Int
    var createDate : String
    
    init(_ dictionary: [String: Any]) {
        self.Id = dictionary["Id"] as? String ?? ""
        self.ItemName = dictionary["ItemName"] as? String ?? ""
        self.ItemCode = dictionary["ItemCode"] as? String ?? ""
        self.StockQuantity = dictionary["StockQuantity"] as? Int ?? 0
        self.ShowroomStock = dictionary["ShowroomStock"] as?  Int ?? 0
        self.SaleQuantity = dictionary["SaleQuantity"] as?  Int ?? 0
        self.SalePrice = dictionary["SalePrice"] as?  Int ?? 0
        self.createDate = dictionary["CreateDate"] as? String ?? ""
    }
}

