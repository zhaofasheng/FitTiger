//
//  NoticeSendBoKeController.h
//  NoticeXi
//
//  Created by li lei on 2022/9/21.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceSaveModel.h"
#import "NoticeDanMuModel.h"
#import "NoticeManagerJuBaoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendBoKeController : BaseTableViewController
@property (nonatomic, copy) void(^refreshDataBlock)(BOOL refresh);
@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isJuBao;
@property (nonatomic, assign) BOOL isCheckReSend;
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) NoticeManagerJuBaoModel *jubModel;
@end

NS_ASSUME_NONNULL_END
