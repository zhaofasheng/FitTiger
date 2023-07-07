//
//  NoticeSendVoiceTools.swift
//  NoticeXi
//
//  Created by li lei on 2023/7/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeSendVoiceTools: UIView {

    @objc public var imgButton = FSCustomButton()
    @objc public var topicButton = FSCustomButton()
    @objc public var bgmButton = FSCustomButton()
    @objc public var shareButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 1))
        line.backgroundColor = UIColor(hexString: "#F0F1F5")
        self.addSubview(line)
        
        self.imgButton.frame = CGRect(x: 20, y: 4, width: 30, height: 46)
        self.imgButton.setImage(UIImage(named: "senimgv_img"), for: .normal)
        self.imgButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.imgButton.setTitle(NoticeTools.getLocalStr(with: "group.imgs"), for: .normal)
        self.imgButton.setTitleColor(UIColor(hexString: "#5C5F66"), for: .normal)
        self.imgButton.buttonImagePosition = FSCustomButtonImagePositionTop
        self.addSubview(self.imgButton)
        
        self.topicButton.frame = CGRect(x: 84, y: 4, width: 30, height: 46)
        self.topicButton.setImage(UIImage(named: "senTopicv_img"), for: .normal)
        self.topicButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.topicButton.setTitle(NoticeTools.getLocalStr(with: "search.topic"), for: .normal)
        self.topicButton.setTitleColor(UIColor(hexString: "#5C5F66"), for: .normal)
        self.topicButton.buttonImagePosition = FSCustomButtonImagePositionTop
        self.addSubview(self.topicButton)
        
        self.bgmButton.frame = CGRect(x: 148, y: 4, width: 30, height: 46)
        self.bgmButton.setImage(UIImage(named: "senbgmv_img"), for: .normal)
        self.bgmButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.bgmButton.setTitle("BGM", for: .normal)
        self.bgmButton.setTitleColor(UIColor(hexString: "#5C5F66"), for: .normal)
        self.bgmButton.buttonImagePosition = FSCustomButtonImagePositionTop
        self.addSubview(self.bgmButton)
        
        //CGRectMake(DR_SCREEN_WIDTH-20-66,10, 66, 25);
        self.shareButton.frame = CGRect(x: NoticeSwiftFile.screenWidth-20-66, y: 11, width: 66, height: 24)
        self.shareButton.setTitle("公开 >", for:.normal)
        self.shareButton.setTitleColor(UIColor(hexString: "#25262E"), for: .normal)
        self.shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.shareButton.layer.cornerRadius = 12
        self.shareButton.layer.masksToBounds = true
        self.shareButton.layer.borderWidth = 1
        self.shareButton.layer.borderColor = UIColor(hexString: "#25262E")?.cgColor
        self.addSubview(self.shareButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
