//
//  NoticeBBSDetailController.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeBBSModel.h"
#import "NoticeBBSComent.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@property (nonatomic, assign) BOOL isPostDetail;//判断是否是来自帖子进入的详情，帖子id一样
@property (nonatomic, assign) BOOL needRequestDetail;
@property (nonatomic, strong) NSString *posiId;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *manageCode;
@property (nonatomic, assign) BOOL isFromJUBAO;
@property (nonatomic, strong) NoticeBBSComent *commentM;
@property (nonatomic, assign) BOOL roadAll;
@property (nonatomic, strong) NSString *pointComId;
@end

NS_ASSUME_NONNULL_END
