//
//  NoticeJBChoiceView.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeJBChoiceView: UIView {

    var oldChoiceJBView :UIView?
    public var choiceIndex :Int?
    
    @objc public var titleVew :UIButton?
    @objc public var label :UILabel?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.isUserInteractionEnabled = true
  
        
        self.titleVew = UIButton.init(frame: CGRect(x: 0, y: 16, width: self.frame.size.width, height: 24))
        self.titleVew?.setImage(UIImage.init(named: "Image_shopJB"), for: .normal)
        self.titleVew?.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        self.titleVew?.setTitleColor(UIColor.init(hexString: "#25262E"), for: .normal)
        self.addSubview(titleVew!)
        self.titleVew?.isUserInteractionEnabled = false
        
        self.label = UILabel.init(frame: CGRect(x: 0, y: 44, width: self.frame.size.width, height: 20))
        self.label?.font = UIFont.systemFont(ofSize: 14)
        self.label?.textColor = UIColor.init(hexString: "#8A8F99")
        self.label?.textAlignment = NSTextAlignment.center
        self.addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
