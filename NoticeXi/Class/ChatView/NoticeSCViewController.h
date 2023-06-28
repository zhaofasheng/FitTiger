//
//  NoticeSCViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeChatToKfController.h"
#import "NoticeChangeRecoderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSCViewController : BaseTableViewController
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *identType;
@property (nonatomic, strong) NSString *lelve;
@property (nonatomic, assign) BOOL isKeFu;
@property (nonatomic, assign) BOOL isNeedHelp;
@property (nonatomic, assign) BOOL isHS;
@property (nonatomic, strong) NoticeChangeRecoderModel *recoModel;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) NSString *chatDetailId;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
