//
//  YNScaleView.swift
//  nongjitong
//
//  Created by 农盟 on 15/11/20.
//  Copyright © 2015年 农盟. All rights reserved.
//

import UIKit


protocol YNScaleViewDelegate {

    func scaleViewDoneButtonDidClick(title: String)
}

class YNScaleView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: YNScaleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        setInterface()
        setLayout()
        
        let tgr = UITapGestureRecognizer(target: self, action: "hide")
        self.addGestureRecognizer(tgr)
    }
    
    func show() {
    
        let keyWindow = UIApplication.sharedApplication().keyWindow
        
        self.frame = keyWindow!.bounds
        
        keyWindow?.addSubview(self)
    }
    
    func hide() {
    
        self.removeFromSuperview()
    }

    func setInterface() {
    
        self.addSubview(backgroundView)
        
        self.backgroundView.addSubview(titleLabel)
        self.backgroundView.addSubview(doneButton)
        self.backgroundView.addSubview(separatorView)
        self.backgroundView.addSubview(dataPicker)
        dataPicker.delegate = self
        dataPicker.dataSource = self
        
        doneButton.addTarget(self, action: "doneButtonDidClick", forControlEvents: .TouchUpInside)
    }
    
    func doneButtonDidClick() {
        
        self.delegate?.scaleViewDoneButtonDidClick(titleLabel.text!)
        
        hide()
    }
    
    func setLayout() {
    
        //backgroundView
        Layout().addCenterXYConstraints(backgroundView, toView: self, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(backgroundView, toView: self, multiplier: 0.6, constant: 0)
        Layout().addHeightConstraint(backgroundView, toView: self, multiplier: 0.6, constant: 0)
        
        //titleLabel
        Layout().addTopConstraint(titleLabel, toView: backgroundView, multiplier: 1, constant: 5)
        Layout().addCenterXConstraint(titleLabel, toView: backgroundView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(titleLabel, toView: nil, multiplier: 0, constant: 30)
        Layout().addWidthConstraint(titleLabel, toView: nil, multiplier: 0, constant: 80)
        
        //doneButton
        Layout().addTopBottomConstraints(doneButton, toView: titleLabel, multiplier: 1, constant: 0)
        Layout().addRightConstraint(doneButton, toView: backgroundView, multiplier: 1, constant: -3)
        Layout().addLeftToRightConstraint(doneButton, toView: titleLabel, multiplier: 1, constant: 3)
        
        
        //separatorView
        Layout().addLeftConstraint(separatorView, toView: backgroundView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(separatorView, toView: backgroundView, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(separatorView, toView: doneButton, multiplier: 1, constant: 3)
        Layout().addHeightConstraint(separatorView, toView: nil, multiplier: 0, constant: 1)
        
        //dataPicker
        Layout().addTopToBottomConstraint(dataPicker, toView: separatorView, multiplier: 1, constant: 3)
        Layout().addLeftConstraint(dataPicker, toView: backgroundView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(dataPicker, toView: backgroundView, multiplier: 1, constant: 0)
        Layout().addBottomConstraint(dataPicker, toView: backgroundView, multiplier: 1, constant: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataArray[row]
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.titleLabel.text = dataArray[row]
       
    }
    
    
    let backgroundView: UIView = {
    
        let tempView = UIView()
        tempView.layer.cornerRadius = 10
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor.whiteColor()
        return tempView
    }()
    
    let titleLabel: UILabel = {
    
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.textAlignment = .Center
        tempView.adjustsFontSizeToFitWidth = true
        tempView.text = "10亩以下"
        return tempView
    }()
    
    let doneButton: UIButton = {
    
        let tempView = UIButton()
        tempView.setTitle("确定", forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.setTitleColor(UIColor.blueColor(), forState: .Normal)
        tempView.titleLabel?.font = UIFont.systemFontOfSize(15)
        return tempView
    }()
    
    let separatorView: UIView = {
        
        let tempView = UIView()
        tempView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
    
    let dataPicker: UIPickerView = {
    
        let tempView = UIPickerView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.showsSelectionIndicator = true
        return tempView
    }()
    
    let dataArray = ["10亩以下", "11-20亩", "21-30亩", "31-40亩", "41-50亩", "51-60亩", "61-70亩", "71-80亩", "81-90亩", "91-100亩", "100亩以上"]
    
}
