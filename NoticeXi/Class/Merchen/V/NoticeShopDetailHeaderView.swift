//
//  NoticeShopDetailHeaderView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopDetailHeaderView: UIView {
    @objc public var shopView :UIView?
    @objc public var shopIconImageView :UIImageView?
    @objc public var nameL :UILabel?
    @objc public var serviceImgV :UIImageView?
    @objc public var getImageV :UIImageView?
    @objc public var severL :UILabel?
    @objc public var getL :UILabel?
    @objc public var busyL :UILabel?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.shopView = UIView.init(frame: CGRect(x: 20, y:20, width: NoticeSwiftFile.screenWidth-40, height: 108))
        self.shopView?.layer.cornerRadius = 10
        self.shopView?.layer.masksToBounds = true
        self.shopView?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.shopView?.layer.borderWidth = 1
        self.addSubview(self.shopView!)
        
        self.shopIconImageView = UIImageView.init(frame: CGRect(x: 11, y: 11, width: 86, height: 86))
        self.shopIconImageView?.layer.cornerRadius = 10
        self.shopIconImageView?.layer.masksToBounds = true;
        self.shopIconImageView?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.shopIconImageView?.layer.borderWidth = 1
        self.shopIconImageView?.image = UIImage.init(named: "Image_shopicon")
        self.shopView?.addSubview(self.shopIconImageView!)
        self.isUserInteractionEnabled = true
        self.shopIconImageView?.isUserInteractionEnabled = true
        
        self.serviceImgV = UIImageView.init(frame: CGRect(x: 108, y:49, width: 20, height: 20))
        self.shopView!.addSubview(self.serviceImgV!)
        self.serviceImgV?.image = UIImage.init(named: "Image_shopxinx")
        
        self.getImageV = UIImageView.init(frame: CGRect(x: 108, y:78, width: 20, height: 20))
        self.shopView!.addSubview(self.getImageV!)
        self.getImageV?.image = UIImage.init(named: "Image_shopdanshu")
        
    
        self.nameL = UILabel.init(frame: CGRect(x: 108, y: 12, width: 200, height: 22))
        self.nameL?.font = UIFont.systemFont(ofSize: 16)
        self.nameL?.textColor = UIColor.init(hexString: "#25262E")
        self.nameL?.text = "经营者"
        self.shopView?.addSubview(self.nameL!)
        
        self.busyL = UILabel.init(frame: CGRect(x: 163, y: 12, width: 54, height: 22))
        self.busyL?.font = UIFont.systemFont(ofSize: 11)
        self.busyL?.textColor = UIColor.init(hexString: "#FFFFFF")
        self.busyL?.backgroundColor = UIColor.init(hexString: "#DB6E6E")
        self.busyL?.layer.cornerRadius = 11
        self.busyL?.layer.masksToBounds = true
        self.busyL?.textAlignment = NSTextAlignment.center
        self.busyL?.isHidden = true
        self.busyL?.text = "服务中"
        self.shopView?.addSubview(self.busyL!)
        
        self.severL = UILabel.init(frame: CGRect(x: 132, y: 49, width: NoticeSwiftFile.getSwiftTextWidth(str: "唱歌", height: 20, font: 12)+10, height: 20))
        self.severL?.font = UIFont.systemFont(ofSize: 12)
        self.severL?.textColor = UIColor.init(hexString: "#25262E")
        self.severL?.textAlignment = NSTextAlignment.center
        self.severL?.layer.cornerRadius = 10
        self.severL?.layer.masksToBounds = true
        self.severL?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.severL?.layer.borderWidth = 1
        self.shopView?.addSubview(self.severL!)
        
        self.getL = UILabel.init(frame: CGRect(x: 132, y: 78, width: 160, height: 20))
        self.getL?.font = UIFont.systemFont(ofSize: 14)
        self.getL?.textColor = UIColor.init(hexString: "#25262E")
        self.getL?.text = "0单"
        self.shopView?.addSubview(self.getL!)
        
        
    }
    
    @objc func refreShop(shopM :NoticeMyShopModel?){
        self.shopIconImageView?.sd_setImage(with: URL.init(string: shopM?.role_img_url ?? ""), completed: { image, error, type, url in
        })
        
        if shopM?.operate_status == "3" {
            self.busyL?.isHidden = false
        }else{
            self.busyL?.isHidden = true
        }
        
        self.severL?.text = shopM?.label
        self.severL?.frame = CGRect(x: 132, y: 49, width: NoticeSwiftFile.getSwiftTextWidth(str: shopM?.label ?? "", height: 20, font: 12)+10, height: 20)
        self.getL?.text = (shopM?.order_num ?? "0") + "单"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
