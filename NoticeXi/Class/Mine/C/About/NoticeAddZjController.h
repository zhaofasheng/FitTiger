//
//  NoticeAddZjController.h
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddZjController : NoticeBaseListController
@property (nonatomic, assign) BOOL isEditAblum;
@property (nonatomic, assign) BOOL isDiaAblum;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, strong) NSString *voiceId;
@property (nonatomic, strong) NSString *dialogId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NoticeZjModel *zjmodel;
@property (nonatomic,copy) void (^editSuccessBlock)(NoticeZjModel *zjmodel);
@property (nonatomic,copy) void (^deleteSuccessBlock)(NoticeZjModel *zjmodel);
@end

NS_ASSUME_NONNULL_END
