//
//  ViewController.swift
//  SegmentController
//
//  Created by Frank.Chen on 2016/12/5.
//  Copyright © 2016年 Frank.Chen. All rights reserved.
//

import UIKit
import Foundation

class MainVC: UIViewController, DidSelectedRowDelegate {
        
    var sectionVC: SectionVC?
    var dateVC: DateVC?
    var doctorVC: DoctorVC?
    var detailVC: DetailVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定導覽列的抬頭
        self.navigationItem.title = "行動掛號"
        
        // 返回按鈕(中文化)
        let backItem: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: self, action: nil)
        backItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.navigationItem.backBarButtonItem = backItem
        
        let mySegmentedControl = UISegmentedControl(items: ["科別","日期","醫師"])
        
        mySegmentedControl.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 30)
        
        // 預設選取的tab(index)
        mySegmentedControl.selectedSegmentIndex = 0
        
        // 設定字體顏色
        mySegmentedControl.tintColor = UIColor.blue
        
        // 設定背景色
        mySegmentedControl.backgroundColor = UIColor.white
        
        // 點擊tab觸發的事件
        mySegmentedControl.addTarget(self, action: #selector(MainVC.segmentedValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(mySegmentedControl)
        
        self.sectionVC = SectionVC()
        self.sectionVC?.delegate = self
        self.sectionVC?.view.frame = CGRect(x: 0, y: 94, width: self.view.frame.width, height: self.view.frame.height)
        
        self.dateVC = DateVC()
        self.dateVC?.view.frame = CGRect(x: 0, y: 94, width: self.view.frame.width, height: self.view.frame.height)
        
        self.doctorVC = DoctorVC()
        self.doctorVC?.view.frame = CGRect(x: 0, y: 94, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview((self.sectionVC?.view)!)
        self.view.addSubview((self.dateVC?.view)!)
        self.view.addSubview((self.doctorVC?.view)!)
        
        // 預設隱藏日期和醫生的view
        self.dateVC?.view.isHidden = true
        self.doctorVC?.view.isHidden = true
    }
    
    
    /// 點擊tab觸發事件
    ///
    /// - Parameter sender: UISegmentedControl
    func segmentedValueChanged(_ sender: UISegmentedControl!) {
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 0:
            self.sectionVC?.view.isHidden = false
            self.dateVC?.view.isHidden = true
            self.doctorVC?.view.isHidden = true
        case 1:
            self.sectionVC?.view.isHidden = true
            self.dateVC?.view.isHidden = false
            self.doctorVC?.view.isHidden = true
        default:
            self.sectionVC?.view.isHidden = true
            self.dateVC?.view.isHidden = true
            self.doctorVC?.view.isHidden = false
        }        
    }    
    
    /// 點選cell觸發的delegate
    ///
    /// - Parameters:
    ///   - index: 點選的row index
    ///   - mode: 0=科別, 1=日期, 2=醫生
    func didSelectedRow(atIndex index: Int, mode: Int32) {
        self.detailVC = DetailVC()
        self.detailVC.selectedIndex = index
        self.detailVC.mode = mode
        self.navigationController?.pushViewController(self.detailVC!, animated: true)        
    }
    
}
