//
//  NoticeShopRecodCell.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopRecodCell: BaseCell {
    @objc public var shopImageView :UIImageView?
    @objc public var titleL :UILabel?
    @objc public var typeL :UILabel?
    @objc public var moneyL :UILabel?
    @objc public var orderNoL :UILabel?
    @objc public var timeL :UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.shopImageView = UIImageView.init(frame: CGRect(x: 20, y:15, width: 36, height: 36))
        self.contentView.addSubview(self.shopImageView!)
        self.shopImageView?.image = UIImage.init(named: "Image_shopJB")
        
        self.titleL = UILabel.init(frame: CGRect(x: 66, y: 15, width: 160, height: 21))
        self.titleL?.font = UIFont.systemFont(ofSize: 15)
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")

        self.contentView.addSubview(self.titleL!)
        
        self.moneyL = UILabel.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-20-110, y: 15, width: 110, height: 28))
        self.moneyL?.font = UIFont.systemFont(ofSize: 18)
        self.moneyL?.textColor = UIColor.init(hexString: "#25262E")
    
        self.moneyL?.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(self.moneyL!)
        
        self.orderNoL = UILabel.init(frame: CGRect(x:66, y: 40, width: 240, height: 16))
        self.orderNoL?.font = UIFont.systemFont(ofSize: 11)
        self.orderNoL?.textColor = UIColor.init(hexString: "#8A8F99")
        self.contentView.addSubview(self.orderNoL!)
        
        self.timeL = UILabel.init(frame: CGRect(x:66, y: 60, width: 150, height: 16))
        self.timeL?.font = UIFont.systemFont(ofSize: 11)
        self.timeL?.textColor = UIColor.init(hexString: "#8A8F99")
        self.contentView.addSubview(self.timeL!)
        
        self.typeL = UILabel.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-20-130, y: 50, width: 130, height: 16))
        self.typeL?.font = UIFont.systemFont(ofSize: 11)
        self.typeL?.textColor = UIColor.init(hexString: "#5C5F66")
        self.typeL?.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(self.typeL!)
        
        let line = UIView.init(frame: CGRect(x: 66, y: 89, width: NoticeSwiftFile.screenWidth-66, height: 1))
        line.backgroundColor = UIColor.init(hexString: "#E1E4F0")
        self.contentView.addSubview(line)
        
        self.backgroundColor = UIColor.init(hexString: "#FFFFFF")
    }
    
    @objc func refreshModel(recoM :NoticeChangeRecoderModel?){
        self.typeL?.textColor = UIColor.init(hexString: "#5C5F66")
        if recoM?.resource_type == "1" {//充值
            self.titleL?.text = "充值" + (recoM?.recharge_balance ?? "") + "鲸币"
            self.moneyL?.text = String(format: "-¥%.f", (Float)(((Float)(recoM?.price ?? "0") ?? 0)/100))
            self.typeL?.text = "充值成功";
        }else if recoM?.resource_type == "2" {//提现
            self.titleL?.text = "提现" + (recoM?.income_balance ?? "") + "鲸币"
            self.moneyL?.text = String(format: "+¥%.2f", (Float)(((Float)(recoM?.price ?? "0") ?? 0)/100))
            print("提现\(String(describing: recoM?.price))")
            if recoM?.transfer_status == "1" {
                self.typeL?.text = "提现成功"
            }else if recoM?.transfer_status == "2" {
                self.typeL?.text = "提现失败"
                self.typeL?.textColor = UIColor.init(hexString: "#DB6E6E")
            }else{
                self.typeL?.text = "提现中(24小时到账)"
                self.typeL?.textColor = UIColor.init(hexString: "#0099E6")
            }
        }else if recoM?.resource_type == "3" {//支付店铺订单
            self.titleL?.text = "支付给-" + (recoM?.shop_name ?? "")
            let allStr = "-" + (recoM?.recharge_balance ?? "") + "鲸币"
            self.moneyL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 14, setLengthString: "鲸币", beginSize: allStr.count-2)
            self.typeL?.text = "支付成功"
       
        }else if recoM?.resource_type == "4" {//店铺收入
            self.titleL?.text = "店铺收入"
            let allStr = "+" + (recoM?.income_balance ?? "") + "鲸币"
            self.moneyL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 14, setLengthString: "鲸币", beginSize: allStr.count-2)
            self.typeL?.text = "已到账"
       
        }else if recoM?.resource_type == "5" {//订单退款
            self.titleL?.text = "订单退款"
            let allStr = "+" + (recoM?.recharge_balance ?? "") + "鲸币"
            self.moneyL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 14, setLengthString: "鲸币", beginSize: allStr.count-2)
            self.typeL?.text = "退款成功"
        }else if recoM?.resource_type == "6" {//订单退回
            self.titleL?.text = "退还鲸币"
            let allStr = "+" + (recoM?.income_balance ?? "") + "鲸币"
            self.moneyL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 14, setLengthString: "鲸币", beginSize: allStr.count-2)
            self.typeL?.text = "退还成功"
       
        }
        self.orderNoL?.text = "交易单号：" + (recoM?.transaction_no ?? "")
        self.timeL?.text = recoM?.created_at ?? ""
        recoM?.title = self.titleL?.text ?? ""
        recoM?.mark = self.typeL?.text ?? ""
        recoM?.money = self.moneyL?.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
                super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
