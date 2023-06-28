//
//  NoticeShopDetailController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopDetailController: BaseTableViewController {

    var headerView :NoticeShopDetailHeaderView?
    @objc public var shopModel :NoticeMyShopModel?
    @objc public var timeModel :NoticeMyShopModel?
    @objc public var shopDetailM :NoticeMyShopModel?
    @objc public var choiceGoods :NoticeGoodsModel?
    @objc public var orderM :NoticeByOfOrderModel?
    @objc public var isBuying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needHideNavBar = true
        self.needBackGroundView = false
        self.navBarView.isHidden = false
        
        self.navBarView.backButton.setImage(UIImage.init(named: "Image_blackBack"), for: .normal)
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.navBarView.titleL.text = self.shopModel?.shop_name
        self.navBarView.titleL.textColor = UIColor.init(hexString: "#25262E");
        
        self.tableView.rowHeight = 90
        self.tableView.frame = CGRect(x: 0, y: NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT())
        self.tableView.register(NoticeShopDetailCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = self.view.backgroundColor
        
        self.headerView = NoticeShopDetailHeaderView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 158))
        self.tableView.tableHeaderView = self.headerView
        self.getShopRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(hasKillApp), name: NSNotification.Name(rawValue:"APPWASKILLED"), object: nil)
        self.getTime()
    }
    
    @objc func getTime(){
        let url = "adminConfig/1"
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.4.2+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
                
                self?.timeModel = NoticeMyShopModel.mj_object(withKeyValues: nsDict["data"])
            }
            
        }, fail: {[weak self] (error) in
            self?.hideHUD()
            self?.showToast(withText: error.debugDescription)
        })
    }
    
    @objc func getShopRequest(){
        let url = "shopInfo/" + (self.shopModel?.shopId ?? "" + "?type=2")
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
          
                self?.shopDetailM = NoticeMyShopModel.mj_object(withKeyValues: nsDict["data"])
                self?.headerView?.refreShop(shopM: self?.shopDetailM?.myShopM)
                self?.tableView.reloadData()
            }
 
            }, fail: {[weak self] (error) in
                self?.hideHUD()
                self?.showToast(withText: error.debugDescription)
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeShopDetailCell
        let goodsM = self.shopDetailM?.goods_listArr[indexPath.row]
        cell.refreshData(goodsM: goodsM as? NoticeGoodsModel)
        
        cell.getServerBlock = {[weak self] (getGoodsM) in
            self?.choiceGoods = getGoodsM
            
            let sureView = NoticeShopXiaDanTostaView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
            sureView.sureXdBlock = {[weak self] (sure) in
                self?.showHUD()
                let parm = NSMutableDictionary()
                parm .setObject(self?.choiceGoods?.goodId as Any, forKey: "goodsId" as NSCopying)
                parm .setObject(self?.shopModel?.shopId as Any, forKey: "shopId" as NSCopying)
         
                DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: "shopGoodsOrder", accept: "application/vnd.shengxi.v5.3.8+json", isPost: true, parmaer: parm, page: 0, success: {[weak self] (dict, success) in
                    let allM = NoticeOneToOne.mj_object(withKeyValues: dict)
                    self?.hideHUD()
                    if success == true{
                        
                        let nsDict = dict! as NSDictionary
                        
                        self?.orderM = NoticeByOfOrderModel.mj_object(withKeyValues: nsDict["data"])
                        self?.isBuying = true
                        //下单成功
                        NoticeQiaojjieTools.show(withJieDanTitle: self?.orderM?.user_nick_name ?? "", orderId: self?.orderM?.orderId ?? "", time: self?.timeModel?.get_order_time ?? "", creatTime: self?.orderM?.created_at ?? "", clickBlcok: {[weak self] (click) in
                            
                            self?.cancelOrder()//取消订单
                        
                        })
                    }else{
                        if allM?.code == "288" {//用户余额不足
                            NoticeQiaojjieTools.show(withTitle: "你的鲸币余额不足，需要充值才能继续下单噢", msg: "", button1: "再想想", button2: "充值") { [weak self] (click) in
                                self?.chongzhiView()
                            }
                        }else{
                            NoticeQiaojjieTools.show(withTitle: allM?.msg ?? "")
                        }
                    }
                }, fail: {[weak self] (error) in
                    self?.hideHUD()
                    self?.showToast(withText: error.debugDescription)
           
                })
            }
            sureView.showView()
        }
        
        return cell
    }
    
    @objc func cancelOrder() {//用户取消订单
        let parm1 = NSMutableDictionary()
        parm1.setObject("2", forKey: "orderType" as NSCopying)
        parm1.setObject(self.orderM?.orderId as Any, forKey: "orderId" as NSCopying)
        DRNetWorking.shareInstance()?.request(withPatchPath: "shopGoodsOrder", accept: "application/vnd.shengxi.v5.3.8+json", parmaer: parm1, page: 0, success: { [weak self] (dict, success) in
            
            if success {
                self?.isBuying = false
            }
            
        }, fail: nil)
    }
    
    @objc func hasKillApp(){
        
        if self.isBuying && (self.orderM?.orderId.count ?? 0) > 0 {
            self.cancelOrder()
        }
    }
    
    @objc func chongzhiView(){
        let payV = NoticeChongZhiTosatView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
        payV.showView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopDetailM?.goods_listArr.count ?? 0
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
        self.isBuying = false
        let appdel = UIApplication.shared.delegate as! AppDelegate
        appdel.floatView.isHidden = false
    }


}
