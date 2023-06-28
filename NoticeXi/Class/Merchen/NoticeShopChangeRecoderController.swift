//
//  NoticeShopChangeRecoderController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopChangeRecoderController: BaseTableViewController {

    @objc public var isShouRuDetail = false //是否收入明细
    var isDwon = true
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.needHideNavBar = true
        self.needBackGroundView = false
        self.navBarView.isHidden = false
        
        self.navBarView.backButton.setImage(UIImage.init(named: "Image_blackBack"), for: .normal)
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.tableView.backgroundColor = self.view.backgroundColor
        
        self.navBarView.titleL.text = "交易记录"
        self.navBarView.titleL.textColor = UIColor.init(hexString: "#25262E");
        
        if self.isShouRuDetail {
            self.navBarView.titleL.text = "收入明细"
        }
        
        self.tableView.rowHeight = 90
        self.tableView.frame = CGRect(x: 0, y: NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT())
        self.tableView.register(NoticeShopRecodCell.self, forCellReuseIdentifier: "cell")
        
        self.dataArr = NSMutableArray()
        self.creatRefresh()
        self.tableView.mj_header.beginRefreshing()
    }
    
    /*请求数据*/
    func request() {
      
        let url = String(format: "transactionRecord?pageNo=%d", self.pageNo)
        
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: self.isShouRuDetail ? String(format: "transactionRecord?pageNo=%d&resourceType=4", self.pageNo):url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
            if success {
                
                let nsDict = dict! as NSDictionary
                
                if (self?.isDwon)! {
                    self?.isDwon = false
                    self?.dataArr.removeAllObjects()
                }

                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    self?.queshenView.titleImageV.image = UIImage.init(named: "Image_quesy21");
                    self?.queshenView.titleStr = "还没有交易记录哦~";
                    self?.tableView.tableFooterView = self?.queshenView
                    self?.tableView.reloadData()
                    return
                }
                
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeChangeRecoderModel.mj_object(withKeyValues: dic)
                    self?.dataArr.add(model!)
                }
              
                if self?.dataArr.count ?? 0 > 0 {
                    self?.tableView.tableFooterView = nil
                }else{
                    self?.queshenView.titleImageV.image = UIImage.init(named: "Image_quesy21");
                    self?.queshenView.titleStr = "还没有交易记录哦~";
                    self?.tableView.tableFooterView = self?.queshenView
                }
                
                self?.tableView.reloadData()
            }
 
            }, fail: {[weak self] (error) in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
        })
    }
    
    /*创建刷新和加载更多*/
    func creatRefresh() {

        self.tableView.mj_header = MJRefreshNormalHeader .init(refreshingBlock: { [weak self] in
            self?.isDwon = true
            self?.pageNo = 1
            self?.request()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {[weak self] in
            self?.isDwon = false
            self?.pageNo += 1
            self?.request()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeShopRecodCell
        cell.refreshModel(recoM: self.dataArr[indexPath.row] as? NoticeChangeRecoderModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctl = NoticeChangeRecoderDetailController()
        ctl.recoModel = (self.dataArr[indexPath.row] as? NoticeChangeRecoderModel)!
        self.navigationController?.pushViewController(ctl, animated: true)
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
