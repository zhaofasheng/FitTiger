//
//  NoticeManagerMBSController.swift
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeManagerMBSController: UIViewController ,UITableViewDelegate,UITableViewDataSource,NoticePointDelegate{
    @objc public var mangagerCode:String?
    var tableView:UITableView?
    var isDwon = true
    var lastId : String?
    var readId : String?
    var hasRead = false
    var dataArr = [NoticeManagerCiTiaoM]()
    var firstGetin  = true
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width:NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.BOTTOMHEIGHT()-58-NoticeSwiftFile.NAVHEIGHT()))
        self.tableView?.dataSource = self;
        self.tableView?.delegate = self;
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView?.rowHeight = 194.0
        self.tableView?.register(NoticeManagerCiTiaoCell.self, forCellReuseIdentifier: "citiaocell")
        self.view.addSubview(self.tableView!)
        self.creatRefresh()
        self.getPoint()
    }
    
    /*创建刷新和加载更多*/
    func creatRefresh() {
        
        self.tableView?.mj_header = MJRefreshNormalHeader .init(refreshingBlock: { [weak self] in
            self?.isDwon = true
            self?.pageNo = 1
            self?.request()
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {[weak self] in
            self?.isDwon = false
            self?.pageNo += 1
            self?.request()
        })
    }
    
    /*请求数据*/
    func request() {
        var url = String(format: "admin/entries?confirmPasswd=%@&pageNo=1", self.mangagerCode!)
        if self.isDwon {
            url = String(format: "admin/entries?confirmPasswd=%@&pageNo=1", self.mangagerCode!)
        }else{
            url = String(format: "admin/entries?confirmPasswd=%@&pageNo=%d", self.mangagerCode!,self.pageNo)
        }
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: nil, isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.tableView?.mj_header.endRefreshing()
            self?.tableView?.mj_footer.endRefreshing()
            if success {
                self?.firstGetin = false
                let nsDict = dict! as NSDictionary
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    //
                    return
                }
                
                if (self?.isDwon)! {
                    self?.dataArr .removeAll()
                }
                
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeManagerCiTiaoM.mj_object(withKeyValues: dic)
                    self?.dataArr.append(model!)
                }
            
                if (((self?.dataArr.count)!) > 0) {
                    let lastM = self?.dataArr[(self?.dataArr.count)!-1]
                    if (self?.isDwon)! {
                        self?.isDwon = false
                        let firstM = self?.dataArr[0]
                        if (self?.hasRead)! {
                            firstM?.hasRead = true
                        }
                    }
               
                    self?.lastId = lastM?.ciId
                }
                self?.tableView?.reloadData()
            }
            
            }, fail: {[weak self] (error) in
                self?.tableView?.mj_header.endRefreshing()
                self?.tableView?.mj_footer.endRefreshing()
        })
    }
    
    func getPoint(){
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: String(format: "admin/%@/point/entryPoint", NoticeSaveModel.getUserInfo().user_id), accept: nil, isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            if success {
                let nsDict = dict! as NSDictionary
     
                let model = NoticeManagerCiTiaoM.mj_object(withKeyValues: nsDict["data"])
                self?.readId = model?.pointValue
                self?.hasRead = (model?.hasRead)!
       
                if (model?.hasRead)! {
                    self?.lastId = self?.readId
                    self?.isDwon = true
                    self?.request()
                }
            }

            }, fail: { (error) in
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiaocell") as! NoticeManagerCiTiaoCell
        cell.passCode = self.mangagerCode!
        cell.ciM = self.dataArr[indexPath.section]
        if indexPath.section > 0 {
            cell.nextCiM = self.dataArr[indexPath.section-1]
        }
        cell.delegate = self
        cell.index = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArr[indexPath.section]
        if model.resource_type == "3" {
            return 194.0-39.0
        }
        return 194.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.dataArr[section]
        if model.hasRead {
            let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenWidth/375*35))
            imgView.image = UIImage.init(named: "readsetimg")
            return imgView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = self.dataArr[section]
        return model.hasRead ? NoticeSwiftFile.screenWidth/375*35 : 0.0
    }
    

    func readPointSetSuccess(_ index: Int) {
        for noM in self.dataArr {
            noM.hasRead = false
        }
        if self.dataArr.count > 0{
            let model = self.dataArr[index]
            let model1 = self.dataArr[index-1]
            self.readId = model1.ciId
            self.hasRead = true
            model.hasRead = true
        }
        
        self.tableView?.reloadData()
    }
}
