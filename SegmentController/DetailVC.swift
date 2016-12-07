//
//  DetailVC.swift
//  SegmentController
//
//  Created by Frank.Chen on 2016/12/6.
//  Copyright © 2016年 Frank.Chen. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var selectedIndex: Int = 0
    var mode: Int32 = 0 // 0=科別, 1=日期, 2=醫生
    var dataArray = [[AnyObject]]()
    var detailTbl: UITableView!
    var cellH: CGFloat = 0
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.cellH = self.view.frame.height / 10
        
        // navigation title
        self.navigationItem.title = "行動掛號"
        
        // JSON格式資料網址
        if self.mode == 0 {
            // 載入科別的資料
            url = URL(string: "http://www.json-generator.com/api/json/get/ckcJXJzBQi?indent=2")!
        } else if self.mode == 2 {
            
        } else {
            
        }
        
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
            let dataDic = try JSONSerialization.jsonObject(with: NSData(contentsOf: location as URL)! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : [String : AnyObject]]
            
            // 將Dictionary存放在陣列裡
            self.dataArray = dataDic["result"]!["doctor"] as! [[AnyObject]]
            
            // 產生元件
            self.generatorComponent()
        } catch {
            print("Error!")
        }
    }
    
    /// 產生元件
    func generatorComponent() {
        // 產生tableView
        self.detailTbl = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64), style: .plain)
        self.detailTbl.backgroundColor = UIColor.white
        self.detailTbl.dataSource = self
        self.detailTbl.delegate = self
        self.view.addSubview(self.detailTbl)
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
        let displayCellId: String = "detailCell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: displayCellId) as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: displayCellId)
            cell!.selectionStyle = .none // 選取的時侯無背景色
            cell?.textLabel?.font = UIFont.systemFont(ofSize: cell!.frame.height * 0.6)
            cell?.detailTextLabel?.textColor = UIColor.gray
        }
        
        // title
        cell?.textLabel?.text = self.dataArray[self.selectedIndex][indexPath.row]["Name"] as? String
        
        // detail
        cell?.detailTextLabel?.text = (self.dataArray[self.selectedIndex][indexPath.row]["Date"] as? String)! + "\t" + (self.dataArray[self.selectedIndex][indexPath.row]["Room"] as? String)!
        
        return cell!
    }

}
