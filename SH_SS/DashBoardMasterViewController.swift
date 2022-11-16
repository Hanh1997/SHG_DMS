//
//  DashBoardMasterViewController.swift
//  SH_SS
//
//  Created by phạm Hưng on 5/1/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CustomLabelsXAxisValueFormatter : NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let count = self.labels.count
        
        guard let axis = axis, count > 0 else {
            
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            
            return self.labels[index]
        }
        
        return ""
    }
}

class DashBoardMasterViewController: UIViewController  ,ChartViewDelegate,UITableViewDelegate,UITableViewDataSource {

    var ListVistPlan = [VisitPlan]()
    
    @IBOutlet weak var KPIPunishMoney: UIButton!
    @IBOutlet weak var BarChartDetail: BarChartView!
    @IBOutlet weak var BarChartMaster: BarChartView!
    @IBOutlet weak var ViewTotal: UIView!
    @IBOutlet weak var tblVistDay: UITableView!
    @IBOutlet weak var lb360: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        InitChartMaster()
        
        //Vẽ chart doanh số tông
        getDataForChartMater()
        
        
        //Mã hàng trọng tâm
        GetDMSItemProcessData()
        
        //Thăm điểm bán
        //GetDataVistPlan()
        
        //Tính số tiền bị phạt
        GetKPIPunishMoneyByUserName()
        

        //Phân quyền truy cập app cho Sale và PC
        let tabBarController = self.tabBarController
        let jobtitle :String = UserDefaults.standard.string(forKey: "jobtitle")!
        if  jobtitle == "NVBHST" {
            tabBarController?.viewControllers?.remove(at: 1)
            tabBarController?.viewControllers?.remove(at: 3)
        }
        else
        {
            tabBarController?.viewControllers?.remove(at: 0)
            //tabBarController?.viewControllers?.remove(at: 1)
            tabBarController?.viewControllers?.remove(at: 2)
        }
        
        //ViewTotal.layer.cornerRadius = 10
    }
    
    @IBAction func DetailMoneyAction(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMoney") as! DetailMoneyViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    //Doanh số tổng
    func InitChartMaster()  {
        //legend
        let legend = BarChartMaster.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        legend.textColor = UIColor.black
        
        // Y - Axis Setup
        let yaxis = BarChartMaster.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        yaxis.labelTextColor = UIColor.black
        yaxis.axisLineColor = UIColor.black
        
        BarChartMaster.rightAxis.enabled = false
        
        // X - Axis Setup
        let xaxis = BarChartMaster.xAxis
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        formatter.labels = self.arrName
        xaxis.valueFormatter = formatter
        
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.labelTextColor = UIColor.black
        xaxis.centerAxisLabelsEnabled = true
        xaxis.axisLineColor = UIColor.black
        xaxis.granularityEnabled = true
        xaxis.enabled = true
        
        
        BarChartMaster.delegate = self
        BarChartMaster.noDataText = "You need to provide data for the chart."
        BarChartMaster.noDataTextColor = UIColor.white
        BarChartMaster.chartDescription?.textColor = UIColor.clear
    }
    
    
    
    func InitChartDetail()  {
        //legend
        let legend = BarChartDetail.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10;
        legend.xOffset = 10;
        legend.yEntrySpace = 0;
        legend.textColor = UIColor.black
        
        // Y - Axis Setup
        let yaxis = BarChartDetail.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        yaxis.labelTextColor = UIColor.black
        yaxis.axisLineColor = UIColor.black
        
        BarChartDetail.rightAxis.enabled = false
        
        // X - Axis Setup
        let xaxis = BarChartDetail.xAxis
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        formatter.labels = self.arrName
        xaxis.valueFormatter = formatter

        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.labelTextColor = UIColor.black
        xaxis.centerAxisLabelsEnabled = true
        xaxis.axisLineColor = UIColor.black
        xaxis.granularityEnabled = true
        xaxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 7.0)!
        xaxis.enabled = true
        
        
        BarChartDetail.delegate = self
        BarChartDetail.noDataText = "You need to provide data for the chart."
        BarChartDetail.noDataTextColor = UIColor.white
        BarChartDetail.chartDescription?.textColor = UIColor.clear
    }
    
    //Mã hàng trọng tâm
    func setChartDetail(dataPoints : [String], values : [Int] , values1 : [Int]){
        BarChartDetail.noDataText = "Nothining to display"

        var dataEntries : [BarChartDataEntry] = []
        var dataEntries1 : [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(values[i]))
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(values1[i]))
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Kế hoạch")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Thực hiện")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [Colors.orange]
        chartDataSet1.colors =  [Colors.green]
        
        let chartData = BarChartData(dataSets: dataSets)
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3

        chartData.barWidth = barWidth
        BarChartDetail.xAxis.axisMinimum = 0
        BarChartDetail.xAxis.axisMaximum = 0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(self.arrName.count)
        
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        BarChartDetail.xAxis.granularity = BarChartDetail.xAxis.axisMaximum / Double(self.arrName.count)
        
        BarChartDetail.notifyDataSetChanged()
        BarChartDetail.data = chartData

        //background color
        //BarChartDetail.backgroundColor = Colors.white
        BarChartDetail.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .linear)

    }
    
    func setChart(dataPoints : [String], values : [Double] , values1 : [Double]){
        BarChartMaster.noDataText = "Nothining to display"
        var dataEntries : [BarChartDataEntry] = []
        var dataEntries1 : [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: values[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: values1[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Kế hoạch")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Tính thưởng")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [Colors.orange]
        chartDataSet1.colors =  [Colors.green]
        
        let chartData = BarChartData(dataSets: dataSets)
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3

        chartData.barWidth = barWidth
        BarChartMaster.xAxis.axisMinimum = 0.0
        BarChartMaster.xAxis.axisMaximum = 0.0 + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(self.arrNameMater.count)
        
        chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        
        BarChartMaster.xAxis.granularity = BarChartMaster.xAxis.axisMaximum / Double(self.arrNameMater.count)
        
        BarChartMaster.notifyDataSetChanged()
        BarChartMaster.data = chartData
        
        //background color
        //BarChartMaster.backgroundColor = Colors.white
        BarChartMaster.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .linear)
        
    }
    
    //Doanh số tổng
    var arrNameMater = [String]()
    var arrTargetMaster = [Double]()
    var arrDebSaleMaster = [Double]()
    
    
    //Mã hàng trong tâm
    var arrName = [String]()
    var arrTargetQuantity = [Int]()
    var arrSaleQuantity = [Int]()
    
    //Doanh số kế hoạch, doanh số tính thưởng ALL
    func getDataForChartMater()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetMTProcessSaleTartget?username=\(userName)&viewdate=\(udate)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                        for dic in JsonData
                        {
                            if let IndustryCode = dic["IndustryCode"] as? String
                            {
                                if IndustryCode == "ALL"
                                {
                                    self.arrNameMater.append(IndustryCode)
                                    let TargetAmount = dic["TargetAmount"] as? Double
                                    self.arrTargetMaster.append(TargetAmount! / 1000000)
                                    let DebSaleAmount = dic["DebSaleAmount"] as? Double
                                    self.arrDebSaleMaster.append(DebSaleAmount! / 1000000)
                                }
                            }
                        }
                       DispatchQueue.main.async {
                            self.setChart(dataPoints: self.arrNameMater, values: self.arrTargetMaster, values1: self.arrDebSaleMaster)
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    
    //Mã hàng trọng tâm
    func GetDMSItemProcessData()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetDMSItemProcessData?username=\(userName)&viewdate=\(udate)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        let JsonData = json!["ResponseData"] as? [[String: Any]] ?? []
                        for dic in JsonData
                        {
                            
                            let ItemCode = dic["Itemcode"] as? String
                            self.arrName.append(ItemCode!)
                            
                            let TargetQuantity = dic["TargetQuantity"] as? Int
                            self.arrTargetQuantity.append(TargetQuantity ?? 0)
                            
                            let SaleQuantity = dic["SaleQuantity"] as? Int
                            self.arrSaleQuantity.append(SaleQuantity ?? 0)
                            
                        }
                       DispatchQueue.main.async {
                            self.InitChartDetail()
                        self.setChartDetail(dataPoints: self.arrName, values: self.arrTargetQuantity, values1: self.arrSaleQuantity)
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListVistPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as? DashboardTableViewCell else
        {
            return UITableViewCell()
        }
        cell.imgStt.image = nil
        cell.tag = indexPath.row
        cell.lbCmpName.text = ListVistPlan[indexPath.row].cmp_name
        cell.LbVistDay.text = ListVistPlan[indexPath.row].strVistDay
        DispatchQueue.main.async {
            if(cell.tag == indexPath.row)
            {
                if self.ListVistPlan[indexPath.row].Approval == true
                {
                    cell.imgStt?.image = UIImage(named: "Accept-icon")
                }
            }
        }
        cell.backgroundColor = Colors.white
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //Danh sách điểm bán
    func GetDataVistPlan()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetListVisitPlan?username=\(userName)&viewmonth=\(udate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        let checkData = json!["ResponseData"] as? NSDictionary
                        
                        if checkData!.count > 0
                            {
                                let JsonData = checkData!["Result"] as? [[String: Any]] ?? []
                                for dic in JsonData
                                {
                                    self.ListVistPlan.append(VisitPlan(dic))
                                }
                                DispatchQueue.main.async {
                                    self.tblVistDay.reloadData()
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
    
    //Thông báo lỗi
    func GetKPIPunishMoneyByUserName()
    {
        let username = "trieupv"
        let password = "phamtrieu"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        let userName :String = UserDefaults.standard.string(forKey: "UserName")!
        
        // create the request
        let url = URL(string: "http://appapi.sunhouse.com.vn/api/DMS/GetKPIPunishMoneyByUserName?username=\(userName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                if let chek = json?["ResponseStatus"] as? String {
                    if(chek == "OK")
                    {
                        let Response = json!["ResponseData"] as? [String]
                        
                       if((Response?.count)! > 0)
                       {
                            DispatchQueue.main.async {
                                self.lb360.text =  Response![0]
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                  self.lb360.text =  ""
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

class  VisitPlan {
    var cmp_name : String
    var strVistDay : String
    var Approval : Bool
    init(_ dictionary: [String: Any]) {
        self.cmp_name = dictionary["cmp_name"] as? String ?? ""
        self.strVistDay = dictionary["strVistDay"] as? String ?? ""
        self.Approval = dictionary["Approval"] as? Bool ?? false
    }
}
