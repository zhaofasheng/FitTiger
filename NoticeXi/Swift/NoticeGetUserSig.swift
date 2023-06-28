//
//  NoticeGetUserSig.swift
//  NoticeXi
//
//  Created by li lei on 2023/3/22.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

import UIKit

class NoticeGetUserSig: NSObject {

    @objc public func getTencentUserSig(identifier: String) -> String {
        return GenerateTestUserSig.genTestUserSig(identifier: identifier)
    }
}
