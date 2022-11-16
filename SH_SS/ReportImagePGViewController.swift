//
//  ReportImagePGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/20/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class ReportImagePGViewController: UIViewController,TaskDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    
    func addTask(data: Array<Any>) {
        DispatchQueue.main.async {
            self.addSavingPhotoView(_titleActivity: "Đang Load")
        }
        if data.count == 0
        {
            self.arrImg = []
            self.colectionView.reloadData()
            self.boxView.removeFromSuperview()
            return
        }
        
        self.arrImg = data as! [ListReportImg]
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
            self.colectionView.reloadData()
            self.boxView.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var colectionView: UICollectionView!
    @IBOutlet weak var OutAdd: UIButton!
    @IBOutlet weak var OutSeach: UIButton!
    
    
    var  arrImg = [ListReportImg]()
    var PhotoArray = [UIImage]()
    var boxView = UIView()
    var activityView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.colectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.colectionView.frame.width - 20 ) / 1.6 , height: self.colectionView.frame.height / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetListPCRoundUploadImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popupSeachReportImg"
        {
            let showpopup : PopupSeachReportImgPGViewController = segue.destination as! PopupSeachReportImgPGViewController
            showpopup.delegate = self
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebCell", for: indexPath) as! WebCollectionViewCell
        let DocumentName : String = arrImg[indexPath.item].DocumentPath
        let replacePath  = DocumentName.replacingOccurrences(of: "\\", with: "/")
        let substringStr = replacePath.substring(from: 3)
        let urlString =  "http://appapi.sunhouse.com.vn/" + substringStr + "/" + arrImg[indexPath.item].DocumentName
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        cell.web.load(URLRequest(url: url!))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        confirm()
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
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //Mở giao diện chọn ảnh từ album
    func chooseLibrary() {
        let library  : ChooseLibraryPGViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseLibraryPG") as? ChooseLibraryPGViewController)!
        self.navigationController?.pushViewController(library, animated: true)
    }
    
    //Mở giao diện chụp ảnh từ camera
    func chooseCamera() {
        let camera  : ImageReportViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImageReport") as? ImageReportViewController)!
        self.navigationController?.pushViewController(camera, animated: true)
    }
    
    func addSavingPhotoView(_titleActivity : String) {
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = _titleActivity
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    func GetListPCRoundUploadImage()
    {
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
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
