//
//  PopUpSeachErrorPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/27/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PopUpSeachErrorPGViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var table: UITableView!
    var delegate : TypeErrorDelegate? = nil
    var arrTypeErr : [String] = ["trung_bay","tiep_nhan","Khach_su_dung"]
    
    let seachBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        seachBar.showsCancelButton = false
        seachBar.placeholder = "Tìm kiếm theo tên lỗi"
        seachBar.delegate = self
        
        
        self.navigationItem.titleView = seachBar
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTypeErr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellItemCode")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellItemCode")
        }
        if arrTypeErr[indexPath.row] == "trung_bay" {
            cell?.textLabel?.text = "Trưng bày"
        }
        else if arrTypeErr[indexPath.row] == "tiep_nhan" {
            cell?.textLabel?.text = "Tiếp nhận"
        }
        else {
            cell?.textLabel?.text = "Khách sử dụng"
        }
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemCode = arrTypeErr[indexPath.row]
        self.delegate?.addError(data: itemCode)
        navigationController?.popViewController( animated: true)
    }
}

protocol TypeErrorDelegate {
    func addError(data:String)
}
