//
//  PC_UploadImageViewController.swift
//  SH_SS
//
//  Created by Hung on 7/30/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit

class PC_UploadImageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var colectionView: UICollectionView!
    
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
        
        
        let backBTN = UIBarButtonItem(image: UIImage(named: "icons8-back-24"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
    }
    
    @IBAction func add(_ sender: Any) {
        confirm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetListPCUploadImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebCellPC", for: indexPath) as! WebCollectionViewCell
        //let DocumentName : String = arrImg[indexPath.item].DocumentPath
        //let replacePath  = DocumentName.replacingOccurrences(of: "\\", with: "/")
        //let substringStr = replacePath.substring(from: 3)
        let urlString =  arrImg[indexPath.item].UrlDoc
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        cell.web.load(URLRequest(url: url!))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    //Confirm Chọn hình ảnh
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
        let library  : PC_ChooseImageInLibraryViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PC_ChooseImageInLibrary") as? PC_ChooseImageInLibraryViewController)!
        self.navigationController?.pushViewController(library, animated: true)
    }
    
    //Mở giao diện chụp ảnh từ camera
    func chooseCamera() {
        let camera  : PC_ChooseImageInCameraViewController  = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PC_ChooseImageInCamera") as? PC_ChooseImageInCameraViewController)!
        self.navigationController?.pushViewController(camera, animated: true)
    }
    
    //Danh sách dữ liệu báo cáo hình ảnh
    func GetListPCUploadImage()
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
        
        let cmp : String =  UserDefaults.standard.string(forKey: "cmp_wwnPG") ?? "noCmp"
        let userLogin : String =  UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let urlString =  "http://appapi.sunhouse.com.vn/api/Document/GetListPCUploadImage?cmp_wwn=\(cmp)&username=\(userLogin)&udate=\(udate)"
        
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
}
