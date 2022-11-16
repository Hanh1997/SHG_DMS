//
//  HomeSaleViewController.swift
//  SH_SS
//
//  Created by Hung on 6/26/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import WebKit

class HomeSaleViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        let AccessToken :String = UserDefaults.standard.string(forKey: "AccessToken") ?? ""
        let myURL = URL(string:"http://mobileweb.sunhouse.com.vn/Dashboard/DashBoardForSale?tokenkey=\(AccessToken)")
        let myRequest = URLRequest(url: myURL!)
        webview.navigationDelegate = self
        webview.load(myRequest)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.addSavingPhotoView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityView.stopAnimating()
        self.container.removeFromSuperview()
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
