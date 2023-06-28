//
//  NoticeLeaderController.swift
//  NoticeXi
//
//  Created by li lei on 2022/3/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeLeaderController: NoticeBaseListController {
    
    public var currentModel :NoticeLeaderModel?
    var showImageView :UIImageView?
    var currentIndex = 0
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentModel = self.dataArr[indexPath.row] as? NoticeLeaderModel
       // [[NSNotificationCenter defaultCenter]postNotificationName:@"SETTOPNOTICENTERION" object:self userInfo:@{@"voiceId":self.priModel.voice_id,@"isTop":self.priModel.is_top,@"voiceIdentity":self.priModel.voiceIdentity}];
        let appdel = UIApplication.shared.delegate as! AppDelegate
        appdel.currentGudeId = self.currentModel?.leadId
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTICELEAERTAPNOTICE"), object: nil, userInfo:["type":indexPath.row.description])
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoticeListenCell
        cell.leadM = self.dataArr[indexPath.row] as! NoticeLeaderModel
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.frame = CGRect(x: 0, y: NoticeSwiftFile.NAVHEIGHT(), width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT())
        self.tableView.register(NoticeListenCell.self, forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 145
        self.tableView.delegate = self
        self.navBarView.isHidden = false
        self.navBarView.titleL.text = "新手指南"
        //self.navBarView.backButton.setImage(UIImage.init(named: ""), for: .normal)
        self.dataArr = NSMutableArray()
        
        self.request()

    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.showImageView?.removeFromSuperview()
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        appdel.floatView.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appdel = UIApplication.shared.delegate as! AppDelegate
        appdel.floatView.isHidden = true
        appdel.floatView.isNoRefresh = true
        appdel.floatView.audioPlayer?.stopPlaying()
       
    }
    
    /*请求数据*/
    func request() {
                
        let url = String(format: "taskGuide/2/%@",NoticeSaveModel.getVersion())
        
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.3.4+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in

            if success {

                let nsDict = dict! as NSDictionary
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    //
                    return
                }
                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeLeaderModel.mj_object(withKeyValues: dic)
                    self?.dataArr.add(model as Any)
                }

                self?.tableView.reloadData()
            }

            },fail: nil)
    }
}
