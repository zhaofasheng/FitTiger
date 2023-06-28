//
//  NoticeShopMerchCell.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopMerchCell: BaseCell {

    @objc public var shopImageView :UIImageView?
    @objc public var titleL :UILabel?
    @objc public var typeL :UILabel?
    @objc public var choiceBtn :UIImageView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let backView = UIView.init(frame: CGRect(x: 20, y: 0, width: NoticeSwiftFile.screenWidth-40, height: 80))
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = true
        backView.backgroundColor = UIColor.white
        self.contentView.addSubview(backView)
        
        self.shopImageView = UIImageView.init(frame: CGRect(x: 10, y:10, width: 60, height: 60))
        backView.addSubview(self.shopImageView!)
        self.shopImageView?.image = UIImage.init(named: "Image_shopicon")
        
        self.titleL = UILabel.init(frame: CGRect(x: 82, y: 16, width: 130, height: 22))
        self.titleL?.font = UIFont.systemFont(ofSize: 16)
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")
        backView.addSubview(self.titleL!)
        
        self.typeL = UILabel.init(frame: CGRect(x:82, y: 42, width:150, height: 22))
        self.typeL?.font = UIFont.systemFont(ofSize: 16)
        self.typeL?.textColor = UIColor.init(hexString: "#25262E")
        backView.addSubview(self.typeL!)
        
        self.choiceBtn = UIImageView.init(frame: CGRect(x: backView.frame.size.width-30, y: 30, width: 20, height: 20))
        backView.addSubview(self.choiceBtn!)
        self.choiceBtn?.image = UIImage.init(named: "Image_nochoicesh")
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
    }
    
    @objc func refreshData(goodsM :NoticeGoodsModel?){
        self.shopImageView?.sd_setImage(with: URL.init(string: goodsM?.goods_img_url ?? ""), completed: { image, error, type, url in

        })
        self.titleL?.text = goodsM?.goods_name
        let allStr = String(format: "%@鲸币(%@分钟)", (goodsM?.price ?? "") as String ,(goodsM?.duration ?? "") as String)
        let subStr1 = String(format: "%@鲸币", (goodsM?.price ?? "") as String)
        let subStr2 = String(format: "(%@分钟)",(goodsM?.duration ?? "") as String)
        self.typeL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 12, setLengthString: subStr2, beginSize: subStr1.count)
        
        if goodsM?.is_selling == "1" {
            self.choiceBtn?.image = UIImage.init(named: "Image_choicesh")
        }else{
            
            if goodsM?.choice == "1" {
                self.choiceBtn?.image = UIImage.init(named: "Image_choicesh")
            }else{
                self.choiceBtn?.image = UIImage.init(named: "Image_nochoicesh")
            }
            
        }
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




