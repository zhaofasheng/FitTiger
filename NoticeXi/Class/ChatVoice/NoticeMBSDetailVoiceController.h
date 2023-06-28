//
//  NoticeMBSDetailVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeStaySys.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMBSDetailVoiceController : BaseTableViewController
@property (nonatomic, assign) BOOL isHs;
@property (nonatomic, assign) BOOL isSelfHs;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) BOOL noPushToUserCenter;
@property (nonatomic, assign) BOOL isSelfHsBG;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic,copy) void (^deleteSuccessBlock)(NoticeVoiceListModel *deleteM);
@property (nonatomic,copy) void (^replySuccessBlock)(NSString *dilaNum);
@property (nonatomic,copy) void (^reEditBlock)(NoticeVoiceListModel *voiceM);
@property (nonatomic, strong) NSString * __nullable toUserName;
@property (nonatomic, strong) NoticeStaySys *stayChat;
@end

NS_ASSUME_NONNULL_END
