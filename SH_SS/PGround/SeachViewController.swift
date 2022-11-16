//
//  SeachViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 8/9/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit

class SeachViewController: UIViewController,UISearchBarDelegate {

  @IBOutlet weak var searchController: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        searchController.showsBookmarkButton = true
        searchController.setImage(UIImage(named: "Editing-Delete-icon"), for: .bookmark, state: .normal)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    }
}
