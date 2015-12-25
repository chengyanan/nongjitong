//
//  YNNearByQuestionView.swift
//  nongjitong
//
//  Created by 农盟 on 15/12/25.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit
import CoreLocation

class YNNearByQuestionView: UIView, UITableViewDataSource, UITableViewDelegate {

    
    var coordinate: CLLocationCoordinate2D? {
    
        didSet {
        
            self.loadDataFromServer()
        }
    }
    
    //tableviewDatasource
    var tableViewDataArray = [YNQuestionModel]()
    
    let tableView: UITableView = {
    
        return UITableView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.hidden = true
        
        self.addSubview(tableView)
    }

    
    func loadDataFromServer() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "QuestionManage",
            "a": "getQuestionList",
            "class_id": nil,
            "page": nil,
            "descript_length": nil,
            "is_outline": "Y"
        ]
        
        YNHttpQuestion().getQuestionListWithClassID(params, successFull: { (json) -> Void in
            

            
            if let status = json["status"] as? Int {
                
            print(json)
                
                if status == 1 {
                    
                    let tempdata = json["data"] as! NSArray
                    
                    if tempdata.count > 0 {
                        
                        self.tableViewDataArray.removeAll()
                        
                        for var i = 0; i < tempdata.count; i++ {
                            
                            let model = YNQuestionModel(dict: tempdata[i] as! NSDictionary)
                            
                            self.tableViewDataArray.append(model)
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        
                        //没有数据
    
                        self.tableViewDataArray.removeAll()
                        self.tableView.reloadData()
                    }
                    
                    
                } else if status == 0 {
                    
                    if let msg = json["msg"] as? String {
                        
                        print("问题列表数据获取失败: \(msg)")
                    }
                }
                
            }
            
            
            }) { (error) -> Void in
                
               print("网络错误")
        }
        
        
    }
    
    //MARK:UITableViewDataSource 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "CELL_NearByQuestion"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = "reose"
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tableView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
