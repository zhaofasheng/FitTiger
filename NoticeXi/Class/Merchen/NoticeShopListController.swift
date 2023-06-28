//
//  NoticeShopListController.swift
//  NoticeXi
//
//  Created by li lei on 2022/6/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShopListController: BaseTableViewController {

    @objc public var shopArr = NSMutableArray()
    @objc public var queshengView :UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.needHideNavBar = true
        self.needBackGroundView = false
        self.navBarView.isHidden = false
        
        self.navBarView.backButton.setImage(UIImage.init(named: "Image_blackBack"), for: .normal)
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.tableView.backgroundColor = self.view.backgroundColor
        self.navBarView.titleL.text = "解忧杂货铺"
        self.navBarView.titleL.textColor = UIColor.init(hexString: "#25262E");
        
        self.tableView.rowHeight = 255
        self.tableView.frame = CGRect(x: 0, y: NoticeSwiftFile.NAVHEIGHT()+40, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-40)
        self.tableView.register(NoticeShoplistCell.self, forCellReuseIdentifier: "cell")
        
        let refreshButton = UIButton.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-20-65, y: NoticeSwiftFile.NAVHEIGHT()+8, width: 65, height: 24))
        refreshButton.setTitle("刷新", for: .normal)
        refreshButton.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        refreshButton.layer.cornerRadius = 12
        refreshButton.layer.masksToBounds = true
        refreshButton.backgroundColor = UIColor.init(hexString: "#0099E6")
        self.view.addSubview(refreshButton)
        refreshButton.addTarget(self, action: #selector(refreshClick), for: .touchUpInside)
        
        let homeButton = UIButton.init(frame: CGRect(x: NoticeSwiftFile.screenWidth-20-24, y: (NoticeSwiftFile.NAVHEIGHT()-NoticeSwiftFile.STATUSHEIGHT()-24)/2+NoticeSwiftFile.STATUSHEIGHT(), width: 24, height: 24))
        self.view.addSubview(homeButton)
        homeButton.setBackgroundImage(UIImage.init(named: "Image_shophome"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeClick), for: .touchUpInside)
        
        self.queshengView = UIView.init(frame:self.tableView.bounds)
        self.queshengView?.backgroundColor = self.tableView.backgroundColor
        
        let quesImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        quesImageView.image = UIImage.init(named: "shoplist_qq")
        self.queshengView?.addSubview(quesImageView)
        quesImageView.center = self.queshengView!.center
        
        let queL = UILabel.init(frame: CGRect(x: 0, y: quesImageView.frame.origin.y+180+20, width: NoticeSwiftFile.screenWidth, height: 20))
        queL.text = "暂时没有店铺在营业中噢～"
        queL.textAlignment = NSTextAlignment.center
        queL.font = UIFont.systemFont(ofSize: 14)
        queL.textColor = UIColor.init(hexString: "#8A8F99")
        self.queshengView?.addSubview(queL)
        
        self.refreshClick()
    }
    
    @objc func homeClick(){
        let ctl = NoticeMyShopController()
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
 
    
    @objc func refreshClick(){
        let url = "shop/list"//String(format: "admin/reports?confirmPasswd=%@&reportStatus=%@", self.mangagerCode!,self.type!)
        self.showHUD()
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.8+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.hideHUD()
            if success {
                
                let nsDict = dict! as NSDictionary
                self?.shopArr.removeAllObjects()
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    self?.tableView.tableFooterView = self?.queshengView
                    self?.tableView.reloadData()
                    return
                }
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeMyShopModel.mj_object(withKeyValues: dic)
                    self?.shopArr.add(model as Any)
                }
                
                if self?.shopArr.count ?? 0 > 0{
                    self?.tableView.tableFooterView = nil
                }else{
                    self?.tableView.tableFooterView = self?.queshengView
                }
                
                self?.tableView.reloadData()
            }
 
            }, fail: {[weak self] (error) in
                self?.tableView.reloadData()
                self?.hideHUD()
                self?.showToast(withText: error.debugDescription)
        })
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctl = NoticeShopDetailController()
        let shopM = self.shopArr[indexPath.row]
        ctl.shopModel = (shopM as! NoticeMyShopModel)
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeShoplistCell
        cell.refreshModel(shopM: (self.shopArr[indexPath.row] as! NoticeMyShopModel))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopArr.count
    }
}
