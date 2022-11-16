//
//  MenuViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 2/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDataSource , UITableViewDelegate  {
    var arrCellID:[String] = ["Cell1", "Cell2", "Cell3","Cell4","Cell5"]

    @IBOutlet weak var menu: UITableView!
    @IBOutlet weak var txtFullName: UILabel!
    @IBOutlet weak var MyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.delegate = self
        menu.dataSource = self
        txtFullName.text =  UserDefaults.standard.string(forKey: "FullName")
        
        let bottomBorder: CALayer = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: MyView.frame.size.height-1, width:self.view.frame.width, height: 0.3)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        MyView.layer.addSublayer(bottomBorder)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     func numberOfSectionsInTableView(tableView: UITableView) ->
        Int {
            return 1
    }
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrCellID.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: arrCellID[indexPath.row], for: indexPath)
     
            if arrCellID[indexPath.row] == "Cell1"
            {
                cell.textLabel?.text = "Lịch sử Check In"
                cell.imageView?.image = UIImage(named: "icons8-bar-chart-filled-20")
            }
            else if arrCellID[indexPath.row] == "Cell2"
            {
                cell.textLabel?.text = "Đăng ký lịch làm việc"
                cell.imageView?.image = UIImage(named: "icons8-data-grid-filled-20")
            }
            else if arrCellID[indexPath.row] == "Cell3"
            {
                cell.textLabel?.text = "Đăng ký viếng thăm điểm bán"
                cell.imageView?.image = UIImage(named: "icons8-data-grid-filled-20")
            }
                
            else if arrCellID[indexPath.row] == "Cell4"
            {
                 cell.textLabel?.text = "Video đào tạo"
                 cell.imageView?.image = UIImage(named: "icons8-video-20")
             }
            else if arrCellID[indexPath.row] == "Cell5"
            {
                cell.textLabel?.text = "Đăng xuất"
                cell.imageView?.image = UIImage(named: "icons8-import-filled-20")
            }
        

        return cell
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if arrCellID[indexPath.row] == "Cell5"
        {
            UserDefaults.standard.removeObject(forKey: "AccessToken")
            let optionMenu = UIAlertController(title: nil, message: "Bạn có muốn đăng xuất hay không", preferredStyle: .actionSheet)
            
            let actionOut = UIAlertAction(title: "Đăng xuất", style: .destructive, handler:{ (action) in
                self.func_OutController()
            })
            let actionClose = UIAlertAction(title: "Đóng", style: .cancel, handler: nil)
            
            optionMenu.addAction(actionOut)
            optionMenu.addAction(actionClose)
            optionMenu.popoverPresentationController?.sourceView = self.view
            optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
           self.present(optionMenu, animated: true, completion: nil)
        }
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
    //Move on viewindex
    func func_OutController()
    {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Latitude")
        defaults.removeObject(forKey: "Longitude")
        defaults.removeObject(forKey: "cmp_wwn")
        defaults.removeObject(forKey: "cmp_wwnPG")
        defaults.removeObject(forKey: "cmp_name")
        defaults.removeObject(forKey: "cmp_namePG")
        defaults.removeObject(forKey: "UserName")
        defaults.removeObject(forKey: "FullName")
        defaults.removeObject(forKey: "AccessToken")
        
        defaults.synchronize()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.present(newViewController, animated: true, completion: nil)
    }
}
