//
//  NoticeChongZhiTosatView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeChongZhiTosatView: UIView {

    @objc public var contentView = UIView()
    @objc public var payJBView :NoticePayjbView?
    @objc public var moneyL :UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight());
        self.backgroundColor = UIColor.black .withAlphaComponent(0.4);
        
        contentView.isUserInteractionEnabled = true
        contentView.frame = CGRect(x: 0, y: NoticeSwiftFile.screenHeight, width: NoticeSwiftFile.screenWidth, height: 292+95+NoticeSwiftFile.BOTTOMHEIGHT());
        contentView.center = self.center;
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true
        self.addSubview(contentView);

        let editBtn = UIButton.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-50, y: 0, width: 50, height: 50))
        editBtn.setImage(UIImage.init(named: "Image_closechange"), for: .normal)
        editBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        self.contentView.addSubview(editBtn)
        
        let subTitleL = UILabel.init(frame: CGRect(x: 20, y: 50, width:35, height: 45))
        subTitleL.font = UIFont.systemFont(ofSize: 14)
        subTitleL.textColor = UIColor.init(hexString: "#25262E")
        subTitleL.text = "余额:"
        self.contentView.addSubview(subTitleL)
        
        let jingbImg = UIImageView.init(frame: CGRect(x: 57, y: 50+25/2 , width: 20, height: 20))
        jingbImg.image = UIImage.init(named: "Image_shopJB")
        self.contentView.addSubview(jingbImg)
        
        self.moneyL = UILabel.init(frame: CGRect(x: 80, y: 50, width: 150, height: 45))
        self.moneyL?.textColor = UIColor.init(hexString: "#25262E")
        self.moneyL?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        self.contentView.addSubview(self.moneyL!)
        
        self.payJBView = NoticePayjbView.init(frame: CGRect(x: 0, y: 95, width: NoticeSwiftFile.screenWidth, height: 292))
        self.payJBView?.backgroundColor = UIColor.white
        self.contentView.addSubview(self.payJBView!)
        self.payJBView?.payBlock = {[weak self] (sure) in
            self?.closeClick()
        }
        self.getMyWallect()
    }
    
    @objc func getMyWallect(){
        let url = "wallet"//String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)

        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
           
            if success {
                
                let nsDict = dict! as NSDictionary
          
                let wallcetM = NoticeMyWallectModel.mj_object(withKeyValues: nsDict["data"])
                self?.moneyL?.text = "鲸币" + (wallcetM?.total_balance ?? "0")
            }
 
            }, fail: {(error) in
        })
    }
    
    @objc func closeClick() {
        self.removeFromSuperview()
    }
    
    @objc func showView(){
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.contentView.frame = CGRect(x: 0, y: NoticeSwiftFile.screenHeight-292-95-NoticeSwiftFile.BOTTOMHEIGHT(), width: NoticeSwiftFile.screenWidth, height: 292+95+NoticeSwiftFile.BOTTOMHEIGHT())
        }) { (finished:Bool) in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
