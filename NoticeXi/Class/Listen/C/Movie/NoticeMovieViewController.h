//
//  NoticeMovieViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMovieViewController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isNew;
@end

NS_ASSUME_NONNULL_END
