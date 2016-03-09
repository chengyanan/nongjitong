//
//  YNNewsCommentTableViewCell.swift
//  nongjitong
//
//  Created by 农盟 on 16/3/4.
//  Copyright © 2016年 农盟. All rights reserved.
//

import UIKit


protocol YNNewsCommentTableViewCellDelegate {

    func newsCommentTableViewCell(cell: YNNewsCommentTableViewCell)
    
    
}

class YNNewsCommentTableViewCell: UITableViewCell {

    
    var delegate: YNNewsCommentTableViewCellDelegate?
    
    
    var model: YNNewsCommentModel? {
    
        didSet {
        
            self.avatorImage.getImageWithURL(model!.avatar!, contentMode: .ScaleAspectFill)
            
            self.nickName.text = model?.user_name
            self.postTime.text = model?.add_time
            self.content.text = model?.content
            
            self.voteButton.setTitle("\(model!.support_num)", forState: UIControlState.Normal)
            self.objectButton.setTitle("\(model!.oppose_num)", forState: UIControlState.Normal)
            
            if model?.user_id == kUser_ID() as? String {
            
                
                self.deleteButton.hidden = false
                
            }
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        setInterface()
        setLayout()
        
        
        self.deleteButton.hidden = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    func setLayout() {
        
        //avatorImage
        Layout().addTopConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: YNNewsCommentModel.top)
        
        Layout().addLeftConstraint(avatorImage, toView: self.contentView, multiplier: 1, constant: YNNewsCommentModel.leftRightMargin)
        Layout().addHeightConstraint(avatorImage, toView: nil, multiplier: 0, constant: YNNewsCommentModel.avatarHeight)
        Layout().addWidthConstraint(avatorImage, toView: nil, multiplier: 0, constant: YNNewsCommentModel.avatarHeight)
        
        //nickName
        Layout().addTopConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addLeftToRightConstraint(nickName, toView: avatorImage, multiplier: 1, constant: 5)
        Layout().addRightConstraint(nickName, toView: self.contentView, multiplier: 1, constant: -YNNewsCommentModel.leftRightMargin)
        Layout().addHeightConstraint(nickName, toView: nil, multiplier: 0, constant: 18)
        
        //postTime
        Layout().addLeftConstraint(postTime, toView: nickName, multiplier: 1, constant: 0)
        Layout().addTopToBottomConstraint(postTime, toView: nickName, multiplier: 1, constant: 2)
        Layout().addBottomConstraint(postTime, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(postTime, toView: nil, multiplier: 0, constant: 80)
        
        //content
        Layout().addLeftConstraint(content, toView: avatorImage, multiplier: 1, constant: 0)
        Layout().addRightConstraint(content, toView: self.contentView, multiplier: 1, constant: -YNNewsCommentModel.leftRightMargin)
        Layout().addTopToBottomConstraint(content, toView: avatorImage, multiplier: 1, constant: YNNewsCommentModel.avatorContentMargin)

        
        //deleteButton
        Layout().addTopConstraint(deleteButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addRightConstraint(deleteButton, toView: self.contentView, multiplier: 1, constant: 0)
        Layout().addHeightConstraint(deleteButton, toView: nil, multiplier: 0, constant: 44)
        Layout().addWidthConstraint(deleteButton, toView: nil, multiplier: 0, constant: 44)
        
        //objectButton
        Layout().addTopBottomConstraints(objectButton, toView: deleteButton, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(objectButton, toView: deleteButton, multiplier: 1, constant: 0)
        Layout().addRightToLeftConstraint(objectButton, toView: deleteButton, multiplier: 1, constant: 0)
        
        //voteButton
        Layout().addTopBottomConstraints(voteButton, toView: objectButton, multiplier: 1, constant: 0)
        Layout().addWidthConstraint(voteButton, toView: objectButton, multiplier: 1, constant: 0)
        Layout().addRightToLeftConstraint(voteButton, toView: objectButton, multiplier: 1, constant: 0)
    }
    
    func setInterface() {
        
        self.contentView.addSubview(avatorImage)
        self.contentView.addSubview(nickName)
        self.contentView.addSubview(postTime)
        self.contentView.addSubview(content)
        
        self.contentView.addSubview(voteButton)
        self.contentView.addSubview(objectButton)
        self.contentView.addSubview(deleteButton)
    
        
        self.voteButton.addTarget(self, action: "newsCommentVoteSupport", forControlEvents: .TouchUpInside)
        self.objectButton.addTarget(self, action: "newsCommentVoteOppose", forControlEvents: .TouchUpInside)
        
        self.deleteButton.addTarget(self, action: "deleteNewsComment", forControlEvents: .TouchUpInside)
        
    }
    
    
    //MARK: interface UI
    let avatorImage: UIImageView = {
        
        //头像
        let tempView = UIImageView()
        tempView.image = UIImage(named: "home_page_default_avatar_image")
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.clipsToBounds = true
        return tempView
    }()
    
    let nickName: UILabel = {
        
        //昵称
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.boldSystemFontOfSize(12)
        tempView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        return tempView
    }()
    
    let postTime: UILabel = {
        
        //time
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.font = UIFont.systemFontOfSize(11)
        tempView.textColor = UIColor.grayColor()
        tempView.adjustsFontSizeToFitWidth = true
        return tempView
    }()
    
    
    let content: UILabel = {
        
        //内容
        let tempView = UILabel()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.numberOfLines = 3
        tempView.font = UIFont.systemFontOfSize(12)
        tempView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        return tempView
    }()
    
    
    let voteButton: UIButton = {
        
        //赞同
        let tempView = UIButton()
        tempView.tag = 1
        tempView.setTitle("0", forState: .Normal)
        tempView.setImage(UIImage(named: "agree_up_vote"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        return tempView
    }()
    
    let objectButton: UIButton = {
        
        //反对
        let tempView = UIButton()
        tempView.tag = 2
        tempView.setTitle("0", forState: .Normal)
        tempView.setImage(UIImage(named: "hand_down_vote"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        
        return tempView
    }()
    
    let deleteButton: UIButton = {
        
        //删除按钮
        let tempView = UIButton()
        tempView.tag = 2
        tempView.setImage(UIImage(named: "Trash32"), forState: .Normal)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.titleLabel?.font = UIFont.systemFontOfSize(11)
        tempView.setTitleColor(UIColor.grayColor(), forState: .Normal)
        tempView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        
        return tempView
    }()
    
    
    
    //MARK: event response
    
    //MARK: 反对某条新闻评论／取消反对
    func newsCommentVoteOppose() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsCommentVote",
            "a": "oppose",
            "comment_id": model?.id,
            "user_id": kUser_ID() as? String
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //投票成功刷新界面
                        
                        self.model?.oppose_num++
                        
                        self.objectButton.setTitle("\(self.model!.oppose_num)", forState: UIControlState.Normal)
                        
                        
                    } else if status == 0 {
                        
//                        if let msg = json["msg"] as? String {
//                            
//                            //                            print(msg)
////                            YNProgressHUD().showText(msg, toView: self.view)
//                        }
                    }
                    
                }
                
                
            } catch {
                
//                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                
//                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    //MARK: 对新闻评论点赞／取消赞
    func newsCommentVoteSupport() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsCommentVote",
            "a": "support",
            "comment_id": model?.id,
            "user_id": kUser_ID() as? String
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //投票成功刷新界面
                        self.model?.support_num++
                        
                        self.voteButton.setTitle("\(self.model!.support_num)", forState: UIControlState.Normal)
                        
                        
                    } else if status == 0 {
                        
//                        if let msg = json["msg"] as? String {
//                            
//                            //                            print(msg)
//                            //                            YNProgressHUD().showText(msg, toView: self.view)
//                        }
                    }
                    
                }
                
                
            } catch {
                
                //                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                
                //                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    //MARK:删除一条评论
    func deleteNewsComment() {
        
        let params: [String: String?] = ["m": "Appapi",
            "key": "KSECE20XE15DKIEX3",
            "c": "NewsComment",
            "a": "delete",
            "comment_id": model?.id,
            "user_id": kUser_ID() as? String
        ]
        
        Network.post(kURL, params: params, success: { (data, response, error) -> Void in
            
            
            do {
                
                let json: NSDictionary =  try NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //                print("data - \(json)")
                
                if let status = json["status"] as? Int {
                    
                    if status == 1 {
                        
                        //通知代理 刷新界面
                        self.delegate?.newsCommentTableViewCell(self)
                        
                        
                    } else if status == 0 {
                        
//                        if let msg = json["msg"] as? String {
//                            
//                            //                            print(msg)
//                            //                            YNProgressHUD().showText(msg, toView: self.view)
//                        }
                    }
                    
                }
                
                
            } catch {
                
                //                YNProgressHUD().showText("请求错误", toView: self.view)
            }
            
            
            }) { (error) -> Void in
                
                
                //                YNProgressHUD().showText("加载失败", toView: self.view)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
