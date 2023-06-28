//
//  NoticeShopDetailCell.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopDetailCell: BaseCell {
    @objc public var shopImageView :UIImageView?
    @objc public var titleL :UILabel?
    @objc public var typeL :UILabel?
    @objc public var choiceBtn :UIButton?
    @objc public var getServerBlock :((_ goodsM :NoticeGoodsModel?) ->Void)?
    @objc public var goods :NoticeGoodsModel?
    
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
        self.titleL?.text = "为你唱歌"
        backView.addSubview(self.titleL!)
        
        self.typeL = UILabel.init(frame: CGRect(x:82, y: 42, width:150, height: 22))
        self.typeL?.font = UIFont.systemFont(ofSize: 16)
        self.typeL?.textColor = UIColor.init(hexString: "#25262E")
        self.typeL?.text = "2鲸币"
        backView.addSubview(self.typeL!)
        
        self.choiceBtn = UIButton.init(frame: CGRect(x: backView.frame.size.width-24-51, y: 28, width: 51, height: 24))
        backView.addSubview(self.choiceBtn!)
        self.choiceBtn?.backgroundColor = UIColor.init(hexString: "#E5749D")
        self.choiceBtn?.layer.cornerRadius = 12
        self.choiceBtn?.layer.masksToBounds = true
        self.choiceBtn?.setTitle("下单", for: .normal)
        self.choiceBtn?.setTitleColor(UIColor.white, for: .normal)
        self.choiceBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.choiceBtn?.addTarget(self, action: #selector(startClick), for: .touchUpInside)
        
        
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
    }
    
    @objc func refreshData(goodsM :NoticeGoodsModel?){
        self.goods = goodsM
        self.shopImageView?.sd_setImage(with: URL.init(string: goodsM?.goods_img_url ?? ""), completed: { image, error, type, url in

        })
        self.titleL?.text = goodsM?.goods_name
        let allStr = String(format: "%@鲸币(%@分钟)", (goodsM?.price ?? "") as String ,(goodsM?.duration ?? "") as String)
        let subStr1 = String(format: "%@鲸币", (goodsM?.price ?? "") as String)
        let subStr2 = String(format: "(%@分钟)",(goodsM?.duration ?? "") as String)
        self.typeL?.attributedText = DDHAttributedMode.setString(allStr, setSize: 12, setLengthString: subStr2, beginSize: subStr1.count)
        
    }
    
    
    @objc func startClick(){
        self.getServerBlock?(self.goods)
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
