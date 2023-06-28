//
//  NoticeSeasonViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSeasonViewController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isLimt;
@property (nonatomic, assign) BOOL isDuihua;
@property (nonatomic, assign) BOOL isNoShowSimi;//是否展示私密
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isUserCenter;
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
