//
//  NoticePyComController.h
//  NoticeXi
//
//  Created by li lei on 2020/11/24.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeBBSComent.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePyComController : NoticeBaseListController
@property (nonatomic, strong) NoticeClockPyModel *pyMOdel;
@property (nonatomic, strong) NSString *pyId;
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) NoticeBBSComent *jubaoComM;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL noBecomFirst;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic,copy) void (^deletePyBlock)(NoticeClockPyModel *pyModel);
@property (nonatomic, assign) BOOL isPicker;//声昔君picker
@end

NS_ASSUME_NONNULL_END
