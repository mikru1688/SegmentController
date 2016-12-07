//
//  SectionVCViewController.swift
//  SegmentController
//
//  Created by Frank.Chen on 2016/12/5.
//  Copyright © 2016年 Frank.Chen. All rights reserved.
//

import UIKit

class SectionVC: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray = [String]() // 科別資料
    var sectionTbl: UITableView!
    var cellH: CGFloat = 0    
    var delegate: DidSelectedRowDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellH = self.view.frame.height / 10
        self.view.backgroundColor = UIColor.white
        
        // 載入科別的資料
        // JSON格式資料網址
        let url: URL = URL(string: "http://www.json-generator.com/api/json/get/ckcJXJzBQi?indent=2")!
        
        // 建立session設定
        let sessionWithConfigure = URLSessionConfiguration.default
        
        // 設定委任對象為自己
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        // 設定下載網址
        let dataTask = session.downloadTask(with: url)
        
        dataTask.resume()
    }
    
    // 下載完成觸發的Delegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            // 將取得的資料轉型為JSON格式
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location as URL)! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
            
            // 取得科別資料
            self.dataArray = dataDic["result"]!["section"] as! [String]
            
            // 產生元件
            self.generatorComponent()
        } catch {
            print("Error!")
        }
    }
    
    /// 產生元件
    func generatorComponent() {
        // 產生tableView
        self.sectionTbl = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64), style: .plain)
        self.sectionTbl.backgroundColor = UIColor.white
        self.sectionTbl.dataSource = self
        self.sectionTbl.delegate = self
        self.view.addSubview(self.sectionTbl)
    }
    
    // MARK: - DataSource
    // ---------------------------------------------------------------------
    // 設定表格section的列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    // MARK: - Delegate
    // ---------------------------------------------------------------------
    // 設定cell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellH
    }
    
    // 表格的儲存格設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayCellId: String = "sectionCell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: displayCellId) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: displayCellId)
            cell!.selectionStyle = .none // 選取的時侯無背景色
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator // 細節型態(右箭頭)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: cell!.frame.height * 0.6)
        }
        
        // title
        cell?.textLabel?.text = self.dataArray[indexPath.row] as String
        
        return cell!
    }
    
    // 點選儲存格事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectedRow(atIndex: indexPath.row, mode: 0)        
    }
    
}
