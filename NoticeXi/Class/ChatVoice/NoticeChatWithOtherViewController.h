//
//  NoticeChatWithOtherViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatWithOtherViewController : BaseTableViewController
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *identType;
@property (nonatomic, strong) NSString *voiceUserId;
@property (nonatomic, assign) BOOL noVoiceM;
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic, assign) BOOL noNeedGetVoiceM;
@property (nonatomic, strong) NSString *toUserName;
@end

NS_ASSUME_NONNULL_END
