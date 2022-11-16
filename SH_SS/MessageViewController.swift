//
//  MessageViewController.swift
//  SH_SS
//
//  Created by Hung on 5/29/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getListMessage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellMessage") as? MessageTableViewCell else
        {
            return UITableViewCell()
        }
        cell.MessageTitle.text = arrMessage[indexPath.row].MesTitle
        cell.Messageexplain.text = "Nhấp vào để đọc chi tiết thông báo"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageContent : String = arrMessage[indexPath.row].MesContent
        let vc : MessageDetailViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessageDetail") as? MessageDetailViewController)!
        vc.Contenthtml = messageContent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    var  arrMessage = [Message]()
    func getListMessage()
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
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/Messenger/GetAvailableMessenger?appid=b4e56f2e-e1f1-4366-b678-7e23e157639a&username=\(userLogin)&viewdate=\(udate)")!
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
                        self.arrMessage = []
                        if JsonData.count == 0
                        {
                            self.arrMessage = []
                        }
                        for dic in JsonData
                        {
                            self.arrMessage.append(Message(dic))
                        }
                        DispatchQueue.main.sync {
                            self.table.reloadData()
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
}

public struct  Message {
    var MesTitle : String
    var MesContent : String
  
    init(_ dictionary: [String: Any]) {
        self.MesTitle = dictionary["MesTitle"] as? String ?? ""
        self.MesContent = dictionary["MesContent"] as? String ?? ""
    }
}
