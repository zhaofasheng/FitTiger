//
//  NoticeImageViewController.h
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeImageViewController : BaseTableViewController
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NoticeBannerModel *bannerM;
@property (nonatomic, assign) BOOL isReadEveryDay;//每日一阅
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, assign) BOOL ismessage;
@end

NS_ASSUME_NONNULL_END
