//
//  ListVideoViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 8/26/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import UIKit
import AVFoundation
import BMPlayer

class ListVideoViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellVideo", for: indexPath as IndexPath) as! VideoCell
        
        cell.ImageThun.image = UIImage(named: "118139459_632694211014014_338047539455923157_n");
        cell.lbTitle.text = "Quạt điều hoà SHD7727"
        //cell.backgroundColor = UIColor.red
     
        
       cell.layer.addBorder(edge: .bottom, color: .black, thickness: 1)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        return CGSize(width: col.frame.width,height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushVideoDetail", sender: indexPath)


    }
    
    
    
    @IBOutlet weak var col: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        col.delegate = self
        col.dataSource = self
        
        col.collectionViewLayout = CustomImageLayout()
    }
   
}


class CustomImageLayout: UICollectionViewFlowLayout {

var numberOfColumns:CGFloat = 3.0

override init() {
    super.init()
    setupLayout()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLayout()
}

override var itemSize: CGSize {
    set { }
    get {
        let itemWidth = (self.collectionView!.frame.width - (self.numberOfColumns - 1)) / self.numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

func setupLayout() {
    minimumInteritemSpacing = 1 // Set to zero if you want
    minimumLineSpacing = 1
    scrollDirection = .vertical
}
}
extension CALayer {

func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

    let border = CALayer()

    switch edge {
    case .top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
    case .bottom:
        border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
    case .left:
        border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
    case .right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
    default:
        break
    }
    border.backgroundColor = color.cgColor
    addSublayer(border)
    }
}
