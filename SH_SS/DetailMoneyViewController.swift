//
//  DetailMoneyViewController.swift
//  SH_SS
//
//  Created by Hung on 6/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class DetailMoneyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableDetailMoney: UITableView!
    @IBOutlet weak var PopupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
        tableDetailMoney.delegate = self
        tableDetailMoney.dataSource = self
        self.tableDetailMoney.tableFooterView = UIView(frame: .zero)
        
        self.tableDetailMoney.backgroundColor = UIColor.clear
       tableDetailMoney.rowHeight = 150
       //PopupView.layer.cornerRadius = 5
       //PopupView.layer.masksToBounds = true
       GetlistDetailKPIPunishByUserName()

    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    var arrDetailMoney = [DetailMoney]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDetailMoney.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMoneyTableViewCell") as? DetailMoneyTableViewCell else
        {
            return UITableViewCell()
        }
        cell.EmpPenalties.text =  arrDetailMoney[indexPath.row].EmpPenaltiesName
        cell.PunishDate.text =  arrDetailMoney[indexPath.row].StrPunishDate
        cell.PunishGroupName.text =  arrDetailMoney[indexPath.row].PunishGroupName
        cell.PunishReason.text =  arrDetailMoney[indexPath.row].PunishReason
        cell.SubtractMoney.text = arrDetailMoney[indexPath.row].StrSubtractMoney  + " VND"
        return cell
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
    
    //Danh sách chi tiết lỗi của pc
    func GetlistDetailKPIPunishByUserName()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName : String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetlistDetailKPIPunishByUserName?username=\(userName)")!
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
                            self.arrDetailMoney.append(DetailMoney(dic))
                        }
                        DispatchQueue.main.sync {
                            self.tableDetailMoney.reloadData()
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    @IBAction func close(_ sender: Any) {
      removeAnimate()
    }
}

public struct  DetailMoney {
    var EmpPenaltiesName : String
    var StrPunishDate : String
    var PunishGroupName : String
    var PunishReason : String
    var StrSubtractMoney : String
    
    init(_ dictionary: [String: Any]) {
        self.EmpPenaltiesName = dictionary["EmpPenaltiesName"] as? String ?? ""
        self.StrPunishDate = dictionary["StrPunishDate"] as? String ?? ""
        self.PunishGroupName = dictionary["PunishGroupName"] as? String ?? ""
        self.PunishReason = dictionary["PunishReason"] as? String ?? ""
        self.StrSubtractMoney = dictionary["StrSubtractMoney"] as? String ?? ""

    }
}
