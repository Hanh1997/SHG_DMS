//
//  CheckInPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import AVFoundation

class CheckInPGViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,
URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate ,CLLocationManagerDelegate{
  
  

    @IBOutlet weak var div5: UIView!
    @IBOutlet weak var div4: UIView!
    @IBOutlet weak var div1: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div3: UIView!
    
    @IBOutlet weak var txtFullname: UILabel!
    @IBOutlet weak var txtCmp_name: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var btnButonCamera: UIButton!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var MyImage: UIImageView!
    
    var cmp_wwn : String = ""
    var LatCus : Double = 0
    var LongCus : Double = 0
    var model = [StrCmp]()
    var userlatitude : Double = 0
    var userlongitude : Double = 0
    var location : String = ""
    var distanceResult : Double = 0
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    var imagrpath : String = ""
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            userlatitude =  manager.location!.coordinate.latitude
            userlongitude =  manager.location!.coordinate.longitude
        }

        let distanceCaculator : Double = caculatorDistance(_LatUser: userlatitude, _LongUser: userlongitude, _LatCus: LatCus, _LongCus: LongCus)
        if distanceCaculator > 300
        {
            lbDistance.textColor = Colors.red
        }
        lbDistance.text =  String(distanceCaculator) + "mét"
        
        
        func_camera();
        getAddressFromLatLon(Latitude: userlatitude,Longitude: userlongitude)

        
        MyImage.layer.borderWidth = 1
        MyImage.layer.masksToBounds = false
        MyImage.layer.borderColor = UIColor.black.cgColor
        MyImage.layer.cornerRadius = MyImage.frame.height/2
        MyImage.clipsToBounds = true
        txtFullname.text = UserDefaults.standard.string(forKey: "FullName") ?? ""
        txtCmp_name.text = UserDefaults.standard.string(forKey: "cmp_namePG") ?? ""
        
        div1.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div2.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div3.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        div5.addBorder(.bottom, color: .lightGray, thickness: 0.5)
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)) && AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            userlatitude =  manager.location!.coordinate.latitude
            userlongitude =  manager.location!.coordinate.longitude
            let distanceCaculator : Double = caculatorDistance(_LatUser: userlatitude, _LongUser: userlongitude, _LatCus: LatCus, _LongCus: LongCus)
            if distanceCaculator > 300
            {
                lbDistance.textColor = Colors.red
            }
            lbDistance.text =  String(distanceCaculator) + "mét"
        }
    }
    
    func getAddressFromLatLon(Latitude: Double, Longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()


        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Latitude
        center.longitude = Longitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }

                    self.txtLocation.text = addressString
                    print(addressString)
              }
        })

    }
    
    @IBAction func btnCamera(_ sender: Any) {
        func_camera()
    }
    
    
    @IBAction func checkInOfPGAction(_ sender: Any) {
        if (MyImage.image == nil) {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chụp ảnh,vui lòng chụp ảnh", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        if cmp_wwn == ""
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa chọn điểm bán", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        else
        {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    // create the alert
                    let alert = UIAlertController(title: "Thông  báo", message: "Bạn có đồng ý check In không?", preferredStyle: UIAlertController.Style.alert)
                    
                    let cancelAction = UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(cancelAction)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "Đồng ý", style: .destructive) { (action:UIAlertAction!) in
                        self.addSavingPhotoView()
                        self.func_UploadImage(chorimage: self.MyImage.image!)
                    }
                    alert.addAction(OKAction)
                   
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //camera
    func func_camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .front
            
            self.present(imagePicker, animated:true,completion:nil)
        }
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pigkedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.MyImage.contentMode = .scaleToFill
            self.MyImage.image = pigkedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    var container: UIView = UIView()
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
    
    
    func callApiGetAdress(key:String)
    {
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(userlatitude),\(userlongitude)&key=\(key)")
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let status = json!.object(forKey: "status")! as? String
                {
                    if (status == "OK")
                    {
                        if let results = json!.object(forKey: "results")! as? [NSDictionary] {
                            if results.count > 0
                            {
                                if results[0]["address_components"]! is [NSDictionary] {
                                    let  address : String = (results[0]["formatted_address"] as? String)!
                                    self.txtLocation.text = address
                                    semaphore.signal()
                                }
                            }
                        }
                    }
                    else
                    {
                        semaphore.signal()
                    }

                }

            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        semaphore.wait()
    }
    
    
    //Tính đường chim bay
    func caculatorDistance(_LatUser :Double ,_LongUser : Double , _LatCus : Double , _LongCus : Double) -> Double
    {
        let coordinateCus = CLLocation(latitude: _LatCus, longitude: _LongCus)
        let coordinateUser = CLLocation(latitude: _LatUser, longitude: _LongUser)
        let distanceInMeters = coordinateCus.distance(from: coordinateUser)
        distanceResult = distanceInMeters.rounded()
        return distanceInMeters.rounded()
    }
    //Check in
    func checkIn(_cmp : String,_lat : Double, _Long : Double,_Distance:Double,_pathImg : String)
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let login = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64Login = login.base64EncodedString()
        
        // create the request
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        let urlString = "http://appapi.sunhouse.com.vn/api/DMS/SaveCheckInData?cmp_wwn=\(_cmp)&latitude=\(_lat)&longitude=\(_Long)&username=\(userName)&distance=\(_Distance)&sysnote=appIos&imagepath=\(_pathImg)&&actioncode=CheckIn"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
        
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
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: "Check in thành công", preferredStyle: UIAlertController.Style.alert)
                                
                                let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                    self.back()
                                })
                                alert.addAction(actionback)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.global(qos: .userInitiated).async {
                            DispatchQueue.main.async {
                                // create the alert
                                let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                let actionback = UIAlertAction(title: "Đóng", style: .default, handler:{ (action) in
                                    self.back()
                                })
                                alert.addAction(actionback)
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                        }
                    }
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.container.removeFromSuperview()
                }
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    //Upload image to server
    func func_UploadImage(chorimage : UIImage)
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let login = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64Login = login.base64EncodedString()
        
        let img = chorimage.jpegData(compressionQuality: 0.0)
        let boundary = UUID().uuidString
        let filename = "avatar.jpg"
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        var urlRequest = URLRequest(url: URL(string: "http://appapi.sunhouse.com.vn/api/Document/UploadFile?appid=b4e56f2e-e1f1-4366-b678-7e23e157639a&username=\(userName)&filetype=image&recordid=")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(img!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData!, options: []) as? NSDictionary
                let ResponseStatus = json?["ResponseStatus"] as? String
                if ResponseStatus == "OK"
                {
                    let itemsArray: NSArray   = json!.object(forKey: "ResponseData") as! NSArray
                    
                    for item in itemsArray as! [Dictionary<String, AnyObject>]
                    {
                        let keyData : String  = (item["Key"] as? String)!
                        if keyData == "Url"
                        {
                             self.imagrpath = (item["Value"] as? String)!
                        }
                    }
                    self.checkIn(_cmp: self.cmp_wwn, _lat: self.userlatitude, _Long: self.userlongitude, _Distance:self.distanceResult , _pathImg: self.imagrpath)
                }
                else if ResponseStatus == "ERR"
                {
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                            self.container.removeFromSuperview()
                            
                            
                            // create the alert
                            let alert = UIAlertController(title: "Thông báo", message: json?["ResponseMessenger"] as? String, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                else
                {
                    DispatchQueue.global(qos: .userInitiated).async {
                        DispatchQueue.main.async {
                            self.activityView.stopAnimating()
                            self.container.removeFromSuperview()

                            // create the alert
                            let alert = UIAlertController(title: "Cảnh báo", message: "Lỗi uploadfile", preferredStyle: UIAlertController.Style.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
                
                
            } catch _ as NSError {
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {

                        self.activityView.stopAnimating()
                        self.container.removeFromSuperview()
                        
                        // create the alert
                        let alert = UIAlertController(title: "Cảnh báo", message: "Lỗi uploadfile", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }).resume()
    }
    
    @IBAction func Ac_Map(_ sender: Any) {
        PassData()
    }
    func PassData()
    {
        let vc : MapViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController)!
        vc.userlatitude = userlatitude
        vc.userlongitude = userlongitude
        vc.cmpName = txtCmp_name.text ?? ""
        vc.cmplatitude = LatCus
        vc.cmplongitude = LongCus
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func back()
    {
        self.navigationController?.popViewController( animated: true)
    }
    
}
