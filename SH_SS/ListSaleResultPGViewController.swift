//
//  ListSaleResultPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ListSaleResultPGViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    let seachBar = UISearchBar()
    var  listData = [ListDataSaleOut]()
    var arrSeach = [ListDataSaleOut]()
    var IsDelegate :  Bool = false
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        seachBar.showsCancelButton = false
        seachBar.placeholder = "Tìm kiếm theo tên"
        seachBar.delegate = self
        
        
        self.navigationItem.titleView = seachBar
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
    }
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetListDataSaleOutForPC()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachBar.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seachBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSeach.count > 0
        {
            setLoadingScreen()
            self.removeLoadingScreen()
        }
        return arrSeach.count
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath : IndexPath) ->UIContextualAction
    {
        let id = arrSeach[indexPath.row].Id
        let itemCode = arrSeach[indexPath.row].ItemCode
        let action = UIContextualAction(style: .normal, title: "Xoá") {  (action,view,completion) in
            self.deleteReport(Id: id,ItemCode: itemCode,indexPath: indexPath)
            completion(true)
        }
        action.backgroundColor = .red
        return action
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportResult") as? ReportResultTableViewCell else
        {
            return UITableViewCell()
        }
        cell.infoItemCode.text = arrSeach[indexPath.row].ItemName
        cell.StockQuantity.text = "TK: " + String(arrSeach[indexPath.row].StockQuantity)
        cell.ShowroomStock.text = "TB: " + String(arrSeach[indexPath.row].ShowroomStock)
        cell.SaleQuantity.text = "SL: " + String(arrSeach[indexPath.row].SaleQuantity)
        cell.SalePrice.text = "Giá: " + String(arrSeach[indexPath.row].SalePrice)

        return cell
    }
    func deleteReport(Id : String,ItemCode : String,indexPath : IndexPath){
        let alert = UIAlertController(title: "Thông  báo", message: "Bạn có muốn bỏ xoá mã " + ItemCode, preferredStyle: UIAlertController.Style.alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
            self.deleteItem(Id: Id){response in
                if response == false
                {
                    DispatchQueue.main.async {
                        self.arrSeach.remove(at:indexPath.row)
                        self.listData.remove(at: indexPath.row)
                        self.tblView.deleteRows(at: [indexPath], with: .automatic)
                        self.loadingView.removeFromSuperview()
                    }
                }
            }
        }
        
        alert.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(cancelAction)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            arrSeach = listData
            tblView.reloadData()
            return
        }
        arrSeach = listData.filter(    {animal -> Bool in
            animal.ItemName.lowercased().contains(searchText.lowercased())
        })
        tblView.reloadData()
    }
    
    func GetListDataSaleOutForPC()
    {
        listData.removeAll()
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwnPG")!
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        // create the request
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/GetListDataSaleOutForPCRound?fromdate=\(udate)&todate=\(udate)&cmp_wwn=\(cmp)&username=\(userLogin)"
        
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
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                                for dic in JsonData
                                {
                                    self.listData.append(ListDataSaleOut(dic))
                                }
                                self.arrSeach = self.listData
                                self.tblView.reloadData()                            }
                        }
                    }
                    else if chek == "ERR"
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
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
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
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
    
    var errorDelete : Bool = false
    func deleteItem(Id : String,completion: @escaping (Bool)->())
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        
        // create the request
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/DeleteDmsSaleOutById/\(Id)?username=\(userLogin)"
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
    
    
    let loadingLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    let loadingView = UIView()
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tblView.frame.width / 2) - (width / 2)
        let y = (tblView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tblView.addSubview(loadingView)
        
    }
    
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
}
