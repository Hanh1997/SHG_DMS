//
//  SplashScreenViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 4/12/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import SystemConfiguration

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//            self.isConnectedToNetwork() {response in
//                if response == false
//                {
//                        DispatchQueue.main.async {
//                                let alert = UIAlertController(title: "Cảnh báo", message: "Không có kết nối internet hoặc tín hiệu yếu không thể kết nối", preferredStyle: UIAlertController.Style.alert)
//
//                                // add an action (button)
//                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
//
//                                // show the alert
//                                self.present(alert, animated: true, completion: nil)
//                        }
//                }
//                else
//                {
//                      DispatchQueue.main.async {
//                        self.perform(#selector(self.showNavication), with: nil, afterDelay:0.5)
//                    }
//                }
//            }
        DispatchQueue.main.async {
                            self.perform(#selector(self.showNavication), with: nil, afterDelay:0.3)
                        }
    }
    
    @objc public func showNavication()
    {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Latitude")
        defaults.removeObject(forKey: "Longitude")
        defaults.removeObject(forKey: "cmp_wwn")
        defaults.removeObject(forKey: "cmp_name")
        
        defaults.removeObject(forKey: "LatitudePG")
        defaults.removeObject(forKey: "LongitudePG")
        defaults.removeObject(forKey: "cmp_wwnPG")
        defaults.removeObject(forKey: "cmp_namePG")
        defaults.synchronize()
   
        let token = UserDefaults.standard.string(forKey: "AccessToken")
        if token != nil
        {
            DispatchQueue.main.async(){
                self.func_checkToken(_token: token!)
            }
        }
        else
        {
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "ShowView", sender: self)
            }
        }
    }

    
    let defaults = UserDefaults.standard
    let currentAppVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
    
    func saveCurrentVersionToDefaults() {
        // saves currentAppVersion to defaults
        defaults.set(currentAppVersion, forKey: "appVersion")
        defaults.synchronize()
    }
    
    //Check version
    func hasAppBeenUpdated() -> Bool {
        
        var appUpdated = false // indicates whether app has been updated or not
        
        let previousAppVersion = defaults.string(forKey: "appVersion") // checks stored app version in NSUserDefaults
        
        if previousAppVersion == nil {
            // first run, no appVersion has ever been saved to NSUserDefaults
            saveCurrentVersionToDefaults()
            
        } else
            //if previousAppVersion != currentAppVersion
        {
            // app versions are different, thus the app has been updated
            saveCurrentVersionToDefaults()
            appUpdated = true
            
        }
        return appUpdated
    }
    
    
    //Nếu có sự thay đổi vesion bắt buộc người dùng update
    func checkVesion()
    {
        let checkVersion = hasAppBeenUpdated()
        
        if checkVersion == false {
            let token = UserDefaults.standard.string(forKey: "AccessToken")
            if token != nil
            {
                DispatchQueue.main.async(){
                    self.func_checkToken(_token: token!)
                }
            }
            else
            {
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "ShowView", sender: self)
                }
            }
        }
        else
        {
            //Vesion hiện tại
            let _  : String = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
            
            //let versionOfLastRun = UserDefaults.standard.object(forKey: "appVersion") as? String
            
            //call api apple để check
            let storeInfoURL = URL(string: "https://itunes.apple.com/vn/lookup?bundleId=com.sunhouse.dms0001")!
            let request = URLRequest(url: storeInfoURL)
            
            //making the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    if  let results = json!["results"] as? NSArray {
                        let entry = results.firstObject as? NSDictionary
                        let _  :String = (entry!["version"] as? String)!
                        
                        //let appVersionC : Double = Double(appVersion) ?? 0
                        
                        let token = UserDefaults.standard.string(forKey: "AccessToken")
                        if token != nil
                        {
                            DispatchQueue.main.async(){
                                self.func_checkToken(_token: token!)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async(){
                                self.performSegue(withIdentifier: "ShowView", sender: self)
                            }
                        }
                        
                        
//                        if ourVersion  != appVersion
//                        {
//                            DispatchQueue.main.async {
//                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                                newViewController.flagCheckVesion  = true
//                                newViewController.modalPresentationStyle = .fullScreen
//                                self.present(newViewController, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            let token = UserDefaults.standard.string(forKey: "AccessToken")
//                            if token != nil
//                            {
//                                DispatchQueue.main.async(){
//                                    self.func_checkToken(_token: token!)
//                                }
//                            }
//                            else
//                            {
//                                DispatchQueue.main.async(){
//                                    self.performSegue(withIdentifier: "ShowView", sender: self)
//                                }
//                            }
//                        }
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            task.resume()
            
        }
        

    }
    
    //Check token
    func func_checkToken(_token : String)
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/account/LoginViaToken?token=\(_token)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if (json?["AccessToken"] as? String) != nil
                {
                    let names = json?["FullName"] as? String
                    UserDefaults.standard.setValue(names, forKey: "FullName")
                    
                    DispatchQueue.main.async(){
                      self.performSegue(withIdentifier: "SWReveal", sender: self)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        newViewController.modalPresentationStyle = .fullScreen
                        self.present(newViewController, animated: true, completion: nil)
                    }
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
    
    private var urlSession:URLSession = {
        var newConfiguration:URLSessionConfiguration = .default
        newConfiguration.waitsForConnectivity = false
        newConfiguration.allowsCellularAccess = true
        return URLSession(configuration: newConfiguration)
    }()
    

    //Checking NetWork
    func isConnectedToNetwork(completion: @escaping (Bool)->())
    {
        let urlString =  "http://google.com/"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 2.0
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse =  response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                    return
                }
                else
                {
                    completion(false)
                    return
                }
            }
            else
            {
                completion(false)
                return
            }
        }
        task.resume()
    }
}
