//
//  NoticeJoinTextAlbumController.h
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJoinTextAlbumController : BaseTableViewController
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
