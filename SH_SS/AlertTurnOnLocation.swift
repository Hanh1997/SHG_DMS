//
//  AlertTurnOnLocation.swift
//  SH_SS
//
//  Created by Hung on 2/17/20.
//  Copyright © 2020 phạm Hưng. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AlertTurnOnLocation: UIView ,CLLocationManagerDelegate{
    
    static let instance = AlertTurnOnLocation()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var okbtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertTurnOnLocation", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        img.layer.cornerRadius = 30
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 1
        
        alertView.layer.cornerRadius = 10
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        manager.delegate = self
    }
    
    var type = 0
    enum AlertType {
        case location
        case camera
    }
      var manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)) && flagType == 0 {
            parentView.removeFromSuperview()
        }
    }
    
    
    var flagType = 0 ;
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        self.titleLbl.text = title
        self.messageLbl.text = message
        
        switch alertType {
        case .location:
              okbtn.setTitle("Bật vị trí", for: .normal)
        case .camera:
            flagType = 1
            okbtn.setTitle("Bật camera", for: .normal)
        }

        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    @IBAction func onClickTurnOnLocation(_ sender: Any) {
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
