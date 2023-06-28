//
//  NoticeMyShopController.swift
//  NoticeXi
//
//  Created by li lei on 2022/6/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeMyShopController: BaseTableViewController {

    @objc public var headerView :NoticeMyShopHeaderView?
    var headerL :UILabel?
    var supplyView :NoticeSupplyShopView?
    @objc public var applyModel :NoticeCureentShopStatusModel?
    @objc public var goodisId = ""
    @objc public var shopModel :NoticeMyShopModel?
    @objc public var goodsArr = NSMutableArray()
    @objc public var listBtn :UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.needHideNavBar = true
        self.needBackGroundView = false
        self.navBarView.isHidden = false
        
        self.navBarView.backButton.setImage(UIImage.init(named: "Image_blackBack"), for: .normal)
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.tableView.backgroundColor = self.view.backgroundColor;
        
        self.navBarView.titleL.text = "我的店铺"
        self.navBarView.titleL.textColor = UIColor.init(hexString: "#25262E");
        

        self.tableView.frame = CGRect(x: 0, y: NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT())
        self.tableView.rowHeight = 90
        self.tableView.register(NoticeShopMerchCell.self, forCellReuseIdentifier: "cell")
        
        self.headerView = NoticeMyShopHeaderView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 295+108+50+50+50))
        self.tableView.tableHeaderView = self.headerView
        self.headerView?.clickeBlock = {[weak self] (type, index) in
            if type == 3{
                
                self?.startWorking()
            }else if type == 1 || type == 2{
                self?.setRoleWith(roleType: type)
            }else if type == 5{
                self?.editClick()
            }
        }
        
        self.headerL = UILabel.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 40))
        self.headerL?.textAlignment = NSTextAlignment.center
        self.headerL?.font = UIFont.systemFont(ofSize: 18)
        self.headerL?.textColor = UIColor.init(hexString: "#25262E")
        self.headerL?.text = "请选择一个店铺要售卖的商品"
        self.headerL?.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.tableView.isHidden = true
        
        self.supplyView = NoticeSupplyShopView.init(frame: CGRect(x: 0, y: 10+NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height:NoticeSwiftFile.screenHeight - NoticeSwiftFile.NAVHEIGHT()-20))
        self.view.addSubview(self.supplyView!)
        self.supplyView?.startBtn?.addTarget(self, action: #selector(supplyClick), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(hasSypply), name: NSNotification.Name(rawValue:"HASSUPPLYSHOPNOTICE"), object: nil)
        
        self.supplyView?.isHidden = true
        
        let userM = NoticeSaveModel.getUserInfo()
        if (userM.comeHereDays as NSString).integerValue < 100 && (userM.mobile as NSString).integerValue < 10000{
            self.supplyView?.getL?.text = "未满足申请条件“来声昔100天、绑定手机“"
            self.supplyView!.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
            self.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
            self.supplyView?.isHidden = false
        }else if (userM.comeHereDays as NSString).integerValue < 100 && (userM.mobile as NSString).integerValue > 10000{
            self.supplyView?.getL?.text = "未满足申请条件“来声昔100天“"
            self.supplyView!.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
            self.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
            self.supplyView?.isHidden = false
        }else if (userM.comeHereDays as NSString).integerValue >= 100 && (userM.mobile as NSString).integerValue < 10000{
            self.supplyView?.getL?.text = "未满足申请条件“绑定手机“"
            self.supplyView!.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
            self.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
            self.supplyView?.isHidden = false
        }
        else{
            self.supplyView?.getL?.text = "已满足申请条件“来声昔100天、绑定手机“"
            self.supplyView!.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
            self.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
            self.getStatusRequest()
        }
    }
    
    @objc func getStatusRequest(){
        let url = "shop/getApplyStage"//String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
                self?.applyModel = NoticeCureentShopStatusModel.mj_object(withKeyValues: nsDict["data"])
                
                if self?.applyModel?.status ?? 0 < 4 || self?.applyModel?.status ?? 0 == 5{
                    self?.supplyView?.isHidden = false
                    self?.supplyView?.getL?.text = "已满足申请条件“来声昔100天、绑定手机“"
                    self?.supplyView?.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                    self?.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
                }else if self?.applyModel?.status ?? 0 == 4 {
                    self?.supplyView?.getL?.isHidden = true
                    self?.supplyView?.isHidden = false
                    self?.supplyView?.startBtn?.setTitle("已申请，等待审核", for: .normal)
                    self?.supplyView?.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                    self?.supplyView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                }else if self?.applyModel?.status ?? 0 == 6 {
                    self?.supplyView?.isHidden = true
                    self?.tableView.isHidden = false
                    self?.listBtn?.isHidden = false
                    self?.getShopRequest()
                }
            }
 
            }, fail: {[weak self] (error) in
                self?.hideHUD()
                self?.showToast(withText: error.debugDescription)
        })
    }
    
    @objc func getShopRequest(){
        let url = "shop/ByUser"
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
          
                self?.shopModel = NoticeMyShopModel.mj_object(withKeyValues: nsDict["data"])
                self?.headerView?.refreshModel(shopM: self?.shopModel)
                print(self?.shopModel?.myShopM.is_stop as Any)
                if ((Int)(self?.shopModel?.myShopM.is_stop ?? "0") ?? 0) > 0{
                    if self?.shopModel?.myShopM.is_stop == "1" {
                        self?.headerView?.startBtn?.setTitle("店铺已被永久关闭", for: .normal)
                        self?.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                        self?.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                    }else{
                        self?.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                        self?.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                        self?.headerView?.startBtn?.setTitle("暂停营业中" + NoticeTools.getDaoishi(self?.shopModel?.myShopM.is_stop ?? ""), for: .normal)
                    }
                }else{
                    if self?.shopModel?.myShopM.operate_status == "2"{
                        self?.headerView?.startBtn?.setTitle("营业中，结束营业", for: .normal)
                        self?.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#DB6E6E")
                        self?.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                    }
                    else if ((Int)(self?.shopModel?.myShopM.role ?? "0") ?? 0 <= 0) || ((self?.goodisId.count)! <= 0){
                        self?.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
                        self?.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
                        self?.headerView?.startBtn?.setTitle("开始营业", for: .normal)
                    }else if self?.shopModel?.myShopM.operate_status == "1"{
                        self?.headerView?.startBtn?.setTitle("开始营业", for: .normal)
                        self?.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#FFFFFF")
                        self?.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#0099E6"), for: .normal)
                    }
                }
                self?.goodsArr = self?.shopModel!.goods_listArr ?? []
                self?.tableView.reloadData()
            }
 
            }, fail: {[weak self] (error) in
                self?.hideHUD()
                self?.showToast(withText: error.debugDescription)
        })
    }
    
    //开始营业
    @objc func startWorking (){
        
        if ((Int)(self.shopModel?.myShopM.is_stop ?? "0") ?? 0) > 0{
            return
        }
        
        if self.shopModel?.myShopM.operate_status == "2"{
            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: String(format: "shop/operateStatus/%@/1", (self.shopModel?.myShopM.shopId)!), accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: nil, page: 0, success: {[weak self] (dict, success) in
                if success == true{
                    self?.getShopRequest()
                }
            }, fail: nil)
            return
        }
        
        if ((Int)(self.shopModel?.myShopM.role ?? "0") ?? 0 <= 0){
            self.showToast(withText: "请选择您的角色")
            return
        }
        
        if (self.goodisId.count) <= 0{
            self.showToast(withText: "请在下方列表选择一个您要营业的商品")
            return
        }
        
        if self.shopModel?.myShopM.operate_status == "1"{
            let parm = NSMutableDictionary()
            parm .setObject(self.goodisId as Any, forKey: "goods_id" as NSCopying)

            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: String(format: "shop/operateStatus/%@/2", (self.shopModel?.myShopM.shopId)!), accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                if success == true{
                    self?.getShopRequest()
                }
            }, fail: nil)
        }
    }
    
    @objc func setRoleWith(roleType:Int){
        
        
        if (self.shopModel?.role_listArr.count)! >= 2 {
            let roleM = self.shopModel?.role_listArr[roleType-1] as! NoticeMyShopModel
            
            let parm = NSMutableDictionary()
            parm .setObject(roleM.role as Any, forKey: "role" as NSCopying)

            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "shop/"+(self.shopModel?.myShopM.shopId)!, accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                if success == true{
                    self?.getShopRequest()
                }
            }, fail: nil)
        }
        
    }
    
    @objc func editClick(){
        let inputView = NoticeChangeShopNameView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
        inputView.nameBlock = {[weak self] (name) in
            let parm = NSMutableDictionary()
            parm .setObject(name ?? "", forKey: "shop_name" as NSCopying)

            DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "shop/"+(self?.shopModel?.myShopM.shopId)!, accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                if success == true{
                    self?.getShopRequest()
                }
            }, fail: nil)
        }
        inputView.showView()
    }

    @objc func supplyClick(){
        let userM = NoticeSaveModel.getUserInfo()
        if (userM.comeHereDays as NSString).integerValue < 100 {
            return
        }
        if self.applyModel?.status ?? 0 == 5{
            let ctl = NoticeSupplyProController()
            self.navigationController?.pushViewController(ctl, animated: true)
        }else if self.applyModel?.status ?? 0 < 4 && self.applyModel?.status ?? 0 > 0{
            let ctl = NoticeSupplyProController()
            self.navigationController?.pushViewController(ctl, animated: true)
        }
       
    }
    
    @objc func hasSypply(){
        self.applyModel?.apply_stage = "4"
        self.showToast(withText: "已申请，等待审核")
        self.supplyView!.getL?.isHidden = true
        self.supplyView!.startBtn?.setTitle("已申请，等待审核", for: .normal)
        self.supplyView!.startBtn?.setTitleColor(UIColor.init(hexString: "#E1E4F0"), for: .normal)
        self.supplyView!.startBtn?.backgroundColor = UIColor.init(hexString: "#A1A7B3")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsArr.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerL!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeShopMerchCell
        cell.refreshData(goodsM: self.goodsArr[indexPath.row] as? NoticeGoodsModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.shopModel?.myShopM.operate_status == "2" {
            self.showToast(withText: "营业中不可以切换商品哦~")
            return
        }
        
        if ((Int)(self.shopModel?.myShopM.is_stop ?? "0") ?? 0) > 0 {
            return
        }
            
        
        for i in 0..<self.goodsArr.count{
            let goodM = self.goodsArr[i] as! NoticeGoodsModel
            goodM.choice = "0"
        }

        let choiceMdel = self.goodsArr[indexPath.row] as? NoticeGoodsModel
        choiceMdel?.choice = "1"
        self.goodisId = choiceMdel?.goodId ?? ""
        self.tableView.reloadData()
        
        
        if ((Int)(self.shopModel?.myShopM.role ?? "0") ?? 0 > 0) && ((self.goodisId.count) > 0){
            self.headerView?.startBtn?.setTitle("开始营业", for: .normal)
            self.headerView?.startBtn?.backgroundColor = UIColor.init(hexString: "#0099E6")
            self.headerView?.startBtn?.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        }
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appdel = UIApplication.shared.delegate as! AppDelegate
        
        if appdel.floatView.isPlaying {
            appdel.floatView.noRePlay = true
            appdel.floatView.audioPlayer?.stopPlaying()
        }
        appdel.floatView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        appdel.floatView.isHidden = false
    }
}
