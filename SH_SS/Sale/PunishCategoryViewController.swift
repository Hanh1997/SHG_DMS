//
//  PunishCategoryViewController.swift
//  SH_SS
//
//  Created by Hung on 2/4/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit

class PunishCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var delegate : PunishCategoryDelegate? = nil
    var jobtitle : String = ""
    @IBOutlet weak var tblListItem: UITableView!
    var arrSeach = [PunishCategoryModel]()
    var  ArrItem = [PunishCategoryModel]()
    let seachBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()

        seachBar.showsCancelButton = false
        seachBar.placeholder = "Nhập tên ngân hàng để tìm kiếm"
        seachBar.delegate = self
        self.navigationItem.titleView = seachBar
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        getPunishCategory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = arrSeach[indexPath.row].PunishGroupName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let Id = arrSeach[indexPath.row].Id
        let PunishGroupName = arrSeach[indexPath.row].PunishGroupName
         let SubtractLv1 = arrSeach[indexPath.row].SubtractLv1
         let SubtractLv2 = arrSeach[indexPath.row].SubtractLv2
         let SubtractLv3 = arrSeach[indexPath.row].SubtractLv3
        
        self.delegate?.PunishCategoryAdd(Id: Id, PunishGroupName: PunishGroupName, SubtractLv1: SubtractLv1, SubtractLv2: SubtractLv2, SubtractLv3: SubtractLv3)
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
            animal.PunishGroupName.lowercased().contains(searchText.lowercased())
        })
        tblListItem.reloadData()
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachBar.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seachBar.endEditing(true)
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
    
    func getPunishCategory()
    {
        self.addSavingPhotoView(_titleActivity: "Đang load")
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/KPI/GetPunishCategoryForApp?loginname=\(userName)&job_title=\(jobtitle)")!
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
                            self.ArrItem.append(PunishCategoryModel(dic))
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
}
class PunishCategoryModel     {
    var Id : String
    var PunishGroupName : String
    var SubtractLv1 : Double
    var SubtractLv2 : Double
    var SubtractLv3 : Double
    
    
    init(_ dictionary: [String: Any]) {
        self.Id = dictionary["Id"] as? String ?? ""
        self.PunishGroupName = dictionary["PunishGroupName"] as? String ?? ""
        self.SubtractLv1 = dictionary["SubtractLv1"] as? Double ?? 0
        self.SubtractLv2 = dictionary["SubtractLv2"] as? Double ?? 0
         self.SubtractLv3 = dictionary["SubtractLv3"] as? Double ?? 0
    }
}

protocol  PunishCategoryDelegate {
    func PunishCategoryAdd(Id:String,PunishGroupName:String,SubtractLv1 :Double,SubtractLv2 : Double,SubtractLv3: Double)
}
