//
//  NoticeChangeIntroduceViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeIntroduceViewController : NoticeBaseListController
@property (nonatomic, strong) NSString *induce;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isFromReg;
@end

NS_ASSUME_NONNULL_END
