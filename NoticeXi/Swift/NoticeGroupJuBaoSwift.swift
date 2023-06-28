//
//  NoticeGroupJuBaoSwift.swift
//  NoticeXi
//
//  Created by li lei on 2020/9/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeGroupJuBaoSwift: UIView {

    @objc public var contentView = UIView()
    @objc public var titleL = UILabel()
    var buttonArr = [UIButton]()
    @objc public var pinbBtn = UIButton()
    @objc public var isOutPerson = false
    var type = Int()
    @objc public var reouceId = String()
    @objc public var reouceType : String?
    @objc public weak var delegate : FirstViewControllerDelegate?
    var canTap = true
    @objc public var outBlock :((_ typeIndex :Int) ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight());
        self.backgroundColor = UIColor.black .withAlphaComponent(0.4);
        contentView.frame = CGRect(x: 0, y: 0, width: 280, height: 229);
        contentView.backgroundColor = NoticeOcToSwift.getColorWith("#FFFFFF");
        contentView.center = self.center;
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = true;
        self.addSubview(contentView);
        
        let titArr = ["再想想","下一步"];
        self.canTap = true
        for i in 0 ..< 2{
            let button = UIButton(type: .custom)
            button.frame = CGRect(x:140*i, y: Int(contentView.frame.size.height)-44, width: 140, height: 44)
            button.setTitle(titArr[i], for: .normal)
            if i == 0 {
                button.setTitleColor(NoticeOcToSwift.getColorWith("#5C5F66"), for:.normal)
                button.tag = 1;
            }else{
                button.tag = 0;
                self.pinbBtn = button
                button.setTitleColor(NoticeOcToSwift.getColorWith("#0099E6"), for:.normal)
                
            }
            
            button.titleLabel?.font = UIFont .systemFont(ofSize: 14)
            button .addTarget(self, action: #selector(sureOrCancelClick), for: .touchUpInside)
            contentView .addSubview(button)
            
        }
        
        let hLine = UIView(frame:CGRect(x: 0, y: contentView.frame.size.height-44, width: contentView.frame.size.width, height: 1))
        hLine.backgroundColor = NoticeOcToSwift.getColorWith("#EBECF0")
        contentView.addSubview(hLine)
        
        let sLine = UIView(frame:CGRect(x: contentView.frame.size.width/2-0.5, y: contentView.frame.size.height-44, width:1, height: 44))
        sLine.backgroundColor = NoticeOcToSwift.getColorWith("#EBECF0")
        contentView.addSubview(sLine)
        
        let titleL = UILabel(frame: CGRect(x: 0, y: 20, width: contentView.frame.size.width, height: 25))
        titleL.text = "请选择移出方式"
        titleL.textAlignment = .center
        titleL.font = UIFont.systemFont(ofSize: 18)
        titleL.textColor = NoticeOcToSwift.getColorWith("#25262E")
        contentView .addSubview(titleL)
        self.titleL = titleL
        
        let itemArr = ["移出本社团","移出并禁止加入本社团"]
        for j in 0 ..< 2 {
            let itemBtn = UIButton(type: .custom)
            itemBtn.frame = CGRect(x: 30, y: 64+55*j, width: Int(contentView.frame.size.width-60.0), height: 40)
            itemBtn.layer.cornerRadius = 10
            itemBtn.layer.masksToBounds = true
            itemBtn.setTitle(itemArr[j], for: .normal)
            itemBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            itemBtn.setTitleColor(NoticeOcToSwift.getColorWith("#25262E"), for: .normal)
            itemBtn.backgroundColor = NoticeOcToSwift.getColorWith( "#F7F8FC")
            itemBtn.tag = j
            itemBtn .addTarget(self, action: #selector(choiceItemClick(buttonx:)), for: .touchUpInside)
            contentView .addSubview(itemBtn)
            self.buttonArr .append(itemBtn)
        }
    }
    
    @objc func choiceItemClick(buttonx:UIButton) {
        self.type = buttonx.tag + 1
        buttonx.backgroundColor = NoticeOcToSwift.getColorWith("#0099E6")
        buttonx.setTitleColor(NoticeOcToSwift.getColorWith( "#E1E2E6"), for: .normal)
        for buttons: UIButton in self.buttonArr {
            if buttons.tag != buttonx.tag{
                buttons.setTitleColor(NoticeOcToSwift.getColorWith("#25262E"), for: .normal)
                buttons.backgroundColor = NoticeOcToSwift.getColorWith( "#F7F8FC")
            }
        }
    }
    
    @objc func sureOrCancelClick(button:UIButton){
      
        if button.tag == 1 {
            self .removeFromSuperview()
        }else if self.type > 0{
            
            self.outBlock?(self.type)
            self.removeFromSuperview()
        }else{
            if self.type <= 0{
                NoticeTools.getTopViewController().showToast(withText:"请选择移出方式")
            }
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
