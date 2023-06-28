//
//  NoticeChongzhiJbView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeChongzhiJbView: UIView {

    @objc public var titleL :UILabel?
    @objc public var moneyL :UILabel?
    @objc public var allL :UILabel?
    @objc public var payJBView :NoticePayjbView?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.titleL = UILabel.init(frame: CGRect(x: 0, y: 20, width: NoticeSwiftFile.screenWidth, height: 20))
        self.titleL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.titleL?.font = UIFont.systemFont(ofSize: 14)
        self.titleL?.textAlignment = NSTextAlignment.center
        self.titleL?.text = "余额(鲸币)"
        self.addSubview(self.titleL!)
        
        self.moneyL = UILabel.init(frame: CGRect(x: 0, y: 40, width: NoticeSwiftFile.screenWidth, height: 42))
        self.moneyL?.textColor = UIColor.init(hexString: "#25262E")
        self.moneyL?.font = UIFont.init(name: "PingFangSC-Medium", size: 30)
        self.moneyL?.textAlignment = NSTextAlignment.center
        self.addSubview(self.moneyL!)
        
        self.allL = UILabel.init(frame: CGRect(x: 0, y: 82, width: NoticeSwiftFile.screenWidth, height: 20))
        self.allL?.textColor = UIColor.init(hexString: "#8A8F99")
        self.allL?.font = UIFont.systemFont(ofSize: 14)
        self.allL?.textAlignment = NSTextAlignment.center

        self.addSubview(self.allL!)
        
        self.payJBView = NoticePayjbView.init(frame: CGRect(x: 0, y: 142, width: NoticeSwiftFile.screenWidth, height: 292))
        self.addSubview(self.payJBView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
