//
//  ListNGItemForPGViewController.swift
//  SH_SS
//
//  Created by Hung on 6/3/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ListNGItemForPGViewController: UIViewController,UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var seachbar: UISearchBar!
    var NGItemPicker = UIPickerView()
    var PickerView = UIView()
    var  ArrItem = [NGItem]()
    var arrSeach = [NGItem]()
    var arrNG = ["NGItem","NGDebt"]
    var flagcmp : Bool = false
    var cmp : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        seachbar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        if flagcmp == true
        {
            //Điểm bán của PG
            cmp = UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? ""
        }
        else
        {
            cmp = UserDefaults.standard.string(forKey: "cmp_wwn") ?? ""
        }
    }
    
    @IBAction func FilterAction(_ sender: Any) {
        PickerView = UIView(frame: CGRect(x: 0, y: view.frame.height - 260, width: view.frame.width, height: 260))
        
        // Toolbar
        let btnDone = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(self.DoneNG))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.Distroy))
        
        let barButtonForPicker = UIToolbar(frame: CGRect(x: 0, y: 0, width: PickerView.frame.width, height: 44))
        barButtonForPicker.barTintColor = UIColor.lightGray
        barButtonForPicker.barStyle = .default
        barButtonForPicker.isTranslucent = false
        barButtonForPicker.items = [cancelButton, spaceButton, btnDone]
        PickerView.addSubview(barButtonForPicker)
        
        // Month UIPIckerView
        NGItemPicker = UIPickerView(frame: CGRect(x: 0, y: barButtonForPicker.frame.height, width: view.frame.width, height: PickerView.frame.height - barButtonForPicker.frame.height))
        NGItemPicker.delegate = self
        NGItemPicker.dataSource = self
        NGItemPicker.backgroundColor = UIColor.white
        PickerView.addSubview(NGItemPicker)
        self.view.addSubview(PickerView)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrNG.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if arrNG[row] == "NGItem"
        {
            return "Lỗi sản phẩm"
        }
        else if arrNG[row] == "NGDebt"
        {
            return "Lỗi hạng mục tại điểm bán"
        }
        return nil
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func add(_ sender: Any) {
        confirm()
    }
    //Cho phép chọn option lỗi sản phẩm hay lỗi các hang mục tại điểm bán
    func confirm()
    {
        let optionMenu = UIAlertController(title: nil, message: "Chọn loại lỗi", preferredStyle: .actionSheet)
        
        let actionNGItem = UIAlertAction(title: "Lỗi sản phẩm", style: .destructive, handler:{ (action) in
            self.chooseNGItem()
        })
        let actionNGDebt = UIAlertAction(title: "Lỗi các hạng mục tại điểm bán", style: .default, handler:{ (action) in
            self.chooseNGDebt()
        })
        let actionClose = UIAlertAction(title: "Đóng", style: .cancel, handler: nil)
        
        optionMenu.addAction(actionNGItem)
        optionMenu.addAction(actionNGDebt)
        optionMenu.addAction(actionClose)
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(optionMenu, animated: true, completion: nil)
    }
    //Mở giao diện  lỗi sản phẩm cho PG
    func chooseNGItem() {
        let NGItem  : ReportErrorForPGViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportError") as? ReportErrorForPGViewController)!
        if(flagcmp == true)
        {
           NGItem.flagcmp = true
        }

        self.navigationController?.pushViewController(NGItem, animated: true)
    }
    
    //Mở giao diện Lỗi các hạng mục tại điểm bán cho PG
    func chooseNGDebt() {
        let NGDebt  : NGdebtReportErrorForPGRoundViewControllerViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NGdebt") as? NGdebtReportErrorForPGRoundViewControllerViewController)!
        if(flagcmp == true)
        {
            NGDebt.flagcmp = true
        }
        self.navigationController?.pushViewController(NGDebt, animated: true)
    }
    
    @objc  func Distroy()
    {
        self.PickerView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellOnListNGForPG") as? ReportResultTableViewCell else
        {
            return UITableViewCell()
        }
        cell.infoItemCode.text = arrSeach[indexPath.row].ItemName
        cell.infoValue.text = "Mô tả: " + String(arrSeach[indexPath.row].NGDescription)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
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
    func deleteAction(at indexPath : IndexPath) ->UIContextualAction
    {
        let Id : String = arrSeach[indexPath.row].Id
        let itemCode = arrSeach[indexPath.row].ItemCode
        let action = UIContextualAction(style: .normal, title: "Xoá") {  (action,view,completion) in
            self.deleteReport(Id: Id,ItemCode: itemCode,indexPath: indexPath)
            completion(true)
        }
        action.backgroundColor = .red
        return action
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
                        self.ArrItem.remove(at: indexPath.row)
                        self.tbl.deleteRows(at: [indexPath], with: .automatic)
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
    
    var errorDelete : Bool = false
    func deleteItem(Id : String,completion: @escaping (Bool)->())
    {
        addSavingPhotoView()
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        
        // create the request
        let urlString =  "http://appapi.sunhouse.com.vn/api/DMS/DeleteDMSNGItem/\(Id)?username=\(userLogin)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.container.removeFromSuperview()
                }
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
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                        
                        // create the alert
                        let alert = UIAlertController(title: "Thông báo", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        
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
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            
            arrSeach = ArrItem
            tbl.reloadData()
            return
        }
        arrSeach = ArrItem.filter(    {animal -> Bool in
            animal.ItemName.lowercased().contains(searchText.lowercased())
        })
        tbl.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        seachbar.endEditing(true)
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        seachbar.endEditing(true)
    }
    
    
    @objc func DoneNG()
    {
        self.PickerView.removeFromSuperview()
        let index = NGItemPicker.selectedRow(inComponent: 0)
        getListNGItem(ngtype: arrNG[index])
    }
    //Danh sách itemcode theo điểm bán PC ROund
    func getListNGItem(ngtype:String)
    {
        self.addSavingPhotoView()
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName") ?? ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListDMSNGItem?fromdate=\(udate)&todate=\(udate)&username=\(userLogin)&ngtype=\(ngtype)&cmp_wwn=\(cmp)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.container.removeFromSuperview()
                }
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                        self.ArrItem = []
                        self.arrSeach = []
                        if JsonData.count == 0
                        {
                            self.arrSeach = []
                            self.ArrItem = []
                        }
                        for dic in JsonData
                        {
                            self.ArrItem.append(NGItem(dic))
                        }
                        
                        self.arrSeach = self.ArrItem
                        if self.ArrItem.count  > 0
                        {
                            DispatchQueue.main.async {
                                self.boxView.removeFromSuperview()
                            }
                        }
                        DispatchQueue.main.sync {
                            self.tbl.reloadData()
                        }
                    }
                
                }
                
            } catch let error as NSError {
                self.activityView.stopAnimating()
                self.container.removeFromSuperview()
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    var container: UIView = UIView()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    func addSavingPhotoView() {
        
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 50, height: 50))
        boxView.backgroundColor = UIColor.black
        boxView.alpha = 1
        boxView.layer.cornerRadius = 10
        boxView.center = view.center
        boxView.translatesAutoresizingMaskIntoConstraints = false
        
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        boxView.addSubview(activityView)
        container.addSubview(boxView)
        view.addSubview(container)
        activityView.startAnimating()
    }
}
