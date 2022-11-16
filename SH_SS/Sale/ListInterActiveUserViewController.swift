//
//  ListInterActiveUserViewController.swift
//  SH_SS
//
//  Created by Hung on 2/4/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit

class ListInterActiveUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
     var delegate : UserDelegate? = nil
    var arrSeach = [UserModel]()
    var  ArrItem = [UserModel]()
    let seachBar = UISearchBar()
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
        
        let Image    = UIImage(named: "icons8-plus-24")!
        
        let AddUserButton   = UIBarButtonItem(image: Image,  style: .plain, target: self, action:  #selector(addUser))

        navigationItem.rightBarButtonItems = [AddUserButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getListUser()
    }
    
    
    @objc  func addUser() {
        let vc : ListAllUserViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListAllUserViewController") as? ListAllUserViewController)!
        self.navigationController?.pushViewController(vc, animated: true)
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
        ArrItem = []
        arrSeach = []
        tblListItem.reloadData()
        self.addSavingPhotoView(_titleActivity: "Đang load")
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
         let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/KPI/GetInterActiveUser?loginname=\(userName)")!
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = arrSeach[indexPath.row].UserName + "-" + arrSeach[indexPath.row].FullName + " | " + arrSeach[indexPath.row].job_title + " | " + arrSeach[indexPath.row].costcenter
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let UserName = arrSeach[indexPath.row].UserName
        let FullName = arrSeach[indexPath.row].FullName
        let job_title = arrSeach[indexPath.row].job_title
        let costcenter = arrSeach[indexPath.row].costcenter
        self.delegate?.GetUser(UserName: UserName, FullName: FullName, job_title: job_title, costcenter: costcenter)
        navigationController?.popViewController( animated: true)
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
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
            animal.FullName.lowercased().contains(searchText.lowercased()) ||
            animal.UserName.lowercased().contains(searchText.lowercased())
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


class UserModel     {
    var UserName : String
    var FullName : String
    var job_title : String
    var costcenter : String
    
    init(_ dictionary: [String: Any]) {
        self.UserName = dictionary["UserName"] as? String ?? ""
        self.FullName = dictionary["FullName"] as? String ?? ""
        self.job_title = dictionary["job_title"] as? String ?? ""
        self.costcenter = dictionary["costcenter"] as? String ?? ""
    }
}

protocol  UserDelegate {
    func GetUser(UserName:String,FullName:String,job_title:String,costcenter:String)
}
