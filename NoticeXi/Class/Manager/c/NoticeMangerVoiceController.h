//
//  NoticeMangerVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeManagerModel.h"
#import "NoticeGroupChatModel.h"
#import "NoticeManagerJuBaoModel.h"
#import "NoticeDanMuListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMangerVoiceController : BaseTableViewController
@property (nonatomic, assign) BOOL isNoChat;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, assign) BOOL isFRomCenter;
@property (nonatomic, strong) NoticeManagerModel *managerM;
@property (nonatomic, strong) NoticeGroupChatModel *groupM;
@property (nonatomic, strong) NoticeManagerJuBaoModel *juModel;
@property (nonatomic, strong) NoticeDanMuListModel *danmMu;
@end

NS_ASSUME_NONNULL_END
