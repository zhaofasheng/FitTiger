//
//  NoticeShoplistCell.swift
//  NoticeXi
//
//  Created by li lei on 2022/6/29.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShoplistCell: BaseCell {

    @objc public var shopImageView :UIImageView?
    @objc public var titleL :UILabel?
    @objc public var typeL :UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.shopImageView = UIImageView.init(frame: CGRect(x: (NoticeOcToSwift.devoiceWidth()-255)/2, y:0, width: 255, height: 255))
        self.contentView.addSubview(self.shopImageView!)
        self.shopImageView?.image = UIImage.init(named: "Image_shoplist")
        
        self.titleL = UILabel.init(frame: CGRect(x: 18, y: 25, width: 219, height: 34))
        self.titleL?.font = UIFont.systemFont(ofSize: 18)
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")
        self.titleL?.textAlignment = NSTextAlignment.center
        self.shopImageView?.addSubview(self.titleL!)
        
        self.typeL = UILabel.init(frame: CGRect(x: (219-NoticeSwiftFile.getSwiftTextWidth(str: "神 秘 小 店", height: 34, font: 18))/2+20+NoticeSwiftFile.getSwiftTextWidth(str: "神 秘 小 店", height: 34, font: 18), y: 25, width: (219-NoticeSwiftFile.getSwiftTextWidth(str: "神 秘 小 店", height: 34, font: 18))/2, height: 34))
        self.typeL?.font = UIFont.systemFont(ofSize: 11)
        self.typeL?.textColor = UIColor.init(hexString: "#25262E")

        self.shopImageView?.addSubview(self.typeL!)
        
    }
    
    @objc func refreshModel(shopM :NoticeMyShopModel?){
        self.titleL?.text = shopM?.shop_name
        self.typeL?.text = "~" + (shopM?.label ?? "")
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
