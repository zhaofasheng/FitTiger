//
//  NoticePayjbView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticePayjbView: UIView {
    var newChoiceJBView :NoticeJBChoiceView?
    var oldChoiceJBView :NoticeJBChoiceView?
    var productId = ""
    let productArr = ["jingbi01","jingbi4","jingbi8","jingbi16","jingbi40","jingbi70"]
    let moneyArr = ["¥1","¥3","¥6","¥12","¥30","¥50"]
    @objc public var payBlock :((_ sure :Int) ->Void)?
    @objc public var xieyiBlock :((_ typeXiyi :Int) ->Void)?
    var sureButton :UIButton?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let viewWidth = (Float)(NoticeSwiftFile.screenWidth-60)/3
        let titleArr = ["1","4","8","16","40","70"]
        
        for i in 0..<6 {
            self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
            let tapView = NoticeJBChoiceView.init(frame: CGRect(x: (20+(CGFloat(viewWidth)+10)*CGFloat(i>2 ? (i-3):i)), y: i>2 ? 86:0, width: CGFloat(viewWidth), height: 76))
            tapView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
            tapView.layer.cornerRadius = 8
            tapView.layer.masksToBounds = true
            tapView.layer.borderColor = UIColor.init(hexString: "#E1E4F0").cgColor
            tapView.layer.borderWidth = 2
            self.addSubview(tapView)
            tapView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
            
            tapView.tag = i+1
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPayView(_ :)))
            tapView.addGestureRecognizer(tap)
            
            tapView.titleVew?.setTitle(titleArr[i], for: .normal)
            tapView.label?.text = self.moneyArr[i]
        }
        
        self.sureButton = UIButton.init(frame: CGRect(x: 20, y: 146+76, width: NoticeSwiftFile.screenWidth-40, height: 40))
        self.sureButton?.titleLabel?.font = UIFont .systemFont(ofSize: 16)
        self.sureButton?.setTitleColor(UIColor.white, for: .normal)
        self.sureButton?.backgroundColor = UIColor.init(hexString: "#E5749D")
        self.sureButton?.layer.cornerRadius = 8
        self.sureButton?.layer.masksToBounds = true
        self.addSubview(self.sureButton!)
        self.sureButton?.setTitle("充值", for: .normal)
        self.sureButton?.addTarget(self, action: #selector(surePayClick), for: .touchUpInside)
        
        let strwidth = NoticeSwiftFile.getSwiftTextWidth(str: "*支付即同意《鲸币用户协议》《鲸币使用手册》", height: 20, font: 14)
        let strwidth0 = NoticeSwiftFile.getSwiftTextWidth(str: "*支付即同意", height: 20, font: 14)
        let strwidth1 = NoticeSwiftFile.getSwiftTextWidth(str: "《鲸币用户协议》", height: 20, font: 14)
        let strwidth2 = NoticeSwiftFile.getSwiftTextWidth(str: "《鲸币使用手册》", height: 20, font: 14)
        let space = (NoticeSwiftFile.screenWidth-strwidth)/2
        
        let label1 = UILabel.init(frame: CGRect(x:space, y: 196+76, width: strwidth0, height: 20))
        label1.text = "*支付即同意"
        label1.font = UIFont.systemFont(ofSize: 14)
        label1.textColor = UIColor.init(hexString: "#8A8F99")
        self.addSubview(label1)
        
        let label2 = UILabel.init(frame: CGRect(x:space+strwidth0, y: 196+76, width: strwidth1, height: 20))
        label2.text = "《鲸币用户协议》"
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.textColor = UIColor.init(hexString: "#E5749D")
        self.addSubview(label2)
        label2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(tapXieyi))
        label2.addGestureRecognizer(tap2)
        
        let label3 = UILabel.init(frame: CGRect(x:space+strwidth0+strwidth1, y: 196+76, width: strwidth2, height: 20))
        label3.text = "《鲸币使用手册》"
        label3.font = UIFont.systemFont(ofSize: 14)
        label3.textColor = UIColor.init(hexString: "#E5749D")
        self.addSubview(label3)
        label3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(tapshouce))
        label3.addGestureRecognizer(tap3)
    }
    
    @objc func tapXieyi(){
//        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
//        ctl.specic = @"3";
//        [self.navigationController pushViewController:ctl animated:YES];
        let ctl = NoticeWebViewController()
        ctl.specic = "6"
        NoticeOcToSwift.topViewController().navigationController?.pushViewController(ctl, animated: true)
    }
    
    @objc func tapshouce(){
        let ctl = NoticeWebViewController()
        ctl.specic = "5"
        NoticeOcToSwift.topViewController().navigationController?.pushViewController(ctl, animated: true)
    }
    
    @objc func surePayClick(){
        if self.productId.isEmpty{
            self.sureButton?.setTitle("请选择充值金额", for: .normal)
            return
        }
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        NoticeSaveModel.clearPayInfo()
        let payInfo = NoticePaySaveModel()
        payInfo.productId = self.productId
        payInfo.userId = NoticeTools.getuserId()
        NoticeSaveModel.savePayInfo(payInfo)
        appdel.payManager.startPurch(withID: payInfo.productId) { type, data in
            
        }
      
        self.payBlock?(1)
    }
 
    
    @objc func tapPayView(_ tap:UITapGestureRecognizer){
        
        self.newChoiceJBView = tap.view as? NoticeJBChoiceView
        
        self.oldChoiceJBView?.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        self.oldChoiceJBView?.layer.borderWidth = 2
        self.oldChoiceJBView?.titleVew?.setTitleColor(UIColor.init(hexString: "#25262E"), for: .normal)
        self.oldChoiceJBView?.label?.textColor = UIColor.init(hexString: "#8A8F99")

        self.newChoiceJBView?.backgroundColor = UIColor.init(hexString: "#E5749D")
        self.newChoiceJBView?.layer.borderWidth = 0
        self.newChoiceJBView?.titleVew?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        self.newChoiceJBView?.label?.textColor = UIColor.init(hexString: "#F7F8FC")
        self.sureButton?.setTitle("确认支付\(self.moneyArr[self.newChoiceJBView!.tag-1])", for: .normal)
        self.productId = self.productArr[self.newChoiceJBView!.tag-1]
        self.oldChoiceJBView = self.newChoiceJBView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
