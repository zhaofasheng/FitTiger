//
//  NoticeHelpDetailController.h
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeHelpListModel.h"
#import "NoticeHelpCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeHelpListModel *helpModel;
@property (nonatomic, copy)  void (^deleteSuccess)(NSString *tieId);
@property (nonatomic, assign) BOOL isFromPush;
@property (nonatomic, assign) BOOL needDetail;
@property (nonatomic, assign) BOOL isJubaoCom;
@property (nonatomic, strong) NoticeHelpCommentModel *comModel;

@property (nonatomic, copy) void (^noLikeBlock)(NoticeHelpListModel *helpM);
@end

NS_ASSUME_NONNULL_END
