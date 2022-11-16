//
//  PopupSeachItemViewController.swift
//  SH_SS
//
//  Created by Hung on 5/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PopupSeachItemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeach.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellItemCode")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellItemCode")
        }
        cell?.textLabel?.text = arrSeach[indexPath.row].ItemCode + " - " + arrSeach[indexPath.row].ItemName
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        txtSeach.text = arrSeach[indexPath.row].ItemName
         let itemCode = arrSeach[indexPath.row].ItemCode
        UserDefaults.standard.setValue(itemCode, forKey: "ItemCode")
        navigationController?.popViewController( animated: true)
        UIView.animate(withDuration: 0.5){
            
            //self.tblDropDow.constant = 0.0
            self.istable = false
            self.viewDidLayoutSubviews()
            //self.txtTB.becomeFirstResponder()
        }
    }
    

    @IBOutlet weak var txtSeach: UITextField!
    @IBOutlet weak var tblDropDow : NSLayoutConstraint!
    @IBOutlet weak var tblItemCode: UITableView!
    
    var istable = false
    var  ArrItem = [Item]()
    var arrSeach = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSeach.backgroundColor = UIColor.white
        txtSeach.layer.borderWidth = 1
        txtSeach.layer.borderColor = UIColor.white.cgColor
        txtSeach.layer.cornerRadius = 0
        getListItem()
        // Do any additional setup after loading the view.
    }
    
    //Danh sách itemcode theo điểm bán PC ROund
    func getListItem()
    {
        self.addSavingPhotoView(_titleActivity: "Đang load")
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListItemByDebCode?cmp_wwn=6B4DAA66-3615-450C-90E5-36897E6EE41C&username=PHUONGQT")!
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
                            self.arrSeach.append(Item(dic))
                        }
                        
                        if self.ArrItem.count  > 0
                        {
                            DispatchQueue.main.async {
                                self.boxView.removeFromSuperview()
                            }
                        }
                        DispatchQueue.main.sync {
                            self.tblItemCode.reloadData()
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtSeach
        {
            UIView.animate(withDuration: 0.5){
                if self.istable == false
                {
                    self.istable = true
                    self.tblDropDow.constant = 35.00 * 35.00
                }
                else
                {
                    self.tblDropDow.constant = 0.0
                    self.istable = false
                }
                self.viewDidLayoutSubviews()
            }
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.txtSeach {
            txtSeach.text = ""
            self.arrSeach.removeAll()
            for  i in ArrItem
            {
                arrSeach.append(i)
            }
            tblItemCode.reloadData()
            //self.istable = false
        }
        return false
    }
    
    @IBAction func textEdting(_ sender: Any) {
        
        if (txtSeach.text?.count)! >= 4
        {
            self.arrSeach.removeAll()
            for str in ArrItem
            {
                let range = str.ItemCode.lowercased().range(of: txtSeach.text!, options: .caseInsensitive, range: nil, locale: nil)
                
                if range != nil
                {
                    self.arrSeach.append(str)
                }
            }
            tblItemCode.reloadData()
        }
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
}
