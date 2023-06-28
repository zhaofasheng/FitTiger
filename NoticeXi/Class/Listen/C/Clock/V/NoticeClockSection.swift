//
//  NoticeClockSection.swift
//  NoticeXi
//
//  Created by li lei on 2019/10/23.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeClockSection: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = NoticeOcToSwift.getBackColor()
        
        let markL = UILabel.init(frame: CGRect(x: 15, y: 15, width: 300, height: 13))
        markL.font = UIFont.systemFont(ofSize: 13)
        markL.textColor = NoticeOcToSwift.getMainTextColor()
        markL.text = NoticeTools.isSimpleLau() ? "曾经下载过的配音：" : "曾經下載過的配音："
        self.addSubview(markL)
        
        let line = UIView.init(frame: CGRect(x: 0, y: 27+15, width: NoticeSwiftFile.screenWidth, height: 1))
        line.backgroundColor = NoticeOcToSwift.getlineColor()
        self.addSubview(line)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
