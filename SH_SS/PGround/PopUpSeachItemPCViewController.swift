//
//  PopUpSeachItemPCViewController.swift
//  SH_SS
//
//  Created by Hung on 5/26/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PopUpSeachItemPCViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var tblListItem: UITableView!
    //@IBOutlet weak var txtItemSeach: UITextField!
    var  ArrItem = [Item]()
    var arrSeach = [Item]()
    var delegate : ItemDelegate? = nil
    var istable = false

    var cmp : String = ""
    let seachBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        seachBar.showsCancelButton = false
        seachBar.placeholder = "Tìm kiếm theo tên sản phẩm"
        seachBar.delegate = self
        
        
        self.navigationItem.titleView = seachBar
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        getListItem(cmp: cmp)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellItemCode")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellItemCode")
        }
        cell?.textLabel?.text = arrSeach[indexPath.row].ItemName
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemCode = arrSeach[indexPath.row].ItemCode
        self.delegate?.addItem(data: itemCode)
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
            animal.ItemName.lowercased().contains(searchText.lowercased())
            || animal.ItemCode.lowercased().contains(searchText.lowercased())
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
    //Danh sách itemcode theo điểm bán PC ROund
    func getListItem(cmp: String)
    {
        self.addSavingPhotoView(_titleActivity: "Đang load")
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListItemByDebCode?cmp_wwn=\(cmp)&username=\(userName)")!
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
                            self.ArrItem.append(Item(dic))
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

protocol ItemDelegate {
    func addItem(data:String)
}
