//
//  NoticeManagerCenterController.swift
//  NoticeXi
//
//  Created by li lei on 2020/6/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeManagerCenterController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @objc public var mangagerCode:String?
    @objc public var tableView:UITableView?
    var isDwon = true
    var lastId : String?
    var dataArr = [NoticeManagerJuBaoModel]()
    @objc public var type : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width:NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.BOTTOMHEIGHT()-58-NoticeSwiftFile.NAVHEIGHT()))
        self.tableView?.dataSource = self;
        self.tableView?.delegate = self;
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView?.rowHeight = 60.0
        self.tableView?.register(NoticeManagerWorkCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        self.tableView?.backgroundColor = NoticeOcToSwift.getBackColor()
        self.creatRefresh()
        self.tableView?.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkRequest), name: NSNotification.Name(rawValue:"waitCheck"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(upPyDataChange(notif:)), name: NSNotification.Name(rawValue:"postHasDianZanInPageManagerPy"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upDataChange(notif:)), name: NSNotification.Name(rawValue:"postHasDianZanInPageManager"), object: nil)
    }
    
    @objc func upDataChange(notif: NSNotification){
        let linM = NoticeClockPyModel.mj_object(withKeyValues: notif.userInfo)
        for model in self.dataArr {
            let oldM = NoticeClockPyModel.mj_object(withKeyValues: model.line)
            if oldM?.tcId == linM?.tcId {
                model.line = notif.userInfo ?? model.line
            }
            
        }
        self.tableView?.reloadData()
    }
    
    @objc func upPyDataChange(notif: NSNotification){
        let linM = NoticeClockPyModel.mj_object(withKeyValues: notif.userInfo)
        for model in self.dataArr {
            let oldM = NoticeClockPyModel.mj_object(withKeyValues: model.dubbing)
            if oldM?.pyId == linM?.pyId {
                model.dubbing = notif.userInfo ?? model.dubbing
            }
        }
        self.tableView?.reloadData()
    }
    
    @objc func checkRequest() {
        self.isDwon = true
        self.request()
    }

    /*请求数据*/
    func request() {
        
        var url = String(format: "admin/suspiciousDatas?confirmPasswd=%@", self.mangagerCode!)
        if self.isDwon {
            url = String(format: "admin/suspiciousDatas?confirmPasswd=%@", self.mangagerCode!)
        }else{
            url = String(format: "admin/suspiciousDatas?confirmPasswd=%@&lastId=%@", self.mangagerCode!,self.lastId ?? "")
        }
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: nil, isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.tableView?.mj_header.endRefreshing()
            self?.tableView?.mj_footer.endRefreshing()
            if success {
                
                let nsDict = dict! as NSDictionary
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    return
                }
                
                if (self?.isDwon)! {
                    self?.isDwon = false
                    self?.dataArr .removeAll()
                }
                
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeManagerJuBaoModel.mj_object(withKeyValues: dic)
                    self?.dataArr.append(model!)
                }
                if (((self?.dataArr.count)!) > 0) {
                    let lastM = self?.dataArr[(self?.dataArr.count)!-1]
                    
                    self?.lastId = lastM?.jubaoId
                }
                self?.tableView?.reloadData()
            }
            
            }, fail: {[weak self] (error) in
                self?.tableView?.mj_header.endRefreshing()
                self?.tableView?.mj_footer.endRefreshing()
        })
    }
    
    /*创建刷新和加载更多*/
    func creatRefresh() {
        
        self.tableView?.mj_header = MJRefreshNormalHeader .init(refreshingBlock: { [weak self] in
            self?.isDwon = true
            self?.request()
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {[weak self] in
            self?.isDwon = false
            self?.request()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeManagerWorkCell
        cell.isshCenter = true
        cell.refreshCenterData(model: self.dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action1 = UITableViewRowAction.init(style: .normal, title:self.type == "2" ? "待调查" : "已处理") {[weak self] (action, indexPath) in
            self?.actionWith(row: indexPath.row, reportStatus: self!.type == "2" ? "0" : "2")
        }
        action1.backgroundColor = NoticeOcToSwift.getColorWith("#F67280")
        
        
        let action2 = UITableViewRowAction.init(style: .normal, title:self.type == "1" ? "待调查" : "待处理") {[weak self] (action, indexPath) in
            self?.actionWith(row: indexPath.row, reportStatus: self!.type == "1" ? "0" : "1")
        }
        action2.backgroundColor = NoticeOcToSwift.getColorWith("#CCCCCC")
        return [action1,action2]
    }
    
    func actionWith(row:NSInteger,reportStatus:String){
        let model = self.dataArr[row]
        
        let parm = NSMutableDictionary()
        parm.setObject(self.mangagerCode!, forKey: "confirmPasswd" as NSCopying)
        parm.setObject(reportStatus, forKey: "reportStatus" as NSCopying)
        DRNetWorking.shareInstance()?.request(withPatchPath: String(format: "admin/reports/%@", model.jubaoId), accept: nil, parmaer: parm, page: 0, success: { [weak self] (dict, success) in
            
            if success {
                self?.dataArr .remove(at: row)
                self?.tableView?.reloadData()
                self?.showToast(withText: reportStatus == "1" ? "已移到待处理" : (reportStatus == "2" ? "已移到已处理" : "已移到待调查"))
                if reportStatus == "0" {
                    NotificationCenter.default.post(name: NSNotification.Name("waitCheck"), object: nil, userInfo:nil)
                }else if reportStatus == "1" {
                    NotificationCenter.default.post(name: NSNotification.Name("waitWork"), object: nil, userInfo:nil)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name("worked"), object: nil, userInfo:nil)
                }
            }
            
            }, fail: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let juM = self.dataArr[indexPath.row];
        if juM.data_type == "10" {
            let ctl = NoticeMangerVoiceController()
            ctl.groupM = juM.groupChatModel
            ctl.mangagerCode = self.mangagerCode!
            ctl.juModel = self.dataArr[indexPath.row]
            ctl.isFRomCenter = true
            self.navigationController?.pushViewController(ctl, animated: true)
            return
        }
        
        let ctl = NoticeCheckCenterTypeController()
        ctl.mangagerCode = self.mangagerCode!
        ctl.juModel = self.dataArr[indexPath.row]
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}
