//
//  NoticeClockHeader.swift
//  NoticeXi
//
//  Created by li lei on 2019/10/23.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeClockHeader: UIView {

    @objc public var timeL = UILabel()
    //@objc public var subTimel = UILabel()
    @objc public var payView = UIView()
    @objc public var setBtn = UIButton()
    @objc public var songBtn = UIButton()
    @objc public var openBtn : ZQTCustomSwitch?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = NoticeOcToSwift.getBackColor()
        self.payView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.payView)
        self.timeL.frame = CGRect(x: (NoticeSwiftFile.screenWidth - NoticeSwiftFile.getSwiftTextWidth(str: "09:00", height: 30, font: 40))/2, y: 25, width: NoticeSwiftFile.getSwiftTextWidth(str: "09:00", height: 30, font: 40), height: 30)
        self.timeL.textAlignment = NSTextAlignment.center
        self.timeL.textColor = NoticeOcToSwift.getMainTextColor()
        self.timeL.text = "06:30"
        self.timeL.font = UIFont.systemFont(ofSize: 40)
        self.payView.addSubview(self.timeL)
        
//        self.subTimel.frame = CGRect(x: self.timeL.frame.origin.x-26.5-NoticeSwiftFile.getSwiftTextWidth(str: "上午", height: 14, font: 14), y: 41, width: NoticeSwiftFile.getSwiftTextWidth(str: "上午", height: 14, font: 14), height: 14)
//        self.subTimel.textColor = NoticeOcToSwift.getDarkTextColor()
//        self.subTimel.text = "上午"
//        self.subTimel.font = UIFont.systemFont(ofSize: 14)
//        self.payView.addSubview(self.subTimel)
     
        self.setBtn.frame = CGRect(x: self.timeL.frame.maxX+26.5-10, y: 41-10, width: 34, height: 34)
        self.setBtn.setImage(NoticeTools.isWhiteTheme() ? UIImage.init(named: "Image_clockset") : UIImage.init(named: "Image_clocksety"), for: .normal)
        self.payView.addSubview(self.setBtn)
        
        self.songBtn.frame = CGRect(x: (NoticeSwiftFile.screenWidth-173)/2, y: 119.5, width: 173, height: 30)
        self.songBtn.backgroundColor = NoticeOcToSwift.getMainThumbColor()
        self.songBtn.setTitleColor(NoticeOcToSwift.getMainThumbWhiteColor(), for: .normal)
        self.songBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.songBtn.layer.cornerRadius = 15
        self.songBtn.layer.masksToBounds = true
        self.songBtn.setTitle("闹钟配音：默认", for: .normal)
        self.payView.addSubview(self.songBtn)
        
        self.openBtn = ZQTCustomSwitch.init(frame: CGRect(x: (NoticeSwiftFile.screenWidth-90)/2, y: 74.5, width: 90, height: 30), on: NoticeOcToSwift.getMainThumbColor(), offColor: NoticeTools.isWhiteTheme() ? NoticeOcToSwift.getColorWith("#ECF0F3") : NoticeOcToSwift.getColorWith("#B2B2B2"), font: UIFont.systemFont(ofSize: 20), ballSize: 26)
        self.openBtn?.onText = "ON"
        self.openBtn?.offText = "OFF"
        self.openBtn?.onLabel.textColor = NoticeOcToSwift.getMainThumbWhiteColor()
        self.openBtn?.offLabel.textColor = NoticeTools.isWhiteTheme() ? NoticeOcToSwift.getDarkTextColor() : NoticeOcToSwift.getMainTextColor()
        self.payView.addSubview(self.openBtn!)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
