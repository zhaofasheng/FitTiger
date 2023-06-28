//
//  NoticeShopXiaDanTostaView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopXiaDanTostaView: UIView {
    @objc public var contentView = UIImageView()
    @objc public var titleL = UILabel()
    @objc public var contentL = UILabel()
    @objc public var sureXdBlock :((_ sure :Int) ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight());
        self.backgroundColor = UIColor.black .withAlphaComponent(0.4);
        
        contentView.isUserInteractionEnabled = true
        contentView.frame = CGRect(x: 0, y: 0, width: 280, height: 265)
        contentView.image = UIImage.init(named: "xidan_img");
        contentView.center = self.center;
        self.addSubview(contentView);

        self.titleL.frame = CGRect(x: 0, y: 20, width: 280, height: 24)
        self.titleL.font = UIFont(name: "PingFangSC-Medium", size: 17)
        self.titleL.textAlignment = NSTextAlignment.center
        self.titleL.textColor = UIColor.init(hexString: "#25262E")
        contentView.addSubview(self.titleL)
        
        self.contentL.frame = CGRect(x: 48, y: 60, width: 280-48, height: 88+32);
        self.contentL.font = UIFont.systemFont(ofSize: 15)
        self.contentL.numberOfLines = 0
        self.contentL.textColor = UIColor.init(hexString: "#5C5F66")
        contentView.addSubview(self.contentL)
        
        let titArr = ["再想想","下单"]
        
        for i in 0 ..< 2{
            let button = UIButton(type: .custom)
            button.frame = CGRect(x:20+126*i, y: 205, width: 114, height: 40)
            button.setTitle(titArr[i], for: .normal)
            button.tag = i
            button.layer.cornerRadius = 20
            button.layer.masksToBounds = true
            if i == 0 {
                button.setTitleColor(NoticeOcToSwift.getColorWith("#0099E6"), for:.normal)
                button.backgroundColor = UIColor.init(hexString: "#0099E6").withAlphaComponent(0.2)
            
            }else{
                button.setTitleColor(NoticeOcToSwift.getColorWith("#FFFFFF"), for:.normal)
                button.backgroundColor = UIColor.init(hexString: "#0099E6").withAlphaComponent(1)
            }
            
            button.titleLabel?.font = UIFont .systemFont(ofSize: 14)
            button .addTarget(self, action: #selector(sureOrCancelClick(buttonx:)), for: .touchUpInside)
            contentView .addSubview(button)
            
        }
    }
    
    @objc func sureOrCancelClick(buttonx:UIButton){
        if buttonx.tag == 1 {
            self.sureXdBlock?(1)
        }
        self.removeFromSuperview()
    }
    
    @objc func showView(){
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
        self.contentView.layer.position = self.center
        self.contentView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished:Bool) in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
