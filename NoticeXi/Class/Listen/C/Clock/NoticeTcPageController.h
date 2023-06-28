//
//  NoticeTcPageController.h
//  NoticeXi
//
//  Created by li lei on 2019/11/8.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTcPageController : NoticeBaseListController
@property (nonatomic, strong) NSDictionary *tcDic;
@property (nonatomic, strong) NoticeClockPyModel *tcModel;
@property (nonatomic, strong) NoticeUserInfoModel *tcSendUser;
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NSString *tcId;
@property (nonatomic, assign) BOOL hasSelfPy;

@property (nonatomic, assign) BOOL isFromMessageVC;//来自于互动消息的跳转
@end

NS_ASSUME_NONNULL_END
