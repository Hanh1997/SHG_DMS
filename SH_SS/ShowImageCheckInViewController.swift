//
//  ShowImageCheckInViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 8/9/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit
import WebKit

class ShowImageCheckInViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
