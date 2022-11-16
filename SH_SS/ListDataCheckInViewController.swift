//
//  ListDataCheckInViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 3/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import GCCalendar

extension ListDataCheckInViewController: GCCalendarViewDelegate {
    

    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let  fromDate = formatter.string(from: date)
        
        let formatterAdd = DateFormatter()
        formatterAdd.dateFormat = "yyyy/MM/dd"
        let  udate = formatterAdd.string(from: date)
        
        if flagDate == true
        {
            FromDateView = fromDate
            FromDate = udate
        }
        else
        {
            ToDateView = fromDate
            ToDate = udate
        }
    }
}

class ListDataCheckInViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {

    @IBOutlet weak var btnFromDate: UIButton!
    @IBOutlet weak var btnToDate: UIButton!
    @IBOutlet weak var tblDataCheckIn: UITableView!
    @IBOutlet weak var tablleView: UITableView!
    var FromDateView : String = ""
    var FromDate : String = ""
    var ToDateView : String = ""
    var ToDate : String = ""
    var flagDate : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        tblDataCheckIn.delegate = self

        btnFromDate.rightImage(image: UIImage(named: "icons8-sort-down-24")!,padding: 20 ,renderMode: .alwaysOriginal)
        btnToDate.rightImage(image: UIImage(named: "icons8-sort-down-24")!,padding: 20 ,renderMode: .alwaysOriginal)
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    
    var ViewContenerPicker = UIView()
    var picker = UIPickerView()

    
    @objc  func Done()
    {
        btnFromDate.setTitle(FromDateView, for: .normal)
        self.ViewContenerPicker.removeFromSuperview()
        if FromDate != "" && ToDate != ""
        {
            getListDataCheckIn(fromdate: FromDate, todate: ToDate)
        }
    }
    @objc  func removeview() {
        self.ViewContenerPicker.removeFromSuperview()
    }
    
    @objc  func DoneTo()
    {
        btnToDate.setTitle(ToDateView, for: .normal)
        self.ViewContenerPicker.removeFromSuperview()
        if FromDate != "" && ToDate != ""
        {
            getListDataCheckIn(fromdate: FromDate, todate: ToDate)
        }
    }
    @objc  func removeviewTo() {
        self.ViewContenerPicker.removeFromSuperview()
    }
    
    fileprivate var calendarView: GCCalendarView!
    @IBAction func ChosseFromDateAction(_ sender: Any) {
          flagDate  = true
         self.ViewContenerPicker.removeFromSuperview()
        
        ViewContenerPicker = UIView(frame: CGRect(x: 0, y: view.frame.height - 420, width: view.frame.width, height: 420))
        
        // Toolbar
        let btnDone = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: self, action: #selector(self.Done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ bỏ", style: .plain, target: self, action: #selector(self.removeview))
        
        let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: ViewContenerPicker.frame.width, height: 40))
        barAccessory.barTintColor = Colors.lightGrey
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = false
        barAccessory.items = [cancelButton, spaceButton, btnDone]
        ViewContenerPicker.addSubview(barAccessory)
        
        // Month UIPIckerView
        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        ViewContenerPicker.addSubview(calendarView)
        self.view.addSubview(ViewContenerPicker)
        
        self.calendarView.topAnchor.constraint(equalTo: self.ViewContenerPicker.topAnchor,constant: 40).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.ViewContenerPicker.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.ViewContenerPicker.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalTo: self.ViewContenerPicker.heightAnchor).isActive = true
    }

    @objc func displayMode() {
        
        self.calendarView.displayMode = (self.calendarView.displayMode == .month) ? .week : .month
    }
    
    @IBAction func ChooseToDateAction(_ sender: Any) {
          flagDate  = false
         self.ViewContenerPicker.removeFromSuperview()
        
        ViewContenerPicker = UIView(frame: CGRect(x: 0, y: view.frame.height - 420, width: view.frame.width, height: 420))
        
        // Toolbar
        let btnDone = UIBarButtonItem(title: "Hoàn tất", style: .plain, target: self, action: #selector(self.DoneTo))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ bỏ", style: .plain, target: self, action: #selector(self.removeviewTo))
        
        let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: ViewContenerPicker.frame.width, height: 40))
        barAccessory.barTintColor = Colors.lightGrey
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = false
        barAccessory.items = [cancelButton, spaceButton, btnDone]
        ViewContenerPicker.addSubview(barAccessory)
        
        // Month UIPIckerView
        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        ViewContenerPicker.addSubview(calendarView)
        self.view.addSubview(ViewContenerPicker)
        
        self.calendarView.topAnchor.constraint(equalTo: self.ViewContenerPicker.topAnchor,constant: 40).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.ViewContenerPicker.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.ViewContenerPicker.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalTo: self.ViewContenerPicker.heightAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckInCell") as? CheckInCell else
        {
            return UITableViewCell()
        }
        
        cell.cmpnameLbl.text = model[indexPath.row].cmp_name
        cell.DateCheckLbl.text = model[indexPath.row].ActionCode + " lúc " + model[indexPath.row].strCheckTime + " Ngày " + model[indexPath.row].strCheckDate
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let location = showLocationAction(at: indexPath)
        let Image = ShowImage(at: indexPath)
        return UISwipeActionsConfiguration(actions: [location,Image])
    }
    func showLocationAction(at indexPath : IndexPath) ->UIContextualAction
    {
        let userlatitude : Double = Double(model[indexPath.row].Latitude)!
        let userlongitude : Double = Double(model[indexPath.row].Longitude)!
        let action = UIContextualAction(style: .normal, title: "Vị trí") {  (action,view,completion) in
        let vc : MapViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController)!
         vc.userlatitude = userlatitude
         vc.userlongitude = userlongitude
         self.navigationController?.pushViewController(vc, animated: true)
         completion(true)
        }
        action.backgroundColor = .gray
        return action
    }
    
    func ShowImage(at indexPath : IndexPath) ->UIContextualAction
    {
        let url :String = model[indexPath.row].ImagePath
        let action = UIContextualAction(style: .normal, title: "Hình ảnh") {  (action,view,completion) in
            let vc : ShowImageCheckInViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageCheckIn") as? ShowImageCheckInViewController)!
            vc.url = url
            self.navigationController?.pushViewController(vc, animated: true)
            completion(true)
        }
        action.backgroundColor = .blue
        return action
    }
    
    //var container: UIView = UIView()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    func addSavingPhotoView(_titleActivity : String) {
        
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 50, height: 50))
        boxView.backgroundColor = UIColor.black
        boxView.alpha = 1
        boxView.layer.cornerRadius = 10
        boxView.center = view.center
        boxView.translatesAutoresizingMaskIntoConstraints = false
        
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        boxView.addSubview(activityView)
        //container.addSubview(boxView)
        view.addSubview(boxView)
        activityView.startAnimating()
        
    }


    var  model = [CheckIn]()
    func getListDataCheckIn(fromdate: String,todate: String)
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
    
         let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/dms/GetCheckInData?cmp_wwn=&username=\(userName)&fromdate=\(fromdate)&todate=\(todate)")!
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
                            self.model.append(CheckIn(dic))
                        }
                        DispatchQueue.main.sync {
                              self.boxView.removeFromSuperview()
                            self.tablleView.reloadData()
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


class  CheckIn {
    var cmp_name : String
    var cmp_wwn : String
    var Latitude : String
    var Longitude : String
    var UserName : String
    var FullName : String
    var ImagePath : String
    var strCheckDate : String
    var strCheckTime : String
    var ActionCode : String
    
    init(_ dictionary: [String: Any]) {
        self.cmp_name = dictionary["cmp_name"] as? String ?? ""
        self.cmp_wwn = dictionary["cmp_wwn"] as? String ?? ""
        self.Latitude = dictionary["Latitude"] as? String ?? ""
        self.Longitude = dictionary["Longitude"] as?  String ?? ""
        self.UserName = dictionary["UserName"] as? String ?? ""
        self.FullName = dictionary["FullName"] as?  String ?? ""
        self.ImagePath = dictionary["ImagePath"] as? String ?? ""
        self.strCheckDate = dictionary["strCheckDate"] as? String ?? ""
        self.strCheckTime = dictionary["strCheckTime"] as? String ?? ""
        self.ActionCode = dictionary["ActionCode"] as? String ?? ""
    }
}

extension UIButton
{
    func rightImage(image: UIImage, padding: CGFloat ,renderMode: UIImage.RenderingMode) {
        
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .right
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)
    }
}






