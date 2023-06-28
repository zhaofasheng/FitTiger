//
//  NoticeTestShow.swift
//  NoticeXi
//
//  Created by li lei on 2019/9/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeTestShow: UIView,UIGestureRecognizerDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.textLabel?.text = self.intro
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = NoticeOcToSwift.getMainTextColor()
        cell?.textLabel?.numberOfLines = 0
        cell?.contentView.backgroundColor = NoticeOcToSwift.getBackColor()
        return cell!
    }
    

    @objc public var contentView = UIView()
    @objc public var tableView = UITableView()
    @objc public var icomImageView = UIImageView()
    @objc public var headerView = UIView()
    @objc public var nameL = UILabel()
    @objc public var fromL = UILabel()
    var intro : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: NoticeOcToSwift.devoiceWidth(), height: NoticeOcToSwift.devoiceHeight());
        self.backgroundColor = UIColor.black .withAlphaComponent(0.4);
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth-40.0, height:(NoticeSwiftFile.screenWidth-40.0)/325.0*259.0)
        self.contentView.center = self.center
        self.contentView.backgroundColor = NoticeOcToSwift.getBackColor()
        self.contentView.layer.cornerRadius =  10
        self.contentView.layer.masksToBounds = true
        self.addSubview(self.contentView)
        
        self.tableView.frame = CGRect(x: 15, y: 25, width: self.contentView.frame.size.width-30, height: self.contentView.frame.size.height-50)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.contentView.addSubview(self.tableView)
        self.tableView.backgroundColor = NoticeOcToSwift.getBackColor()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 145)
        
        self.icomImageView.frame = CGRect(x: (self.headerView.frame.size.width-100)/2, y: 0, width: 100, height: 100)
        self.icomImageView.layer.cornerRadius = 5
        self.icomImageView.layer.masksToBounds = true
        self.icomImageView.layer.borderWidth = 3
        self.icomImageView.layer.borderColor = NoticeOcToSwift.getlineColor().cgColor
        self.headerView.addSubview(self.icomImageView)
        
        self.nameL.frame = CGRect(x: 0, y:self.icomImageView.frame.maxY+10, width: self.headerView.frame.size.width, height: 13)
        self.nameL.textAlignment = .center
        self.nameL.textColor = NoticeOcToSwift.getMainTextColor()
        self.nameL.font = UIFont.systemFont(ofSize: 13)
        self.headerView.addSubview(self.nameL)
        self.nameL.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.fromL.frame = CGRect(x: 0, y:self.nameL.frame.maxY+5, width: self.headerView.frame.size.width, height: 13)
        self.fromL.textAlignment = .center
        self.fromL.textColor = NoticeOcToSwift.getMainTextColor()
        self.fromL.font = UIFont.systemFont(ofSize: 13)
        self.headerView.addSubview(self.fromL)
        self.fromL.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.headerView.backgroundColor = NoticeOcToSwift.getBackColor()
        
        self.tableView.tableHeaderView = self.headerView
    }
    
    @objc func showView(){
        let window = UIApplication.shared.keyWindow;
        window!.addSubview(self);
        self.contentView.layer.position = self.center
        self.contentView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        UIView .animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options:AnimationOptions.curveLinear, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (finished:Bool) in

        }

    }
    
    @objc public func refreshTestData(model:NoticeAllPersonlity){
        self.nameL.text = model.role_name
        self.fromL.text = String(format: "《%@》",model.role_from)
        self.intro = model.role_intro
        self.tableView.reloadData()
    }

    
    @objc func iconTap(){
        self.removeFromSuperview()
    }
    
    //判断点击的是否是子视图
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.contentView {
            return false
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
