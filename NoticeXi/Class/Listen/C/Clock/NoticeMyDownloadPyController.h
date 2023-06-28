//
//  NoticeMyDownloadPyController.h
//  NoticeXi
//
//  Created by li lei on 2020/4/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyDownloadPyController : BaseTableViewController
@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, assign) NSInteger tcTagType;
@property (nonatomic,copy) void (^setHotBlock)(BOOL goHot);
@property (nonatomic,copy) void (^setTcBlock)(BOOL goTc);
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isUserPy;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isUserCenter;
@property (nonatomic, assign) BOOL isFromNowForSelf;
@property (nonatomic, assign) BOOL isFromUserCenter;
@property (nonatomic, assign) BOOL needBackGround;
@property (nonatomic, assign) BOOL isOrderByHot;
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
