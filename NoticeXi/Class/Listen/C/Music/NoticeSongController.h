//
//  NoticeSongController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSongController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isNew;
@end

NS_ASSUME_NONNULL_END
