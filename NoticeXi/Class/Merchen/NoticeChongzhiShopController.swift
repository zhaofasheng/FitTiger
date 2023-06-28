//
//  NoticeChongzhiShopController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeChongzhiShopController: BaseTableViewController {
    
    @objc public var headerView :NoticeChongzhiJbView?
    
    @objc public var wallectModel :NoticeMyWallectModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-48)
        self.tableView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        
        self.headerView = NoticeChongzhiJbView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight))
        self.tableView.tableHeaderView = self.headerView!
        NotificationCenter.default.addObserver(self, selector: #selector(getMyWallect), name: NSNotification.Name(rawValue:"REFRESHMYWALLECT"), object: nil)
     
        self.getMyWallect()
    }
    
    @objc func getMyWallect(){
        let url = "wallet"
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
          
                self?.wallectModel = NoticeMyWallectModel.mj_object(withKeyValues: nsDict["data"])
                self?.headerView?.moneyL?.text = self?.wallectModel?.total_balance ?? "0"
                self?.headerView?.allL?.text = "收入" + (self?.wallectModel?.income_balance ?? "0") + "+" + "充值" + (self?.wallectModel?.recharge_balance ?? "0")
            }
 
            }, fail: {[weak self] (error) in
                self?.hideHUD()
                self?.showToast(withText: error.debugDescription)
        })
    }
}
