//
//  ListCmpViewController.swift
//  SH_SS
//
//  Created by Hung on 6/3/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ListCmpViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableCmp: UITableView!
    let seachBar = UISearchBar()
    var arrayCmp = [StrCmp]()
    var arrSeach = [StrCmp]()
    var delegate : CmpDelegate? = nil
    var flagCheck : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        seachBar.showsCancelButton = false
        seachBar.placeholder = "Tìm kiếm tên điểm bán"
        seachBar.delegate = self
        seachBar.searchBarStyle = .minimal
        
        self.navigationItem.titleView = seachBar
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        if (flagCheck == false)
        {
            GetListCmpForPGRound()
        }
        else
        {
            GetListCmpForPG()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellCmp")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellCmp")
        }
        cell?.textLabel?.text = arrSeach[indexPath.row].cmp_name
        
        return cell!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cmpName : String = arrSeach[indexPath.row].cmp_name
        self.delegate?.GetCmp(data: cmpName)
        
        if flagCheck == false
        {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "Latitude")
            defaults.removeObject(forKey: "Longitude")
            defaults.removeObject(forKey: "cmp_wwn")
            defaults.removeObject(forKey: "cmp_name")
            defaults.synchronize()
            
            UserDefaults.standard.setValue(arrSeach[indexPath.row].Latitude, forKey: "Latitude")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].Longitude, forKey: "Longitude")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].cmp_wwn, forKey: "cmp_wwn")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].cmp_name, forKey: "cmp_name")
        }
        else
        {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "LatitudePG")
            defaults.removeObject(forKey: "LongitudePG")
            defaults.removeObject(forKey: "cmp_wwnPG")
            defaults.removeObject(forKey: "cmp_namePG")
            defaults.synchronize()
            
            UserDefaults.standard.setValue(arrSeach[indexPath.row].Latitude, forKey: "LatitudePG")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].Longitude, forKey: "LongitudePG")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].cmp_wwn, forKey: "cmp_wwnPG")
            UserDefaults.standard.setValue(arrSeach[indexPath.row].cmp_name, forKey: "cmp_namePG")
        }
        self.navigationController?.popViewController( animated: true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            arrSeach = arrayCmp
            tableCmp.reloadData()
            return
        }
        arrSeach = arrayCmp.filter(    {animal -> Bool in
            animal.cmp_name.lowercased().contains(searchText.lowercased())
        })
        tableCmp.reloadData()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachBar.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seachBar.endEditing(true)
    }
    
    /**
        Danh sách điểm bán dành cho sale
     */
    func GetListCmpForPGRound()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName : String = UserDefaults.standard.string(forKey: "UserName")!
  
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListVistPlan?username=\(userName)")!
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
                            self.arrayCmp.append(StrCmp(dic))
                        }
                        self.arrSeach = self.arrayCmp
                        DispatchQueue.main.sync {
                            self.tableCmp.reloadData()
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    //Danh sách điểm bán cho pg thường
    func GetListCmpForPG()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName : String = UserDefaults.standard.string(forKey: "UserName")!
        //let userName : String = "mbvannt"
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListDMSCustomerLookup?username=\(userName)")!
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
                            self.arrayCmp.append(StrCmp(dic))
                        }
                        self.arrSeach = self.arrayCmp
                        DispatchQueue.main.sync {
                            self.tableCmp.reloadData()
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

protocol CmpDelegate {
    func GetCmp(data:String)
}
