//
//  NoticeUseOrDeleteBBSController.h
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBBSDetailHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUseOrDeleteBBSController : BaseTableViewController
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@property (nonatomic,copy) void (^managerTypeBlock)(NSInteger type,NSString *postId);//1采纳，2删除
@end

NS_ASSUME_NONNULL_END
