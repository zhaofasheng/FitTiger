//
//  NoticeManagerWorkCell.swift
//  NoticeXi
//
//  Created by li lei on 2019/8/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeManagerWorkCell: UITableViewCell {

    @objc public var numL : UILabel?
    @objc public var nameL : UILabel?
    @objc public var timeL : UILabel?
    @objc public var iconImageView : UIImageView?
    @objc public var dataTypeBtn : UIButton?
    @objc public var typeBtn : UIButton?
    @objc public var isCenter = false
    @objc public var isshCenter = false
    var selfModel : NoticeManagerJuBaoModel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.tag = 527
        self.contentView.backgroundColor = NoticeOcToSwift.getBackColor()
        self.contentView.tag = 527
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        self.numL = UILabel(frame: CGRect(x: 0, y: 0, width: 63, height: 60))
        self.numL?.textAlignment = .center
        self.numL?.textColor = NoticeOcToSwift.getMainTextColor()
        self.numL?.font = UIFont .systemFont(ofSize: 13)
        self.numL?.text = "999"
        self.contentView .addSubview(self.numL!)
        
        self.iconImageView = UIImageView(frame: CGRect(x: (self.numL?.frame.maxX)!, y: 10, width: 40, height: 40))
        self.iconImageView?.layer.cornerRadius = 20
        self.iconImageView?.layer.masksToBounds = true
        self.contentView .addSubview(self.iconImageView!)
        self.iconImageView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap))
        self.iconImageView?.addGestureRecognizer(tap)

        self.nameL = UILabel(frame: CGRect(x: (self.iconImageView?.frame.maxX)!+10.0, y: 14.0, width: NoticeSwiftFile.screenWidth-147.0-(self.iconImageView?.frame.maxX)!, height: 13.0))
        self.nameL?.font = UIFont .systemFont(ofSize: 13)
        self.nameL?.textColor = NoticeOcToSwift.getMainTextColor()
        self.nameL?.text = "小二白菜"
        self.contentView .addSubview(self.nameL!)
        
        self.timeL = UILabel(frame: CGRect(x: (self.nameL?.frame.origin.x)!, y: (self.nameL?.frame.maxY)!+13.0, width: (self.nameL?.frame.size.width)!, height: 10))
        self.timeL?.textColor = NoticeOcToSwift.getDarkTextColor()
        self.timeL?.font = UIFont .systemFont(ofSize: 9)
        self.timeL?.text = "2019-10-01 22:22"
        self.contentView .addSubview(self.timeL!)
        
        self.dataTypeBtn = UIButton(frame: CGRect(x: NoticeSwiftFile.screenWidth-15.0-55-7.0-55, y: 20, width: 55, height: 20))
        self.dataTypeBtn?.setTitleColor(NoticeOcToSwift.getColorWith("#828282"), for: .normal)
        self.dataTypeBtn?.titleLabel?.font = UIFont .systemFont(ofSize: 9)
        self.dataTypeBtn?.layer.cornerRadius = 5
        self.dataTypeBtn?.layer.masksToBounds = true
        self.dataTypeBtn?.layer.borderWidth = 1
        self.dataTypeBtn?.layer.borderColor = NoticeOcToSwift.getColorWith("#828282").cgColor
        self.dataTypeBtn?.setTitle("悄悄话", for: .normal)
        self.contentView .addSubview(self.dataTypeBtn!)
        
        self.typeBtn = UIButton(frame: CGRect(x: NoticeSwiftFile.screenWidth-15.0-55.0, y: 20, width: 55, height: 20))
        self.typeBtn?.setTitleColor(NoticeOcToSwift.getColorWith("#828282"), for: .normal)
        self.typeBtn?.titleLabel?.font = UIFont .systemFont(ofSize: 9)
        self.typeBtn?.layer.cornerRadius = 5
        self.typeBtn?.layer.masksToBounds = true
        self.typeBtn?.layer.borderWidth = 1
        self.typeBtn?.layer.borderColor = NoticeOcToSwift.getColorWith("#828282").cgColor
        self.typeBtn?.setTitle("色情暴力", for: .normal)
        self.contentView .addSubview(self.typeBtn!)
        
        let line = UIView(frame: CGRect(x: 0, y: 59, width: NoticeSwiftFile.screenWidth, height: 1))
        line.backgroundColor = NoticeOcToSwift.getlineColor()
        self.contentView .addSubview(line)
    }
    

    
    func refreshData(model:NoticeManagerJuBaoModel) {
        self.selfModel = model
        self.nameL?.text = model.fromUser.nick_name
        self.numL?.text = model.jubaoId
        self.timeL?.text = model.created_at
        self.dataTypeBtn?.setTitle(model.resourceTypeName, for:.normal)
        self.typeBtn?.setTitle(model.typeName, for: .normal)
        if self.isCenter {
            self.dataTypeBtn?.isHidden = true
        }
        self.iconImageView?.sd_setImage(with:URL.init(string: model.fromUser.avatar_url), placeholderImage: UIImage.init(named: "Image_jynohe"), options: SDWebImageOptions.refreshCached, completed: { (Image, error,CacheType, url) in
            
        })
        
        if model.resource_type == "143" {
            self.dataTypeBtn?.setTitle("播客", for: .normal)
            self.typeBtn?.setTitle("自填内容", for: .normal)
        }
    }
    
    func refreshCenterData(model:NoticeManagerJuBaoModel) {
        self.selfModel = model
        self.nameL?.text = model.centerUser.nick_name
        if model.operation_type == "1" {
            self.numL?.backgroundColor = UIColor.white.withAlphaComponent(0)
        }else{
            self.numL?.backgroundColor = UIColor.red
        }
        self.numL?.text = model.jubaoId
        self.timeL?.text = model.created_at
        self.dataTypeBtn?.isHidden = true
        if model.chat_type == "1" {
            self.typeBtn?.setTitle("悄悄话对话", for: .normal)
        }else if model.chat_type == "2"{
            self.typeBtn?.setTitle("交流对话", for: .normal)
        }else if model.chat_type == "3"{
            self.typeBtn?.setTitle("涂鸦对话", for: .normal)
        }else if model.data_type == "10"{
            self.typeBtn?.setTitle("社团聊天", for: .normal)
        }
        else{
            self.typeBtn?.setTitle(model.resourceTypeName, for: .normal)
        }
        
  
        
        self.iconImageView?.sd_setImage(with:URL.init(string: model.centerUser.avatar_url), placeholderImage: UIImage.init(named: "Image_jynohe"), options: SDWebImageOptions.refreshCached, completed: { (Image, error,CacheType, url) in
            
        })
    }
    
    @objc func iconTap(){
        let ctl = NoticeUserInfoCenterController()
        if self.isshCenter {
            ctl.userId =  (self.selfModel?.user_id)!
        }else{
            ctl.userId =  (self.selfModel?.from_user_id)!
        }
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let tabBar = appdel.window.rootViewController as! UITabBarController
        var nav: BaseNavigationController?
        if tabBar.isKind(of: UITabBarController.self){
            nav = tabBar.selectedViewController as? BaseNavigationController
            nav?.topViewController?.navigationController?.pushViewController(ctl, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
