//
//  NoticeVoiceViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isNeedGoRoot;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic, strong) NoticeAbout *aboutM;
@property (nonatomic, assign) BOOL isDate;
@property (nonatomic, assign) BOOL isTietie;
@property (nonatomic, strong) NSString *dateName;
@property (nonatomic, strong) NSString *navName;
@property (nonatomic, copy) void (^hasDataBlock)(BOOL hasData);
@end

NS_ASSUME_NONNULL_END
