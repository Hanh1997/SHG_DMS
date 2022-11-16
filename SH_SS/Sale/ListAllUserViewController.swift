//
//  ListAllUserViewController.swift
//  SH_SS
//
//  Created by Hung on 2/5/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit

class ListAllUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    let seachBar = UISearchBar()
    var arrSeach = [UserModel]()
    var  ArrItem = [UserModel]()
    @IBOutlet weak var tblListItem: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        seachBar.showsCancelButton = false
        seachBar.placeholder = "Nhập tên để tìm kiếm"
        seachBar.delegate = self
        self.navigationItem.titleView = seachBar
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        let saveButton   = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(save))
        
        navigationItem.rightBarButtonItems = [saveButton]
        
        getListUser()
    }
    
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
        view.addSubview(boxView)
        activityView.startAnimating()
        
    }
    
    func getListUser()
    {
        self.addSavingPhotoView(_titleActivity: "Đang load")
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/KPI/GetAllUserActiveForApp?loginname=\(userName)")!
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
                            self.ArrItem.append(UserModel(dic))
                        }
                        self.arrSeach = self.ArrItem
                        if self.ArrItem.count  > 0
                        {
                            DispatchQueue.main.async {
                                self.boxView.removeFromSuperview()
                            }
                        }
                        DispatchQueue.main.sync {
                            self.checked = Array(repeating: false, count: self.ArrItem.count)
                            self.tblListItem.reloadData()
                            
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    var listUser : [String] = []
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                checked[indexPath.row] = false
                 let username =  arrSeach[indexPath.row].UserName
                 listUser = listUser.filter { $0 != username }
            } else {
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
                let username =  arrSeach[indexPath.row].UserName
                listUser.append(username)
            }
        }
    }
    var checked = [Bool]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        cell!.textLabel?.text = arrSeach[indexPath.row].UserName + "-" + arrSeach[indexPath.row].FullName  + " | " + arrSeach[indexPath.row].costcenter
        
        if checked[indexPath.row] == false{
            cell!.accessoryType = .none
        } else if checked[indexPath.row] {
            cell!.accessoryType = .checkmark
        }
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }
    
    @objc func save()
    {
        if listUser.count == 0
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chọn người để tạo tương tác", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông  báo", message: "Bạn có đồng ý tạo tương tác không?", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(cancelAction)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                        let InterActiveUser = self.listUser.joined(separator: ",")
                        
                        self.addSavingPhotoView(_titleActivity: "Đang load")
                        let username = "trieupv"
                        let password = "phamtrieu"
                        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
                        let base64LoginData = loginData.base64EncodedString()
                        
                        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
                        // create the request
                        let url = URL(string: "http://appapi.sunhouse.com.vn/api/KPI/SaveInteractiveUser?InterActiveUser=\(InterActiveUser)&loginUser=\(userName)")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "GET"
                        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
                        
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                                if let chek = json?["ResponseStatus"] as? String {
                                    DispatchQueue.main.async {
                                        self.boxView.removeFromSuperview()
                                    }
                                    if(chek == "OK")
                                    {
                                        DispatchQueue.global(qos: .userInitiated).async {
                                            DispatchQueue.main.async {
                                                // create the alert
                                                let alert = UIAlertController(title: "Thông báo", message: "Tạo tương tác thành công", preferredStyle: UIAlertController.Style.alert)
                                                
                                                let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                                    self.back()
                                                })
                                                alert.addAction(actionback)
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                return
                                            }
                                        }
                                    }
                                    else
                                    {
                                        DispatchQueue.global(qos: .userInitiated).async {
                                            DispatchQueue.main.async {
                                                // create the alert
                                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                return
                                            }
                                        }
                                    }
                                }
                                
                            } catch let error as NSError{
                                DispatchQueue.global(qos: .userInitiated).async {
                                    DispatchQueue.main.async {
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
                    alert.addAction(OKAction)
                  
                    
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    func back()
    {
        navigationController?.popViewController( animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            arrSeach = ArrItem
            tblListItem.reloadData()
            return
        }
        arrSeach = ArrItem.filter(    {animal -> Bool in
            animal.FullName.lowercased().contains(searchText.lowercased()) || animal.UserName.lowercased().contains(searchText.lowercased())
        })
        tblListItem.reloadData()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachBar.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seachBar.endEditing(true)
    }
}
