//
//  NoticeSCListViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSCListViewController : NoticeBaseListController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) NSInteger numMessage;
- (void)refreshNoUnread;
@end

NS_ASSUME_NONNULL_END
