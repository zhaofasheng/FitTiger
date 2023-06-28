//
//  NoticeBackVoiceViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceListCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBackVoiceViewController : BaseTableViewController
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, assign) BOOL needRequest;
@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) NSString *voiceId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *voiceUserId;
@end

NS_ASSUME_NONNULL_END
