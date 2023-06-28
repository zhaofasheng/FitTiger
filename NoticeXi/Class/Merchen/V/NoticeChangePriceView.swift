//
//  NoticeChangePriceView.swift
//  NoticeXi
//
//  Created by li lei on 2023/4/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeChangePriceView: UIView, UITextFieldDelegate{

    @objc public var contentView :UIView?
    @objc public var nameBlock :((_ name :String?) ->Void)?
    @objc public var titleL :UILabel?
    @objc public var textFild :UITextField?
    @objc public var markL :UILabel?
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: NoticeSwiftFile.screenHeight, width: NoticeSwiftFile.screenWidth, height: 240))
        self.contentView?.backgroundColor = UIColor.white
        self.contentView?.layer.cornerRadius = 20
        self.contentView?.layer.masksToBounds = true
        self.addSubview(self.contentView!)
        
        self.titleL = UILabel.init(frame: CGRect(x: 20, y: 33, width: NoticeSwiftFile.screenWidth-20, height: 20))
        self.titleL?.font = UIFont.systemFont(ofSize: 14)
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")
        self.contentView?.addSubview(self.titleL!)
        self.titleL?.text = "语音通话价格";
        
        let editBtn = UIButton.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-50, y: 0, width: 50, height: 50))
        editBtn.setImage(UIImage.init(named: "Image_closechange"), for: .normal)
        editBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        self.contentView?.addSubview(editBtn)
        
        let backView = UIView.init(frame: CGRect(x: 20, y: 65, width: NoticeSwiftFile.screenWidth-40-10-NoticeSwiftFile.getSwiftTextWidth(str: "鲸币/分钟", height: 22, font: 16), height: 50))
        backView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        self.contentView?.addSubview(backView)
        
        let subTitleL = UILabel.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-20-NoticeSwiftFile.getSwiftTextWidth(str: "鲸币/分钟", height: 22, font: 16), y: 65+15, width:NoticeSwiftFile.getSwiftTextWidth(str: "鲸币/分钟", height: 22, font: 16), height: 20))
        subTitleL.font = UIFont.systemFont(ofSize: 16)
        subTitleL.textColor = UIColor.init(hexString: "#25262E")
        subTitleL.text = "鲸币/分钟"
        subTitleL.textAlignment = NSTextAlignment.center
        self.contentView?.addSubview(subTitleL)

        self.textFild = UITextField.init(frame: CGRect(x:0, y: 0, width: backView.frame.size.width, height: 50))
        self.textFild?.backgroundColor = backView.backgroundColor
        self.textFild?.font = UIFont.systemFont(ofSize: 18)
        self.textFild?.delegate = self
        self.textFild?.textAlignment = NSTextAlignment.center
        self.textFild?.textColor = UIColor.init(hexString: "#25262E")
        backView.addSubview(self.textFild!)
        self.textFild?.attributedPlaceholder = DDHAttributedMode.setSizeAndColorString("请输入价格", setColor: UIColor.init(hexString: "#A1A7B3"), setSize: 13, setLengthString: "请输入价格", beginSize: 0)
        self.textFild?.keyboardType = UIKeyboardType.numberPad
        
        self.markL = UILabel.init(frame: CGRect(x: 90, y: backView.frame.origin.y+52, width: NoticeSwiftFile.screenWidth-90, height: 17))
        self.markL?.textColor = UIColor.init(hexString: "#DB6E6E")
        self.markL?.font = UIFont.systemFont(ofSize: 12)
        self.contentView?.addSubview(self.markL!)
        
        let getButton = UIButton.init(frame: CGRect(x: 20, y: backView.frame.origin.y+50+50, width: NoticeSwiftFile.screenWidth-40, height: 40))
        getButton.backgroundColor = UIColor.init(hexString: "#0099E6")
        getButton.layer.cornerRadius = 8
        getButton.layer.masksToBounds = true
        getButton.setTitle("修改", for: .normal)
        getButton.setTitleColor(UIColor.white, for: .normal)
        self.contentView?.addSubview(getButton)
        getButton.addTarget(self, action: #selector(suplyClick), for: .touchUpInside)
        
        // 注册键盘即将出现通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFild?.isSecureTextEntry = true
        self.textFild?.font = nil
        self.textFild?.font = UIFont.systemFont(ofSize: 18)
    }
    
    /// 监听键盘即将出现事件
    @objc func keyboardShow(_ noti: Notification) {
       
        let info = noti.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        self.contentView?.frame = CGRect(x: 0, y: NoticeSwiftFile.screenHeight - (kbRect?.size.height ?? 0) - (self.contentView?.frame.size.height  ?? 0) + 20, width: NoticeSwiftFile.screenWidth, height: self.contentView?.frame.size.height ?? 0)
        
        if kbRect?.size.height ?? 0 > 0 && self.textFild?.isSecureTextEntry == true {
            self.textFild?.isSecureTextEntry = false
            self.textFild?.font = nil
            self.textFild?.font = UIFont.systemFont(ofSize: 18)
        }
    }
        
    @objc func suplyClick(){
     
        if(self.textFild?.text?.prefix(1) == "0"){
            self.markL?.text = "价格首位不可以是0哦！"
            return
        }
        self.nameBlock?(self.textFild?.text)
        self.closeClick()
    }
    
    @objc func closeClick(){
        self.textFild?.resignFirstResponder()
        self.removeFromSuperview()
    }
    
    @objc public func showView(){
        self.textFild?.becomeFirstResponder()
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
