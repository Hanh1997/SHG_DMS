//
//  PopupSeachReportImgPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import GCCalendar

class PopupSeachReportImgPGViewController: UIViewController,GCCalendarViewDelegate {

    @IBOutlet weak var OutBtnToday: UIButton!
    @IBOutlet weak var OutBtnSeach: UIButton!
    @IBOutlet weak var OutDate: UILabel!
    @IBOutlet weak var ViewPicker: UIView!
    fileprivate var calendarView: GCCalendarView!
    var delegate:TaskDelegate? = nil
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        OutDate.text = udate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCalendarView()
        self.addConstraints()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        OutDate.text = udate
    }
    
    @objc func today() {
        
        self.calendarView.select(date: Date())
    }
    
    @objc func displayMode() {
        
        self.calendarView.displayMode = (self.calendarView.displayMode == .month) ? .week : .month
    }
    
    func addCalendarView() {
        
        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.calendarView)
    }
    
    func addConstraints() {
        self.calendarView.topAnchor.constraint(equalTo: self.ViewPicker.topAnchor, constant: 4).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.ViewPicker.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.ViewPicker.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalTo: self.ViewPicker.heightAnchor,constant: 4).isActive = true
    }


    @IBAction func AcBtnSeach(_ sender: Any) {
        DispatchQueue.main.async {
            self.GetListPCRoundUploadImage() {response in
                if response == false
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func AcBtnToday(_ sender: Any) {
        
        today()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        OutDate.text = udate
    }
    
    var  arrImg = [ListReportImg]()
    func GetListPCRoundUploadImage( completion: @escaping (Bool)->())
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwnPG")!
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        
        let date = OutDate.text!
        let urlString =  "http://appapi.sunhouse.com.vn/api/Document/GetListPCRoundUploadImage?cmp_wwn=\(cmp)&username=\(userLogin)&udate=\(date)"
        
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
                        for dic in JsonData
                        {
                            self.arrImg.append(ListReportImg(dic))
                        }
                        print(self.arrImg)
                        self.delegate?.addTask(data: self.arrImg)
                        completion(false)
                        return
                    }
                    else if chek == "ERR"
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                    self.load()
                                    completion(false)
                                    return
                                })
                                
                                alert.addAction(actionback)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                    self.load()
                                    completion(false)
                                    return
                                })
                                
                                alert.addAction(actionback)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
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
    
    func load()
    {
        self.delegate?.addTask(data: [])
    }
}
