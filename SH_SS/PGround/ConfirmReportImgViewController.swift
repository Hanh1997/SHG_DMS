//
//  ConfirmReportImgViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 4/21/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ConfirmReportImgViewController: UIViewController,TaskDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    func addTask(data: Array<Any>) {
        DispatchQueue.main.async {
         self.addSavingPhotoView()
        }
        self.arrImg = data as! [ListReportImg]
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
            self.colectionView.reloadData()
            self.container.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var colectionView: UICollectionView!

    var  arrImg = [ListReportImg]()
    var PhotoArray = [UIImage]()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colectionView.delegate = self
        colectionView.dataSource = self
        
        let layout = self.colectionView.collectionViewLayout as! UICollectionViewFlowLayout
         layout.minimumLineSpacing = 10
         layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left:10, bottom: 0, right: 10)
       
       
        //let size = self.colectionView.bounds.width - 15 / 2
        //let size2 = self.colectionView.frame.width - 15 / 2
        layout.itemSize = CGSize(width: (self.colectionView.bounds.width ) / 2 , height: self.colectionView.frame.height / 2)
        
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        
        //self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(confirm)), animated: true)
        
        //colectionView.isUserInteractionEnabled = false
    }
    
    @IBAction func add(_ sender: Any) {
        confirm()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.GetListPCRoundUploadImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopupImg"
        {
            let showpopup : PopUpSeachImageViewController = segue.destination as! PopUpSeachImageViewController
            showpopup.delegate = self
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebCell", for: indexPath) as! WebCollectionViewCell
        let urlString =   arrImg[indexPath.item].UrlDoc
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        cell.web.load(URLRequest(url: url!))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ok")

    }
    
    func confirm()
    {
        let optionMenu = UIAlertController(title: nil, message: "Chọn hình thức tải ảnh", preferredStyle: .actionSheet)
        
        let actionLibrary = UIAlertAction(title: "Chọn ảnh từ thư viện", style: .destructive, handler:{ (action) in
            self.chooseLibrary()
        })
        let actionCamera = UIAlertAction(title: "Chụp bằng camera", style: .default, handler:{ (action) in
            self.chooseCamera()
        })
        let actionClose = UIAlertAction(title: "Đóng", style: .cancel, handler: nil)
        
        optionMenu.addAction(actionLibrary)
        optionMenu.addAction(actionCamera)
        optionMenu.addAction(actionClose)
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //Mở giao diện chọn ảnh từ album
    func chooseLibrary() {
        let library  : ReportImageViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportImage") as? ReportImageViewController)!
        self.navigationController?.pushViewController(library, animated: true)
    }
    
    //Mở giao diện chụp ảnh từ camera
    func chooseCamera() {
        let camera  : ImageReportViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImageReport") as? ImageReportViewController)!
        self.navigationController?.pushViewController(camera, animated: true)
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
    
    func GetListPCRoundUploadImage()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.addSavingPhotoView()
            }
        }
        
        arrImg.removeAll()
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwn") ?? "noCmp"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/Document/GetListPCRoundUploadImage?cmp_wwn=\(cmp)&username=\(userLogin)&udate=\(udate)"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        DispatchQueue.global(qos: .userInitiated).async {                      
                            DispatchQueue.main.async {
                                self.activityView.stopAnimating()
                                self.container.removeFromSuperview()
                                let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                                for dic in JsonData
                                {
                                    self.arrImg.append(ListReportImg(dic))
                                }
                                 self.colectionView.reloadData()
                            }
                        }
                    }
                    
                    else if chek == "ERR"
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
                                let alert = UIAlertController(title: "Thông báo", message: json?["Message"] as? String, preferredStyle: UIAlertController.Style.alert)
                                
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Đóng", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                self.activityView.stopAnimating()
                self.container.removeFromSuperview()
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

extension String {
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
    }
}
