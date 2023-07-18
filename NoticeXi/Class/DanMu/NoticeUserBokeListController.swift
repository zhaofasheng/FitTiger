//
//  NoticeUserBokeListController.swift
//  NoticeXi
//
//  Created by li lei on 2023/7/12.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeUserBokeListController: BaseTableViewController,JXPagerViewListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    @objc public var scrollCallback :((_ scrollView :UIScrollView) ->Void)?
    @objc public var userid : String?
    @objc public var isOhter = false
    @objc public var pageNo = 1
    public var collectionView : UICollectionView?
    var isDwon = true
    var danmuArr = [NoticeDanMuModel]()
    @objc public var stopPlayMusicBlock :((_ stop :Bool) ->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.tableView .removeFromSuperview()
        let layout = HQCollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-50-NoticeSwiftFile.TABBARHEIGHT()), collectionViewLayout: layout)
        if self.isOhter{
            self.collectionView?.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-50-NoticeSwiftFile.TABBARHEIGHT())
        }else{
            self.collectionView?.frame = CGRect(x: 0, y: 0, width: NoticeSwiftFile.screenWidth, height: NoticeSwiftFile.screenHeight-NoticeSwiftFile.NAVHEIGHT()-50)
        }
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
       
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.register(NoticeBokeMainCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.collectionView!)

        let header = MJRefreshNormalHeader {
            self.isDwon = true
            self.pageNo = 1
            self.request()
        }
        let footer = MJRefreshBackNormalFooter {
            self.isDwon = false
            self.pageNo += 1
            self.request()
        }
        self.collectionView?.mj_header = header
        self.collectionView?.mj_footer = footer;
        self.collectionView?.mj_header.beginRefreshing()
    }
    
    func request(){
        let url = String(format: "user/podcast/%@?pageNo=%ld", self.userid!,self.pageNo)
  
        DRNetWorking.shareInstance()?.requestNoNeedLogin(withPath: url, accept: "application/vnd.shengxi.v5.5.3+json", isPost: false, parmaer: nil, page: 0, success: { [weak self] (dict, success) in
            self?.collectionView?.mj_header.endRefreshing()
            self?.collectionView?.mj_footer.endRefreshing()
            if success {
                let nsDict = dict! as NSDictionary
                guard (nsDict["data"] as? [NSDictionary]) != nil else {
                    return
                }
                
                if (self?.isDwon)! {
                    self?.isDwon = false
                    self?.danmuArr.removeAll()
                }

                for dic in nsDict["data"] as! NSArray{
                    let model = NoticeDanMuModel.mj_object(withKeyValues: dic)
                    self?.danmuArr.append(model!)
                }
                
                
                self?.collectionView?.reloadData()
            }
        }, fail: {[weak self] (error) in
            self?.collectionView?.mj_header.endRefreshing()
            self?.collectionView?.mj_footer.endRefreshing()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.stopPlayMusicBlock?(true)
        let bokeM = self.danmuArr[indexPath.row]
        let ctl = NoticeDanMuController()
        ctl.bokeModel = bokeM
        self.navigationController?.pushViewController(ctl, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.danmuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoticeBokeMainCell
        cell.model = self.danmuArr[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (NoticeSwiftFile.screenWidth-15)/2, height: 81+(NoticeSwiftFile.screenWidth-15)/2*111/180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func listView() -> UIView! {
       return self.view
    }
    
    func listScrollView() -> UIScrollView! {
        return self.collectionView
    }
    
    func listViewDidScrollCallback(_ callback: ((UIScrollView?) -> Void)!) {
        self.scrollCallback = callback
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollCallback?(scrollView)
    }

}
