//
//  NoticeNewRecoderInputView.swift
//  NoticeXi
//
//  Created by li lei on 2022/3/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeNewRecoderInputView: UIView {

    public var blurEffect = UIBlurEffect(style: .light)
    public var visualView = UIVisualEffectView()
    public var voiceButton = UIView()
    public var textButton = UIView()
    public var bokeButton = UIView()
    public var helpButton = UIView()
    
    @objc public var callBlock :((_ typeIndex :Int) ->Void)?
    override init(frame:CGRect){
        super.init(frame: frame)

        self.layer.backgroundColor = UIColor.init(hexString: "#F7F8FC").withAlphaComponent(0.1).cgColor
        
        self.visualView.frame = self.bounds
        self.visualView.effect = nil
        self.addSubview(self.visualView)
                
        let colseBtn = UIButton.init(frame: CGRect(x: (NoticeSwiftFile.screenWidth-50)/2, y: NoticeSwiftFile.screenHeight-NoticeSwiftFile.TABBARHEIGHT()-50, width: 50, height: 50))
        colseBtn .setImage(UIImage.init(named: "Image_closesend"), for: .normal)
        self.addSubview(colseBtn)
        colseBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        
        self.isUserInteractionEnabled = true
        self.voiceButton.isUserInteractionEnabled = true
        self.textButton.isUserInteractionEnabled = true
        
        let titleImageView = UIImageView(frame: CGRect(x: 40, y: NoticeSwiftFile.NAVHEIGHT()+100, width: 191, height: 76))
        self.addSubview(titleImageView)
        titleImageView.image = UIImage.init(named: NoticeTools.getLocalImageNameCN("Image_sendxinqtit"))
        
        
        self.voiceButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: colseBtn.frame.origin.y-232-72, width: 72, height: 108)
        self.addSubview(self.voiceButton)
        let voiceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:72, height: 72))
        voiceImageView.image = UIImage.init(named: "Image_sendVoiceImgd")// Image_sendTexV
        self.voiceButton.addSubview(voiceImageView)
        
        let voiceL = UILabel(frame: CGRect(x: 0, y: 88, width: 72, height: 20))
        voiceL.font = UIFont.systemFont(ofSize: 14)
        voiceL.textColor = UIColor.init(hexString: "#25262E")
        voiceL.textAlignment = .center
        voiceL.text = NoticeTools.getLocalStr(with: "intro.sharexq")
        self.voiceButton.addSubview(voiceL)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(voiceClick))
        self.voiceButton.addGestureRecognizer(tap)
        
        self.textButton.frame = CGRect(x:self.voiceButton.frame.origin.x+72+56, y: colseBtn.frame.origin.y-232-72, width: 72, height: 108)
        self.addSubview(self.textButton)
        let textImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:72, height: 72))
        textImageView.image = UIImage.init(named: "Image_sendTexV")// 
        self.textButton.addSubview(textImageView)
        
        let textL = UILabel(frame: CGRect(x: 0, y: 88, width: 72, height: 20))
        textL.font = UIFont.systemFont(ofSize: 14)
        textL.textColor = UIColor.init(hexString: "#25262E")
        textL.textAlignment = .center
        textL.text = NoticeTools.getLocalStr(with: "intro.tcxqing")
        self.textButton.addSubview(textL)
        
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(textClick))
        self.textButton.addGestureRecognizer(tap1)
        
        self.bokeButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: colseBtn.frame.origin.y-108-72, width: 72, height: 108)
        self.addSubview(self.bokeButton)
        let bokeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:72, height: 72))
        bokeImageView.image = UIImage.init(named: "Image_mainSendBoke")
        self.bokeButton.addSubview(bokeImageView)
        
        let bokeL = UILabel(frame: CGRect(x: 0, y: 88, width: 72, height: 20))
        bokeL.font = UIFont.systemFont(ofSize: 14)
        bokeL.textColor = UIColor.init(hexString: "#25262E")
        bokeL.textAlignment = .center
        bokeL.text = NoticeTools.chinese("播客投稿", english: "Podcast", japan: "投稿する")
        self.bokeButton.addSubview(bokeL)
        
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(bokeClick))
        self.bokeButton.addGestureRecognizer(tap2)
        
        self.helpButton.frame = CGRect(x:self.bokeButton.frame.origin.x+72+56, y: colseBtn.frame.origin.y-108-72, width: 72, height: 108)
        self.addSubview(self.helpButton)
        let helpImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:72, height: 72))
        helpImageView.image = UIImage.init(named: "Image_sendTexV")//
        self.helpButton.addSubview(helpImageView)
        
        let helpL = UILabel(frame: CGRect(x: 0, y: 88, width: 72, height: 20))
        helpL.font = UIFont.systemFont(ofSize: 14)
        helpL.textColor = UIColor.init(hexString: "#25262E")
        helpL.textAlignment = .center
        helpL.text = NoticeTools.chinese("求助", english: "Ask", japan: "質問")
        self.helpButton.addSubview(helpL)
        
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(helpClick))
        self.helpButton.addGestureRecognizer(tap3)
    }
    
    @objc func bokeClick(){
        self.closeClick()
        self.callBlock?(3)
    }
    
    @objc func voiceClick(){
        self.closeClick()
        self.callBlock?(1)
    }
    
    @objc func textClick(){
        self.closeClick()
        self.callBlock?(2)
    }
    
    @objc func helpClick(){
        self.closeClick()
        self.callBlock?(4)
    }
    
    @objc  func show(){
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.visualView.effect = nil
        self.voiceButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: NoticeSwiftFile.screenHeight, width: 72, height: 108)
        self.textButton.frame = CGRect(x:self.voiceButton.frame.origin.x+72+56, y: NoticeSwiftFile.screenHeight, width: 72, height: 108)
        self.bokeButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: NoticeSwiftFile.screenHeight, width: 72, height: 108)
        self.helpButton.frame = CGRect(x:self.bokeButton.frame.origin.x+72+56, y: NoticeSwiftFile.screenHeight, width: 72, height: 108)
        UIView.animate(withDuration:0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.visualView.effect = self.blurEffect
            self.voiceButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: NoticeSwiftFile.screenHeight-NoticeSwiftFile.TABBARHEIGHT()-32-232-52, width: 72, height: 108)
            self.textButton.frame = CGRect(x:self.voiceButton.frame.origin.x+72+56, y: NoticeSwiftFile.screenHeight-NoticeSwiftFile.TABBARHEIGHT()-32-232-52, width: 72, height: 108)
            self.bokeButton.frame = CGRect(x: (NoticeSwiftFile.screenWidth-200)/2, y: NoticeSwiftFile.screenHeight-NoticeSwiftFile.TABBARHEIGHT()-32-108-52, width: 72, height: 108)
            self.helpButton.frame = CGRect(x:self.bokeButton.frame.origin.x+72+56, y: NoticeSwiftFile.screenHeight-NoticeSwiftFile.TABBARHEIGHT()-32-108-52, width: 72, height: 108)
        }) { _ in }
    }
    
    @objc func closeClick(){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
