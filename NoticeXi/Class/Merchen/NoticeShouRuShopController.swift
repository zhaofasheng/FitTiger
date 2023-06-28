//
//  NoticeShouRuShopController.swift
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeShouRuShopController: BaseTableViewController {

    @objc public var headerView :NoticeShopSRHeadeerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.view.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        self.tableView.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-48)
        
        self.headerView = NoticeShopSRHeadeerView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: 584))
        self.tableView.tableHeaderView = self.headerView
        
        let proStr = "说明：\n1.提现规则：仅限收入中的鲸币，自己充值的鲸币不能提现\n2.提现额度：单笔提现最少不少于10鲸币，最多不大于2000鲸币\n3.提现时间：一般24小时\n4.实名认证：每个实名认证账号只可绑定一个声昔账号\n5.充值24小时未到账，请联系声昔客服小二"
        let height = NoticeTools.getSpaceLabelHeight(proStr, with: UIFont.systemFont(ofSize: 14), withWidth: NoticeSwiftFile.screenWidth-40)
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: height+30))
        footView.backgroundColor = UIColor.init(hexString: "#F7F8FC")
        let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: NoticeSwiftFile.screenWidth-40, height: height))
        label.textColor = UIColor.init(hexString: "#25262E")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.attributedText = NoticeTools.setLabelSpacewithValue(proStr, with: UIFont.systemFont(ofSize: 14))
        footView.addSubview(label)
        
        self.tableView.tableFooterView = footView
    }
}
