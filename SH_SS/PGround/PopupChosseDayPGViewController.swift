//
//  PopupChosseDayPGViewController.swift
//  SH_SS
//
//  Created by Hung on 5/27/19.
//  Copyright © 2019 phạm Hưng. All rights reserved.
//

import UIKit
import GCCalendar

extension PopupChosseDayPGViewController: GCCalendarViewDelegate {
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        OutDate.text = udate
    }
}

class PopupChosseDayPGViewController: UIViewController {

    @IBOutlet weak var OutDate: UILabel!
    @IBOutlet weak var ViewPicker: UIView!
     var delegate : DayDelegate? = nil
    fileprivate var calendarView: GCCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addCalendarView()
        self.addConstraints()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        
        OutDate.text = udate
    }
    
    @objc func today() {
        
        self.calendarView.select(date: Date())
    }
    
    @objc func displayMode() {
        
        self.calendarView.displayMode = (self.calendarView.displayMode == .month) ? .week : .month
    }
    
    func addCalendarView() {
        
        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.calendarView)
    }
    
    func addConstraints() {
        self.calendarView.topAnchor.constraint(equalTo: self.ViewPicker.topAnchor, constant: 4).isActive = true
        self.calendarView.leftAnchor.constraint(equalTo: self.ViewPicker.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.ViewPicker.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalTo: self.ViewPicker.heightAnchor,constant: 4).isActive = true
    }
    
    @IBAction func AcBtnToday(_ sender: Any) {
        
        today()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let  udate = formatter.string(from: date)
        OutDate.text = udate
    }
    
    @IBAction func btnDone(_ sender: Any) {
        self.delegate?.addDay(data: OutDate.text!)
        navigationController?.popViewController( animated: true)
    }
}

protocol DayDelegate {
    func addDay(data:String)
}
