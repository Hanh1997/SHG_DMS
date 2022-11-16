//
//  MapViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 3/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController,MKMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var MapView: MKMapView!
    var userlatitude : Double = 0
    var userlongitude : Double = 0
    var cmplatitude : Double = 0
    var cmplongitude : Double = 0
    var cmpName : String = ""
    var newAnnotion = MKPointAnnotation()
    var newAnnotion2 = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        newAnnotion = MKPointAnnotation()
        newAnnotion2 = MKPointAnnotation()
        
        let locationUser = CLLocationCoordinate2D(latitude: userlatitude, longitude: userlongitude)
        let locationCmp = CLLocationCoordinate2D(latitude: cmplatitude, longitude: cmplongitude)
        let region = MKCoordinateRegion(center: locationUser, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        MapView.setRegion(region, animated: true)
        MapView.removeAnnotation(newAnnotion)
        MapView.removeAnnotation(newAnnotion2)
        
        newAnnotion = MKPointAnnotation()
        newAnnotion.coordinate = locationUser
        newAnnotion.title      = UserDefaults.standard.string(forKey: "FullName")
        newAnnotion.subtitle   = ""
        
        newAnnotion2 = MKPointAnnotation()
        newAnnotion2.coordinate = locationCmp
        newAnnotion2.title      = cmpName
        newAnnotion2.subtitle   = ""
        

        MapView.addAnnotation(newAnnotion)
        MapView.addAnnotation(newAnnotion2)
    }
}
