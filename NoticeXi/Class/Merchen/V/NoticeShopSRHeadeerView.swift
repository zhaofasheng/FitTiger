//
//  NoticeShopSRHeadeerView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopSRHeadeerView: UIView {

    @objc public var titleL :UILabel?
    @objc public var moneyL :UILabel?
    @objc public var textFild :UITextField?
    @objc public var markL :UILabel?

    @objc public var weChatButton :UIButton?
    @objc public var aliButton :UIButton?
    @objc public var weChatChangeButton :UIButton?
    @objc public var ailChangeButton :UIButton?
    @objc public var payId = ""//绑定提现id
    @objc public var tixianId = "" //提现id
    @objc public var type = 0 //绑定提现类型
    @objc public var canTixian = false //是否可提现
    @objc public var tixianType = 0 //提现类型
    @objc public var weChatL :UILabel?
    @objc public var aliL :UILabel?
    @objc public var myShouRuModel :NoticeMyWallectModel?
    @objc public var limitL :UILabel?
    @objc public var tixianBtn :UIButton?
    @objc public var biliL :UILabel?
    @objc public var tixianName :String?
    @objc public var tixianIcon :String?
    @objc public var wechatPayModel :NoticeMyWallectModel?
    @objc public var ailPayModel :NoticeMyWallectModel?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.titleL = UILabel.init(frame: CGRect(x: 0, y: 20, width: NoticeSwiftFile.screenWidth, height: 20))
        self.titleL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.titleL?.font = UIFont.systemFont(ofSize: 14)
        self.titleL?.textAlignment = NSTextAlignment.center
        self.titleL?.text = "可提现鲸币"
        self.addSubview(self.titleL!)
        
        self.moneyL = UILabel.init(frame: CGRect(x: 0, y: 40, width: NoticeSwiftFile.screenWidth, height: 42))
        self.moneyL?.textColor = UIColor.init(hexString: "#25262E")
        self.moneyL?.font = UIFont.init(name: "PingFangSC-Medium", size: 30)
        self.moneyL?.textAlignment = NSTextAlignment.center
        self.addSubview(self.moneyL!)
        
        self.limitL = UILabel.init(frame: CGRect(x: 0, y: 82, width: NoticeSwiftFile.screenWidth, height: 20))
        self.limitL?.textColor = UIColor.init(hexString: "#8A8F99")
        self.limitL?.font = UIFont.systemFont(ofSize: 14)
        self.limitL?.textAlignment = NSTextAlignment.center
        self.addSubview(self.limitL!)
        
        let subTitleL = UILabel.init(frame: CGRect(x: 20, y: 122, width:NoticeSwiftFile.screenWidth-20, height: 22))
        subTitleL.font = UIFont.systemFont(ofSize: 16)
        subTitleL.textColor = UIColor.init(hexString: "#25262E")
     
        self.addSubview(subTitleL)
        self.biliL = subTitleL
        
        let backView = UIView.init(frame: CGRect(x: 20, y: 154, width: NoticeSwiftFile.screenWidth-40, height: 50))
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        backView.layer.masksToBounds = true
        self.addSubview(backView)
        
        self.textFild = UITextField.init(frame: CGRect(x: 5, y: 0, width: backView.frame.size.width-10, height: 50))
        self.textFild?.backgroundColor = backView.backgroundColor
        self.textFild?.font = UIFont.systemFont(ofSize: 18)
        self.textFild?.textColor = UIColor.init(hexString: "#25262E")
        self.textFild?.keyboardType = .numberPad
        backView.addSubview(self.textFild!)
        self.textFild?.attributedPlaceholder = DDHAttributedMode.setSizeAndColorString("请输入提现鲸币数量", setColor: UIColor.init(hexString: "#A1A7B3"), setSize: 13, setLengthString: "请输入提现鲸币数量", beginSize: 0)
        self.textFild?.setupToolbarToDismissRightButton()
        //[self.phoneView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.textFild?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.markL = UILabel.init(frame: CGRect(x: 20, y: 214-6, width: NoticeSwiftFile.screenWidth-40, height: 17))
        self.markL?.textColor = UIColor.init(hexString: "#DB6E6E")
        self.markL?.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.markL!)
        
        let subTitleL1 = UILabel.init(frame: CGRect(x: 20, y: 240-6, width:NoticeSwiftFile.screenWidth-20, height: 22))
        subTitleL1.font = UIFont.systemFont(ofSize: 16)
        subTitleL1.textColor = UIColor.init(hexString: "#25262E")
        subTitleL1.text = "提现到"
        self.addSubview(subTitleL1)
        
        let webackView = UIView.init(frame: CGRect(x: 20, y: 270, width: NoticeSwiftFile.screenWidth-40, height: 100))
        webackView.backgroundColor = UIColor.white
        webackView.layer.cornerRadius = 8
        webackView.layer.masksToBounds = true
        self.addSubview(webackView)
        
        let wechatImge = UIImageView.init(frame: CGRect(x: 12, y: 12, width: 32, height: 32))
        wechatImge.image = UIImage.init(named: "wechat")
        webackView.addSubview(wechatImge)
        
        let subTitleL2 = UILabel.init(frame: CGRect(x: 52, y: 0, width:100, height: 50))
        subTitleL2.font = UIFont.systemFont(ofSize: 16)
        subTitleL2.textColor = UIColor.init(hexString: "#25262E")
        subTitleL2.text = "微信"
        webackView.addSubview(subTitleL2)
        
        self.weChatButton = UIButton.init(frame: CGRect(x: webackView.frame.size.width-50, y: 0, width: 50, height: 50))
        self.weChatButton?.setImage(UIImage.init(named: "Image_nochoicesh"), for: .normal)
        self.weChatButton?.addTarget(self, action: #selector(choiceWeChat), for: .touchUpInside)
        webackView.addSubview(self.weChatButton!)
        
        self.weChatL = UILabel.init(frame: CGRect(x: 20, y: 50, width: NoticeSwiftFile.screenWidth-50-20, height: 50))
        self.weChatL?.textColor = UIColor.init(hexString: "#25262E")
        self.weChatL?.font = UIFont.systemFont(ofSize: 14)
        self.weChatL?.text = "还未绑定账号"
        webackView.addSubview(self.weChatL!)
        
        self.weChatChangeButton = UIButton.init(frame: CGRect(x: webackView.frame.size.width-50, y: 50, width: 50, height: 50))
        self.weChatChangeButton?.addTarget(self, action: #selector(bangdingWeChat), for: .touchUpInside)
        webackView.addSubview(self.weChatChangeButton!)
        self.weChatChangeButton?.setTitle("绑定", for: .normal)
        self.weChatChangeButton?.setTitleColor(UIColor.init(hexString: "#0099E6"), for: .normal)
        self.weChatChangeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let ailbackView = UIView.init(frame: CGRect(x: 20, y: 382, width: NoticeSwiftFile.screenWidth-40, height: 100))
        ailbackView.backgroundColor = UIColor.white
        ailbackView.layer.cornerRadius = 8
        ailbackView.layer.masksToBounds = true
        self.addSubview(ailbackView)
        
        let aliImge = UIImageView.init(frame: CGRect(x: 12, y: 12, width: 32, height: 32))
        aliImge.image = UIImage.init(named: "Image_alipay")
        ailbackView.addSubview(aliImge)
        
        let subTitleL3 = UILabel.init(frame: CGRect(x: 52, y: 0, width:100, height: 50))
        subTitleL3.font = UIFont.systemFont(ofSize: 16)
        subTitleL3.textColor = UIColor.init(hexString: "#25262E")
        subTitleL3.text = "支付宝"
        ailbackView.addSubview(subTitleL3)
        
        self.aliButton = UIButton.init(frame: CGRect(x: webackView.frame.size.width-50, y: 0, width: 50, height: 50))
        self.aliButton?.setImage(UIImage.init(named: "Image_nochoicesh"), for: .normal)
        self.aliButton?.addTarget(self, action: #selector(choiceali), for: .touchUpInside)
        ailbackView.addSubview(self.aliButton!)
        
        self.aliL = UILabel.init(frame: CGRect(x: 20, y: 50, width: NoticeSwiftFile.screenWidth-50-20, height: 50))
        self.aliL?.textColor = UIColor.init(hexString: "#25262E")
        self.aliL?.font = UIFont.systemFont(ofSize: 14)
        self.aliL?.text = "还未绑定账号"
        ailbackView.addSubview(self.aliL!)
        
        self.ailChangeButton = UIButton.init(frame: CGRect(x: webackView.frame.size.width-50, y: 50, width: 50, height: 50))
        self.ailChangeButton?.addTarget(self, action: #selector(bangdingali), for: .touchUpInside)
        ailbackView.addSubview(self.ailChangeButton!)
        self.ailChangeButton?.setTitle("绑定", for: .normal)
        self.ailChangeButton?.setTitleColor(UIColor.init(hexString: "#0099E6"), for: .normal)
        self.ailChangeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let getButton = UIButton.init(frame: CGRect(x: 20, y: ailbackView.frame.origin.y+100+30, width: NoticeSwiftFile.screenWidth-40, height: 40))
        getButton.backgroundColor = UIColor.init(hexString: "#A1A7B3")
        getButton.layer.cornerRadius = 8
        getButton.layer.masksToBounds = true
        getButton.setTitle("提现", for: .normal)
        getButton.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
        self.addSubview(getButton)
        getButton.addTarget(self, action: #selector(tixianClick), for: .touchUpInside)
        self.tixianBtn = getButton
        self.getShouru()
    }
    
    @objc func getShouru(){
        let url = "transferPayInfo"//String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)
      
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            
            if success {
                
                let nsDict = dict! as NSDictionary

                self?.myShouRuModel = NoticeMyWallectModel.mj_object(withKeyValues: nsDict["data"])
                self?.moneyL?.text = self?.myShouRuModel?.income_balance

                for i in 0..<(self?.myShouRuModel?.payModelArr.count ?? 0){
                    
                    let typeM = self?.myShouRuModel?.payModelArr[i] as! NoticeMyWallectModel
                    if typeM.pay_type == "1" {
                        self?.wechatPayModel = typeM
                        self?.weChatL?.text = "微信昵称:" + typeM.identity_name
                        self?.weChatChangeButton?.setTitle("修改", for: .normal)
                    }else if typeM.pay_type == "2"{
                        self?.ailPayModel = typeM
                        self?.aliL?.text = "支付宝昵称:" + typeM.identity_name
                        self?.ailChangeButton?.setTitle("修改", for: .normal)
                    }
                }
                
                let subStr = "(" + (self?.myShouRuModel?.proportion_text ?? "2鲸币=1RMB") + ")"
                let allStr = "提现鲸币" + subStr
                
                self?.biliL?.attributedText = DDHAttributedMode.setSizeAndColorString(allStr, setColor: UIColor.init(hexString: "#5C5F66"), setSize: 14, setLengthString: subStr, beginSize: 4)

                if ((Float)(self?.myShouRuModel?.limit_amount ?? "0") ?? 0 ) > ((Float)(self?.myShouRuModel?.income_balance ?? "0") ?? 0 ){
                    self?.limitL?.text = "当前鲸币不足" + (self?.myShouRuModel?.limit_amount ?? "0") + "," + "暂不能提现"
                }else{
                    self?.limitL?.text = ""
                }
            }
            
        }, fail:nil)
    }
    
    //提现
    @objc func tixianClick(){
        if !self.tixianId.isEmpty && self.canTixian {
            let sureView = NoticeSureSendUserTostView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
            sureView.nameL.text = self.tixianName
            sureView.titleLabel.text = self.tixianType == 1 ? "确认提现到此微信账号？" : "确认提现到此支付宝账号？";
            sureView.nameL.frame = CGRect(x: sureView.nameL.frame.origin.x, y: sureView.iconImageView.frame.origin.y, width: sureView.nameL.frame.size.width, height: sureView.iconImageView.frame.size.height)
            sureView.iconImageView.sd_setImage(with: URL.init(string: self.tixianIcon ?? ""), completed: { image, error, type, url in
            })
            sureView.sureBlock = {[weak self] (sure) in
                NoticeQiaojjieTools.show(withTitle:String(format: "实际提现金额\n\n¥%.2f", (Float(self?.textFild?.text ?? "") ?? 0)*((Float)(self?.myShouRuModel?.rate ?? "0.2") ?? 0.2 )), msg: "", button1: "再想想", button2: "提现") { [weak self] (click) in
                    NoticeOcToSwift.topViewController().showHUD()
                    let parm = NSMutableDictionary()
                    parm .setObject(self?.textFild?.text as Any, forKey: "amount" as NSCopying) //String(format: "transfer/%@", self?.tixianId as CVarArg)
                    DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "transfer/" + (self?.tixianId ?? "") , accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                        NoticeOcToSwift.topViewController().hideHUD()
                        if success == true{
                            self?.getShouru()
                            self!.textFild?.text = ""
                            self!.markL?.text = ""
                            NoticeQiaojjieTools.show(withTitle: "申请已提交，24小时内到账，请注意查收")
                        }
                    }, fail: {(error) in
                        NoticeOcToSwift.topViewController().hideHUD()
                    })
                }
            }
            sureView.show()
        }
    }

    //绑定支付方式
    @objc func bangding(bangdId :String?, bangType :String?, bangName:String?, bangIcon :String?){
        let sureView = NoticeSureSendUserTostView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
        sureView.nameL.text = bangName
        sureView.titleLabel.text = "请核对信息";
        sureView.nameL.frame = CGRect(x: sureView.nameL.frame.origin.x, y: sureView.iconImageView.frame.origin.y, width: sureView.nameL.frame.size.width, height: sureView.iconImageView.frame.size.height)
        sureView.iconImageView.sd_setImage(with: URL.init(string: bangIcon ?? ""), completed: { image, error, type, url in
        })
        sureView.sureBlock = {[weak self] (sure) in
            NoticeOcToSwift.topViewController().showHUD()
            let parm = NSMutableDictionary()
            parm .setObject(bangType as Any, forKey: "pay_type" as NSCopying)
            parm .setObject(bangdId as Any, forKey: "identity_id" as NSCopying)
            parm .setObject(bangIcon as Any, forKey: "identity_img_url" as NSCopying)
            parm .setObject(bangName as Any, forKey: "identity_name" as NSCopying)
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "shop/bindPaymentMethod", accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                NoticeOcToSwift.topViewController().hideHUD()
                if success == true{
                    self?.getShouru()
                  
                }
            }, fail: {(error) in
                NoticeOcToSwift.topViewController().hideHUD()
            })
        }
        sureView.show()
    }
    
    //更换或者绑定微信
    @objc func bangdingWeChat(){
        NoticeTools.getWeChatsuccess {[weak self] (payId, type ,name,icon)in
            self?.bangding(bangdId: payId, bangType: "1", bangName: name, bangIcon: icon)
            
        }
    }
    
    //选择微信，未有绑定则先绑定
    @objc func choiceWeChat(){
        if self.wechatPayModel?.pay_type == "1" {
            self.tixianId = self.wechatPayModel?.tixianId ?? ""
            if !self.tixianId.isEmpty {
                self.tixianType = 1
                self.tixianIcon = self.wechatPayModel?.identity_img_url
                self.tixianName = self.wechatPayModel?.identity_name
                self.weChatButton?.setImage(UIImage.init(named: "Image_choicesh"), for: .normal)
                self.aliButton?.setImage(UIImage.init(named: "Image_nochoicesh"), for: .normal)
                if self.canTixian {
                    self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
                    self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                }else{
                    self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                    self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                }
            }
        }
    }
    
    //选择支付宝，未有绑定则先绑定
    @objc func choiceali(){
        if self.ailPayModel?.pay_type == "2" {
            
            self.tixianId = self.ailPayModel?.tixianId ?? ""
            if !self.tixianId.isEmpty {
                self.tixianType = 2
                self.tixianIcon = self.ailPayModel?.identity_img_url
                self.tixianName = self.ailPayModel?.identity_name
                self.aliButton?.setImage(UIImage.init(named: "Image_choicesh"), for: .normal)
                self.weChatButton?.setImage(UIImage.init(named: "Image_nochoicesh"), for: .normal)
                if self.canTixian {
                    self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
                    self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                }else{
                    self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                    self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                }
            }
        }
        
    }
    
    //更换或者绑定支付宝
    @objc func bangdingali(){
        NoticeTools.getAlisuccess { [weak self] (model) in
            let backM = model as! NoticeMJIDModel
            self?.type = 2
            self?.payId = backM.user_id
            NoticeOcToSwift.topViewController().showHUD()
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: String(format: "authorizeUser/2?auth_code=%@", backM.auth_code), accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: {[weak self] (dict, success) in
                NoticeOcToSwift.topViewController().hideHUD()
                if success == true{
                    
                    let nsDict = dict! as NSDictionary
                    let nameModel = NoticeMJIDModel.mj_object(withKeyValues: nsDict["data"])
                    
                    self?.bangding(bangdId: backM.user_id, bangType: "2", bangName: nameModel?.identity_name, bangIcon: nameModel?.identity_img_url)
                }
            }, fail: {(error) in
                NoticeOcToSwift.topViewController().hideHUD()
            })
        }
    }
    
    @objc func textFieldDidChange(){
    
        self.canTixian = false
        self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
        self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)//171.44
        
        if Int(self.textFild?.text ?? "") ?? 0 > 0 {
            
            self.markL?.textColor = UIColor.init(hexString: "#DB6E6E")
            
            if ((Float)(self.myShouRuModel?.limit_amount ?? "0") ?? 0 ) > ((Float)(self.myShouRuModel?.income_balance ?? "0") ?? 0 ){//鲸币小于最低可提现要求
                self.markL?.text = "当前鲸币不足" + (self.myShouRuModel?.limit_amount ?? "0") + "," + "暂不能提现"
            }else{
                if Float(self.textFild?.text ?? "") ?? 0 < ((Float)(self.myShouRuModel?.limit_amount ?? "0") ?? 0 ) {//输入提现鲸币小于最低要求
                    self.markL?.text = "单笔提现不能少于" + (self.myShouRuModel?.limit_amount ?? "0") + "鲸币"
                }else  if Float(self.textFild?.text ?? "") ?? 0 > ((Float)(self.myShouRuModel?.income_balance ?? "0") ?? 0 ){//输入鲸币超过可提现鲸币
                    self.markL?.text = "输入鲸币超过了可提现鲸币"
                }else{
                    self.canTixian = true
                    if self.tixianType > 0 {
                        self.tixianBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
                        self.tixianBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                    }
                    
                    self.markL?.textColor = UIColor.init(hexString: "#8A8F99")
                    self.markL?.text = String(format: "当前鲸币可提现%.2fRMB", (Float(self.textFild?.text ?? "") ?? 0)*((Float)(self.myShouRuModel?.rate ?? "0.5") ?? 0.5 ))
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
