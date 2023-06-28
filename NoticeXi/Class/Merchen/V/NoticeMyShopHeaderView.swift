//
//  NoticeMyShopHeaderView.swift
//  NoticeXi
//
//  Created by li lei on 2022/6/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeMyShopHeaderView: UIView {

    @objc public var shopImageView :UIImageView?
    @objc public var titleL :UILabel?
    @objc public var typeL :UILabel?
    @objc public var shopView :UIView?
    @objc public var shopIconImageView :UIImageView?
    @objc public var nameL :UILabel?
    @objc public var changeimageV :UIImageView?
    @objc public var serviceImgV :UIImageView?
    @objc public var getImageV :UIImageView?
    @objc public var severL :UILabel?
    @objc public var getL :UILabel?
    @objc public var startBtn :UIButton?
    
    @objc public var choiceRoleView :UIView?
    @objc public var choiceMarkL :UILabel?
    @objc public var roleImageView1 :UIImageView?
    @objc public var roleImageView2 :UIImageView?
    
    @objc public var clickeBlock :((_ choiceType :Int, _ index :Int) ->Void)? //1设置角色1 2设置角色2  3开始营业点击 4切换角色 5编辑
    
    @objc public var shopM :NoticeMyShopModel?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.shopImageView = UIImageView.init(frame: CGRect(x: (NoticeOcToSwift.devoiceWidth()-255)/2, y:20, width: 255, height: 255))
        self.addSubview(self.shopImageView!)
        self.shopImageView?.image = UIImage.init(named: "Image_shoplist")
        self.shopImageView?.isUserInteractionEnabled = true
        
        self.titleL = UILabel.init(frame: CGRect(x: 18, y: 25, width: 219, height: 34))
        self.titleL?.font = UIFont.systemFont(ofSize: 18)
        self.titleL?.textColor = UIColor.init(hexString: "#25262E")
        self.titleL?.textAlignment = NSTextAlignment.center
        self.shopImageView?.addSubview(self.titleL!)
        
        let editBtn = UIButton.init(frame: CGRect(x: 18+219.5-34, y: 25, width: 34, height: 34))
        editBtn.setImage(UIImage.init(named: "edit_shopname"), for: .normal)
        editBtn.addTarget(self, action: #selector(eidtClick), for: .touchUpInside)
        self.shopImageView?.addSubview(editBtn)
        
//        self.typeL = UILabel.init(frame: CGRect(x: (219-NoticeSwiftFile.getSwiftTextWidth(str: "神 秘 小 店", height: 34, font: 18))/2+20+NoticeSwiftFile.getSwiftTextWidth(str: "神 秘 小 店", height: 34, font: 18), y: 25, width: (219-NoticeSwiftFile.getSwiftTextWidth(str: (self.titleL?.text)!, height: 34, font: 18))/2, height: 34))
//        self.typeL?.font = UIFont.systemFont(ofSize: 11)
//        self.typeL?.textColor = UIColor.init(hexString: "#25262E")
//        self.typeL?.text = "~唱歌"
//        self.shopImageView?.addSubview(self.typeL!)
//
        
        self.choiceRoleView = UIView.init(frame: CGRect(x: 20, y:295, width: NoticeSwiftFile.screenWidth-40, height: 108))
        self.choiceRoleView?.layer.cornerRadius = 10
        self.choiceRoleView?.layer.masksToBounds = true
        self.choiceRoleView?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.choiceRoleView?.layer.borderWidth = 1
        self.addSubview(self.choiceRoleView!)
        
        self.choiceMarkL = UILabel.init(frame: CGRect(x:10, y: 24, width: 142, height: 60))
        self.choiceMarkL?.font = UIFont.systemFont(ofSize: 13)
        self.choiceMarkL?.textColor = UIColor.init(hexString: "#25262E")
        self.choiceMarkL?.numberOfLines = 0
        self.choiceMarkL?.attributedText = NoticeTools.getStringWithLineHight(4, string: "神秘小店的店主你\n好！店铺已开通，\n请选择你的角色～")
        self.choiceRoleView?.addSubview(self.choiceMarkL!)
        
        self.roleImageView1 = UIImageView.init(frame: CGRect(x: (self.choiceRoleView?.frame.size.width)!-10-84-10-84, y:12, width: 84, height: 84))
        self.choiceRoleView!.addSubview(self.roleImageView1!)
        self.roleImageView1?.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(choiceTap1))
        self.roleImageView1?.addGestureRecognizer(tap1)
        let changeBtn = UIButton.init(frame: CGRect(x: 64, y: 0, width: 20, height: 20))
        changeBtn.setImage(UIImage.init(named: "Image_shoprole"), for: .normal)
        changeBtn.addTarget(self, action: #selector(setRole1), for: .touchUpInside)
        self.roleImageView1?.addSubview(changeBtn)
        
        self.roleImageView2 = UIImageView.init(frame: CGRect(x: (self.choiceRoleView?.frame.size.width)!-10-84, y:12, width: 84, height: 84))
        self.choiceRoleView!.addSubview(self.roleImageView2!)
        self.roleImageView2?.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(choiceTap2))
        self.roleImageView2?.addGestureRecognizer(tap2)
        let changeBtn1 = UIButton.init(frame: CGRect(x: 64, y: 0, width: 20, height: 20))
        changeBtn1.setImage(UIImage.init(named: "Image_shoprole"), for: .normal)
        changeBtn1.addTarget(self, action: #selector(setRole2), for: .touchUpInside)
        self.roleImageView2?.addSubview(changeBtn1)
        
        self.changeimageV = UIImageView.init(frame: CGRect(x: 59, y:1, width: 26, height: 16))
        self.shopIconImageView?.addSubview(self.changeimageV!)
        self.changeimageV?.image = UIImage.init(named: "Image_shopchange")
        
        self.shopView = UIView.init(frame: CGRect(x: 20, y:295, width: NoticeSwiftFile.screenWidth-40, height: 108))
        self.shopView?.layer.cornerRadius = 10
        self.shopView?.layer.masksToBounds = true
        self.shopView?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.shopView?.layer.borderWidth = 1
        self.addSubview(self.shopView!)
        self.shopView?.isHidden = true
        
        self.shopIconImageView = UIImageView.init(frame: CGRect(x: 11, y: 11, width: 86, height: 86))
        self.shopIconImageView?.layer.cornerRadius = 10
        self.shopIconImageView?.layer.masksToBounds = true;
        self.shopIconImageView?.layer.borderColor = UIColor.init(hexString: "#25262E").cgColor
        self.shopIconImageView?.layer.borderWidth = 1
        self.shopIconImageView?.image = UIImage.init(named: "Image_shopicon")
        self.shopView?.addSubview(self.shopIconImageView!)
        self.isUserInteractionEnabled = true
        self.shopIconImageView?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap))
        self.shopIconImageView?.addGestureRecognizer(tap)
        
        self.changeimageV = UIImageView.init(frame: CGRect(x: 59, y:1, width: 26, height: 16))
        self.shopIconImageView!.addSubview(self.changeimageV!)
        self.changeimageV?.image = UIImage.init(named: "Image_shopchange")
        
        self.serviceImgV = UIImageView.init(frame: CGRect(x: 108, y:49, width: 20, height: 20))
        self.shopView!.addSubview(self.serviceImgV!)
        self.serviceImgV?.image = UIImage.init(named: "Image_shopserv")
        
        self.getImageV = UIImageView.init(frame: CGRect(x: 108, y:78, width: 20, height: 20))
        self.shopView!.addSubview(self.getImageV!)
        self.getImageV?.image = UIImage.init(named: "Image_shopget")
        
    
        self.nameL = UILabel.init(frame: CGRect(x: 108, y: 12, width: 200, height: 22))
        self.nameL?.font = UIFont.systemFont(ofSize: 16)
        self.nameL?.textColor = UIColor.init(hexString: "#25262E")
        self.shopView?.addSubview(self.nameL!)
        
        self.severL = UILabel.init(frame: CGRect(x: 132, y: 49, width: 160, height: 20))
        self.severL?.font = UIFont.systemFont(ofSize: 14)
        self.severL?.textColor = UIColor.init(hexString: "#25262E")
        self.shopView?.addSubview(self.severL!)
        
        self.getL = UILabel.init(frame: CGRect(x: 132, y: 78, width: 160, height: 20))
        self.getL?.font = UIFont.systemFont(ofSize: 14)
        self.getL?.textColor = UIColor.init(hexString: "#25262E")
        
        self.shopView?.addSubview(self.getL!)
        
        let proBtn = UIButton.init(frame: CGRect(x: (self.shopView?.frame.size.width)!-40, y: 0, width: 40, height: 40))
        proBtn.setImage(UIImage.init(named: "proimg_shop"), for: .normal)
        proBtn.addTarget(self, action: #selector(proTap), for: .touchUpInside)
        self.shopView?.addSubview(proBtn)
        
        self.startBtn = UIButton.init(frame: CGRect(x: 68, y: 453, width: NoticeSwiftFile.screenWidth-68*2, height: 50))
        self.startBtn?.layer.cornerRadius = 25
        self.startBtn?.layer.masksToBounds = true
        self.startBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
        self.addSubview(self.startBtn!)
        self.startBtn?.setTitle("开始营业", for: .normal)
        self.startBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.startBtn?.setTitleColor(UIColor.white, for: .normal)
        self.startBtn?.addTarget(self, action: #selector(startClick), for: .touchUpInside)
    }
    
    @objc func startClick() {
        self.clickeBlock?(3, 0)
    }
    
    @objc func iconTap() {
        if self.shopM?.myShopM.role == "1" {
            self.clickeBlock?(2, 0)
        }else{
            self.clickeBlock?(1, 0)
        }
    }
    
    @objc func setRole1() {
        self.clickeBlock?(1, 0)

    }
    
    @objc func setRole2() {
        self.clickeBlock?(2, 0)
    }
    
    @objc func choiceTap1() {
        if (self.shopM?.role_listArr.count)! >= 2 {
            let roleM1 = self.shopM?.role_listArr[0] as! NoticeMyShopModel
            
            let item = YYPhotoGroupItem()
            item.thumbView = self.roleImageView1
            item.largeImageURL = URL.init(string: roleM1.role_img_url)
            
            let view = YYPhotoGroupView.init(groupItems: [item])
            let toView = UIApplication.shared.keyWindow?.rootViewController?.view
            view?.present(fromImageView: self.roleImageView1, toContainer: toView, animated: true, completion: {
                
            })
        }
    }
    
    @objc func choiceTap2() {
        if (self.shopM?.role_listArr.count)! >= 2 {
            let roleM1 = self.shopM?.role_listArr[1] as! NoticeMyShopModel
            
            let item = YYPhotoGroupItem()
            item.thumbView = self.roleImageView2
            item.largeImageURL = URL.init(string: roleM1.role_img_url)
            
            let view = YYPhotoGroupView.init(groupItems: [item])
            let toView = UIApplication.shared.keyWindow?.rootViewController?.view
            view?.present(fromImageView: self.roleImageView2, toContainer: toView, animated: true, completion: {
                
            })
        }
    }
    
    @objc public func refreshModel(shopM:NoticeMyShopModel?){
        
        self.shopM = shopM
        self.titleL?.text = shopM?.myShopM.shop_name
        self.nameL?.text = shopM?.myShopM.shop_name ?? "" + "店铺详情"
       
        self.severL?.text = String(format: "服务%@单",(shopM?.myShopM.order_num ?? "0"))
        self.getL?.text = String(format: "获得%@鲸币",(shopM?.myShopM.income ?? "0"))
        
        for i in 0..<(shopM?.role_listArr.count ?? 0){
            let roleM = shopM?.role_listArr[i] as! NoticeMyShopModel
            if roleM.role == self.shopM?.myShopM.role {
                self.shopIconImageView?.sd_setImage(with: URL.init(string: roleM.role_img_url), completed: { image, error, type, url in

                })
                break
            }
        }
        
        if ((Int)(shopM?.myShopM.role ?? "0") ?? 0 > 0) {
            self.shopView?.isHidden = false
            self.choiceRoleView?.isHidden = true
        
        }else{
            self.shopView?.isHidden = true
            self.choiceRoleView?.isHidden = false
            
            if (shopM?.role_listArr.count)! >= 2 {
                let roleM1 = shopM?.role_listArr[0] as! NoticeMyShopModel
                
                self.roleImageView1?.sd_setImage(with: URL.init(string: roleM1.role_img_url), completed: { image, error, type, url in

                })
                
                let roleM2 = shopM?.role_listArr[1] as! NoticeMyShopModel
                
                self.roleImageView2?.sd_setImage(with: URL.init(string: roleM2.role_img_url), completed: { image, error, type, url in

                })
            }
        }
    }
    
    @objc func proTap(){
        let tostView = NoticeProtocolView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
        tostView.showTitle(title: "解忧杂货铺", content: "·解忧杂货铺\n\n只要你想见我，我随时都在。我会一直在你身边你慢慢说，我慢慢听。通过自己的暖心技能来治愈小伙伴\n\n·鲸币鲸币是声昔APP的虚拟货币，可用于购买杂货铺里的虚拟服务商品。\n\n·店铺规则\n1.店铺需要手动「开始营业」「结束营业」。\n2.店主和顾客的身份都是匿名的。\n3.聊天记录不会保存\n4.店铺营业中，但连续3次以上不接单，将会自动结束营业。\n5.举报核实后，如属实或恶意举报，店铺或顾客会有相应的违规惩罚，具体以管理员通知为准。")
    }
    
    @objc func eidtClick(){
        self.clickeBlock?(5, 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
