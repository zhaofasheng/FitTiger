//
//  NoticeBookViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBookViewController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isNew;
@end

NS_ASSUME_NONNULL_END
