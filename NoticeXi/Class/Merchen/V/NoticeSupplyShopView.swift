//
//  NoticeSupplyShopView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeSupplyShopView: UIView {

    @objc public var scrollView :UIScrollView?
    @objc public var contentImgView :UIImageView?
    @objc public var getL :UILabel?
    @objc public var startBtn :UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.scrollView = UIScrollView.init(frame: CGRect(x: 20, y: 0, width: NoticeSwiftFile.screenWidth-40, height:self.frame.size.height-50-80-NoticeSwiftFile.BOTTOMHEIGHT()-56))
        self.scrollView?.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.scrollView?.layer.cornerRadius = 10
        self.scrollView?.layer.masksToBounds = true
        self.scrollView?.contentSize = CGSize(width: 0, height: ((self.scrollView?.frame.size.width)!-20)*378/313+20)
        self.addSubview(self.scrollView!)
        
        self.contentImgView = UIImageView.init(frame: CGRect(x: 10, y: 20, width: (self.scrollView?.frame.size.width)!-20, height: ((self.scrollView?.frame.size.width)!-20)*378/313))
        self.contentImgView?.image = UIImage.init(named: "Image_shopxieyi")
        self.scrollView?.addSubview(self.contentImgView!)
        
        self.getL = UILabel.init(frame: CGRect(x: 0, y: self.scrollView!.frame.size.height+50+30+2, width: NoticeSwiftFile.screenWidth, height: 30))
        self.getL?.font = UIFont.systemFont(ofSize: 14)
        self.getL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.getL?.text = "你还未满足申请条件“来声昔100天”"
        self.getL?.textAlignment = NSTextAlignment.center
        self.addSubview(self.getL!)
        
        self.startBtn = UIButton.init(frame: CGRect(x: 68, y: self.scrollView!.frame.size.height+30, width: NoticeSwiftFile.screenWidth-68*2, height: 50))
        self.startBtn?.layer.cornerRadius = 25
        self.startBtn?.layer.masksToBounds = true
        self.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
        self.addSubview(self.startBtn!)
        self.startBtn?.setTitle("申请开通店铺", for: .normal)
        self.startBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
