//
//  NoticeTimeListWithView.swift
//  NoticeXi
//
//  Created by li lei on 2019/10/14.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

import UIKit


@objc protocol WithViewOpenOrCloseDelegate{
    func openWithViewDelegate(open:Bool)
    func finishWithViewDelegate()
}

class NoticeTimeListWithView: UIView {
    @objc  public weak var delegate : WithViewOpenOrCloseDelegate?
    @objc public var headerL:UILabel?
    @objc public var loadL:JHShimmer?
    @objc public var openBtn:UIButton?
    @objc public var closeBtn:UIButton?
    @objc public var buttonView:UIView?
    @objc public var userView:UIView?
    @objc public var dataView:UIView?
    @objc public var icomImageView:UIImageView?
    @objc public var nickNameL:UILabel?
    @objc public var needMove = false
    public var strWidth:CGFloat?
    @objc public var tableView:UITableView?
    
    @objc public var dataArr = NSMutableArray()
    @objc public var labelArr = NSMutableArray()
    @objc public var nameL1:UILabel?
    @objc public var nameL2:UILabel?
    @objc public var nameL3:UILabel?
    @objc public var nameL4:UILabel?
    @objc public var nameL5:UILabel?
    @objc public var nameL6:UILabel?
    @objc public var nameL7:UILabel?
    @objc public var nameL8:UILabel?
    @objc public var nameL9:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.headerL = UILabel()
        self.headerL?.frame = CGRect(x: 15, y: 10, width: 150, height: 14)
        self.headerL?.textColor = UIColor.white.withAlphaComponent(0.5)
        self.headerL?.font = UIFont.systemFont(ofSize: 12)
        self.headerL?.text = NoticeTools.isSimpleLau() ? "这一刻他们也在时空旅行：" : "這壹刻他們也在時空旅行："
        self.addSubview(self.headerL!)
        self.headerL?.isHidden = true
        
        self.openBtn = UIButton()
        self.openBtn?.frame = CGRect(x: frame.size.width-15-30, y: 10, width: 30, height: 25)
        self.openBtn?.setImage(UIImage.init(named: NoticeTools.isWhiteTheme() ? "openshgj_img" : "openshgj_imgy"), for: UIControl.State.normal)
        self.addSubview(self.openBtn!)
        self.openBtn?.addTarget(self, action: #selector(openClick), for: .touchUpInside)
        
        self.loadL = JHShimmer()
        self.loadL?.frame = CGRect(x:frame.size.width-15-NoticeSwiftFile.getSwiftTextWidth(str: "等待新的旅客...", height: 12, font: 12), y: (self.openBtn?.frame.maxY)!+10, width: NoticeSwiftFile.getSwiftTextWidth(str: "等待新的旅客...", height: 12, font: 12), height: 12)
        self.loadL?.textColor = UIColor.white.withAlphaComponent(0.6)
        self.loadL?.font = UIFont.systemFont(ofSize: 12)
        self.loadL?.text = "等待新的旅客..."
        self.addSubview(self.loadL!)
        self.loadL?.shimmerWidth = 53
        self.loadL?.shimmerColor = UIColor.yellow
        self.loadL?.shimmerBackgroundColor = UIColor.clear
        self.loadL?.style = JHShimmerStyle.slanted
        self.loadL?.animationStyle = JHShimmerAnimationStyle.easeIn
        self.loadL?.shimmerDuration = 1
        self.loadL?.shimmerInterval = 0.5
        self.loadL?.start()
        
        self.closeBtn = UIButton()
        self.closeBtn?.frame = CGRect(x: frame.size.width-15-66, y: 10, width: 66, height: 20)
        self.closeBtn?.layer.cornerRadius = 10
        self.closeBtn?.layer.masksToBounds = true
        self.closeBtn?.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        self.closeBtn?.layer.borderWidth = 1
        self.closeBtn?.setTitle("收起", for: UIControl.State.normal)
        self.closeBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.closeBtn?.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControl.State.normal)
        self.closeBtn?.isHidden = true
        self.addSubview(self.closeBtn!)
        self.closeBtn?.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
    
//        self.buttonView = UIView.init(frame: CGRect(x: NoticeSwiftFile.screenWidth - (99+55), y: NoticeSwiftFile.screenWidth-15-33, width: 99+55, height: 33))
//        self.buttonView?.isHidden = true
//        self.addSubview(self.buttonView!)
//        let imgArr = [ NoticeTools.isWhiteTheme() ? "Image_upsgj" : "Image_upsgjy",NoticeTools.isWhiteTheme() ? "Image_downsgj" : "Image_downsgjy",NoticeTools.isWhiteTheme() ? "Image_yyysgj" : "Image_yyysgjy"]
//        for i in 0 ..< 3 {
//            let button = UIButton()
//            button.tag = i
//            button.frame = CGRect(x: (CGFloat)(48 * i), y: 0, width: 33, height: 33)
//            button.setBackgroundImage(UIImage.init(named: imgArr[i]), for: UIControl.State.normal)
//            button.addTarget(self, action: #selector(sendClick(btn:)), for: .touchUpInside)
//            self.buttonView!.addSubview(button)
//        }
        
//        self.userView = UIView.init(frame: CGRect(x: frame.size.width, y: 44, width: 100, height: 40));
//        self.userView?.backgroundColor = NoticeOcToSwift.getColorWith("#181828").withAlphaComponent(0.8)
//        self.userView?.layer.cornerRadius = 5
//        self.userView?.layer.masksToBounds = true
//        self.addSubview(self.userView!)
//        self.userView?.isHidden = true
//
//        self.icomImageView = UIImageView.init(frame: CGRect(x: 10, y: 8, width: 25, height: 25))
//        self.icomImageView?.layer.cornerRadius = 25/2
//        self.icomImageView?.layer.masksToBounds = true
//        self.userView?.addSubview(self.icomImageView!)
//        self.icomImageView?.image = UIImage.init(named: "Image_jynohe")
//
//        self.nickNameL = UILabel.init(frame: CGRect(x: (CGFloat)((self.icomImageView?.frame.maxX)!)+10, y: 0, width: (self.userView?.frame.size.width)!-45, height: 40))
//        self.nickNameL?.textColor = NoticeTools.isWhiteTheme() ? UIColor.white : NoticeOcToSwift.getColorWith("#B2B2B2")
//        self.nickNameL?.font = UIFont.systemFont(ofSize: 12)
//        self.userView?.addSubview(self.nickNameL!)
//
//        self.tableView = UITableView.init(frame: CGRect(x: 5, y:84, width: NoticeSwiftFile.screenWidth-26-99-55, height: self.frame.size.height-84-48))
//        self.tableView?.dataSource = self
//        self.tableView?.rowHeight = 25
//        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
//        self.tableView?.backgroundColor = UIColor.black.withAlphaComponent(0)
//        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.tableView?.isHidden = true
//        self.tableView?.transform = CGAffineTransform.init(scaleX: 1, y: -1)
//        self.tableView?.bounces = false
//        self.addSubview(self.tableView!)
        
        self.dataView = UIView.init(frame: CGRect(x: NoticeSwiftFile.screenWidth, y: 44, width: self.frame.size.width, height: 83))
        self.addSubview(self.dataView!)
        self.nameL1 = UILabel.init();
        self.nameL1?.font = UIFont.systemFont(ofSize: 11)
        self.nameL1?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL1!)
        
        self.nameL2 = UILabel.init();
        self.nameL2?.font = UIFont.systemFont(ofSize: 11)
        self.nameL2?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL2!)
        
        self.nameL3 = UILabel.init();
        self.nameL3?.font = UIFont.systemFont(ofSize: 11)
        self.nameL3?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL3!)
        
        self.nameL4 = UILabel.init();
        self.nameL4?.font = UIFont.systemFont(ofSize: 11)
        self.nameL4?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL4!)
        
        self.nameL5 = UILabel.init();
        self.nameL5?.font = UIFont.systemFont(ofSize: 11)
        self.nameL5?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL5!)
        
        self.nameL6 = UILabel.init();
        self.nameL6?.font = UIFont.systemFont(ofSize: 11)
        self.nameL6?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL6!)
        
        self.nameL7 = UILabel.init();
        self.nameL7?.font = UIFont.systemFont(ofSize: 11)
        self.nameL7?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL7!)
        
        self.nameL8 = UILabel.init();
        self.nameL8?.font = UIFont.systemFont(ofSize: 11)
        self.nameL8?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL8!)
        
        self.nameL9 = UILabel.init();
        self.nameL9?.font = UIFont.systemFont(ofSize: 11)
        self.nameL9?.textColor = NoticeOcToSwift.getColorWith("#b2b2b2")
        self.dataView?.addSubview(self.nameL9!)
        
        self.needMove = false
        
        if NoticeTools.hudongisOpen() {
            self.openClick()
        }else{
            self.closeClick()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openClick(){
        NoticeTools.setHUDONG("1")
        self.headerL?.isHidden = false
        self.loadL?.removeFromSuperview()
        self.addSubview(self.loadL!)
        self.closeBtn?.isHidden = false
        self.openBtn?.isHidden = true
        self.userView?.isHidden = false
        self.tableView?.isHidden = false
        self.buttonView?.isHidden = false
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenWidth)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.tableView?.frame = CGRect(x: 5, y:84, width: NoticeSwiftFile.screenWidth-26-99-55, height: self.frame.size.height-84-48)
        }) { (finished:Bool) in
        }
        if self.delegate != nil {
            self.delegate?.openWithViewDelegate(open: true)
        }
    }
    
    @objc func closeClick(){
        NoticeTools.setHUDONG("0")
        self.dataView?.isHidden = true
        self.loadL?.removeFromSuperview()
        self.headerL?.isHidden = true
        self.closeBtn?.isHidden = true
        self.openBtn?.isHidden = false
        self.userView?.isHidden = true
        self.tableView?.isHidden = true
        self.buttonView?.isHidden = true
        UIView .animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 40)
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (finished:Bool) in
        }
        if self.delegate != nil {
            self.delegate?.openWithViewDelegate(open: false)
        }
    }
    
    @objc func sendClick(btn:UIButton){

    }
    
    @objc func frashButtonFram(isUp:Bool){
  
        UIView .animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
              self.buttonView?.frame = CGRect(x: NoticeSwiftFile.screenWidth - (99+55), y: NoticeSwiftFile.screenWidth-65-33 + (isUp ? 0 : 50), width: 99+55, height: 33)
              self.tableView?.frame = CGRect(x: 5, y:84, width: NoticeSwiftFile.screenWidth-26-99-55, height: self.frame.size.height-84-48 - (isUp ? 50 : 0))
        }) { (finished:Bool) in
        }
    }
    
    @objc func ishudongOpenOrClose(){
        
        if NoticeTools.hudongisOpen() {
            self.headerL?.isHidden = false
            self.loadL?.isHidden = false
            self.closeBtn?.isHidden = false
            self.openBtn?.isHidden = true
            self.userView?.isHidden = false
            self.tableView?.isHidden = false
            self.buttonView?.isHidden = false
            UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
                self.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenWidth)
                self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.tableView?.frame = CGRect(x: 5, y:84, width: NoticeSwiftFile.screenWidth-26-99-55, height: self.frame.size.height-84-48)
            }) { (finished:Bool) in
            }
        }else{
            self.loadL?.isHidden = true
            self.headerL?.isHidden = true
            self.closeBtn?.isHidden = true
            self.openBtn?.isHidden = false
            self.userView?.isHidden = true
            self.tableView?.isHidden = true
            self.buttonView?.isHidden = true
            UIView .animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
                self.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 40)
                self.backgroundColor = UIColor.black.withAlphaComponent(0)
            }) { (finished:Bool) in
            }
        }
    }
    
    @objc func frashOptionsWithDataArr(time:NSInteger,nameArr:NSMutableArray){
        self.loadL?.isHidden = true
        self.dataView?.isHidden = false
        self.dataView?.frame = CGRect(x: NoticeSwiftFile.screenWidth, y: 44, width: self.frame.size.width, height: 83)
       
        UIView.animate(withDuration: TimeInterval(time), delay: 0, options:AnimationOptions.curveLinear, animations: {
            self.loadL?.isHidden = true
            self.dataView?.frame = CGRect(x: -NoticeSwiftFile.screenWidth, y: 44, width: self.frame.size.width, height: 83)
            
        }) { (finished:Bool) in
        
            self.dataView?.isHidden = true
            self.dataView?.frame = CGRect(x: NoticeSwiftFile.screenWidth, y: 44, width: self.frame.size.width, height: 83)
            if self.delegate != nil {
                self.delegate?.finishWithViewDelegate()
            }
        }
    }
    
//
//    @objc func frashUserInfo(model:NoticeUserInfoModel){
//
//        self.nickNameL?.text = model.nick_name
//        if model.user_id == "" || model.user_id == "0"{
//            self.icomImageView?.image = UIImage.init(named: "Image_ddr")
//            self.nickNameL?.textColor = NoticeOcToSwift.getColorWith("#F9D326")
//        }else{
//            self.nickNameL?.textColor = NoticeTools.isWhiteTheme() ? UIColor.white : NoticeOcToSwift.getColorWith("#B2B2B2")
//            self.icomImageView?.sd_setImage(with:URL.init(string: model.avatar_url), placeholderImage: UIImage.init(named: "Image_jynohe"), options: SDWebImageOptions.refreshCached, completed: { (Image, error,CacheType, url) in
//            })
//        }
//
//        self.strWidth = NoticeSwiftFile.getSwiftTextWidth(str: model.nick_name, height: 12, font: 12)
//        self.userView?.frame = CGRect(x: self.frame.size.width, y: 44, width: (self.strWidth ?? 0) + (CGFloat)((self.icomImageView?.frame.maxX)!)+20, height: 40)
//        self.nickNameL?.frame = CGRect(x: (CGFloat)((self.icomImageView?.frame.maxX)!)+10, y: 0, width: (self.userView?.frame.size.width)!-45, height: 40)
//        self.needMove = true
//
//    }
//
//    @objc func frashOptions(time:NSInteger){
//        self.loadL?.isHidden = true
//        self.userView?.removeFromSuperview();
//        self.addSubview(self.userView!)
//        self.userView?.frame = CGRect(x: self.frame.size.width, y: 44, width: (self.strWidth ?? 0) + (CGFloat)((self.icomImageView?.frame.maxX)!)+20, height: 40)
//        UIView.animate(withDuration: TimeInterval(time), delay: 0, options:AnimationOptions.curveLinear, animations: {
//            self.loadL?.isHidden = true
//            self.userView?.frame = CGRect(x: -((self.strWidth ?? 0)+(CGFloat)((self.icomImageView?.frame.maxX)!)+20), y: 44, width: (self.strWidth ?? 0)+(CGFloat)((self.icomImageView?.frame.maxX)!)+20, height: 40)
//
//        }) { (finished:Bool) in
//            self.userView?.frame = CGRect(x: self.frame.size.width, y: 44, width: (self.strWidth ?? 0) + (CGFloat)((self.icomImageView?.frame.maxX)!)+20, height: 40)
//            if self.delegate != nil {
//                self.delegate?.finishWithViewDelegate()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataArr.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.transform = CGAffineTransform.init(scaleX: 1, y: -1)
//        cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0)
//        cell.backgroundColor = UIColor.black.withAlphaComponent(0)
//        cell.textLabel?.frame = CGRect(x: 0, y: 0, width: (self.tableView?.frame.size.width)!, height: 25)
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
//        let model = self.dataArr[self.dataArr.count - 1 - indexPath.row] as! NoticeAbout
//
//        cell.textLabel?.text = model.actionString
//        let alpha = 1 - indexPath.row/10
//        cell.textLabel?.textColor = model.needColor ? NoticeOcToSwift.getColorWith("#FE736C").withAlphaComponent(CGFloat(alpha)) : (NoticeTools.isWhiteTheme() ? UIColor.white : NoticeOcToSwift.getColorWith("#B2B2B2").withAlphaComponent(CGFloat(alpha)))
//        cell.textLabel?.alpha = CGFloat(alpha)
//        return cell
//    }
}
