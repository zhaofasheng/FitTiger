//
//  NoticeProtocolView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeProtocolView: UIView {
    @objc public var contentView :UIView?
    @objc public var titleL :UILabel?
    @objc public var contentL :UILabel?
    @objc public var scrollView :UIScrollView?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 324, height: 460-28))
        self.contentView?.backgroundColor = UIColor.white
        self.contentView?.layer.cornerRadius = 10
        self.contentView?.layer.masksToBounds = true
        self.addSubview(self.contentView!)
        self.contentView?.center = self.center
        
        self.titleL = UILabel.init(frame: CGRect(x: 20, y: 0, width: 324-40, height: 60))
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")
        self.titleL?.font = UIFont.init(name: "PingFangSC-Medium", size: 20)
        self.contentView?.addSubview(self.titleL!)
        
        self.scrollView = UIScrollView.init(frame: CGRect(x: 20, y: 60, width: 324-40, height:460-28-60-50))
        self.scrollView?.backgroundColor = UIColor.white
        
        self.contentView!.addSubview(self.scrollView!)
        
        self.contentL = UILabel.init(frame: CGRect(x:0, y: 0, width: 324-40, height:0))
        self.contentL?.textColor = UIColor.init(hexString: "#25262E")
        self.contentL?.font = UIFont.systemFont(ofSize: 14)
        self.contentL?.numberOfLines = 0
        self.scrollView?.addSubview(self.contentL!)
        
        let sureL = UILabel.init(frame: CGRect(x: 20, y: 460-28-50, width: 324-40, height: 50))
        sureL.textColor = UIColor.init(hexString: "#25262E")
        sureL.font = UIFont.init(name: "PingFangSC-Medium", size: 16)
        self.contentView?.addSubview(sureL)
        sureL.text = "确定";
        
        self.isUserInteractionEnabled = true
        sureL.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dissmissTap))
        sureL.addGestureRecognizer(tap)
    }
    
    @objc func dissmissTap(){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func showTitle(title:String? ,content:String?){
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
        self.contentView!.layer.position = self.center
        self.contentView!.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        self.titleL?.text = title
        self.contentL?.attributedText = NoticeTools.getStringWithLineHight(5, string: content ?? "")
        self.contentL?.frame = CGRect(x:0, y: 0, width: 324-40, height:NoticeTools.getHeightWithLineHight(5, font: 14, width: 324-40, string: content ?? ""))
        self.scrollView?.contentSize = CGSize(width: 0, height: self.contentL?.frame.size.height ?? 0)
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.contentView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished:Bool) in
        }
    }
}
