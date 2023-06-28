//
//  NoticeOrderComDetailController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeShopChatCommentCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderComDetailController : NoticeBaseListController
@property (nonatomic, assign) BOOL needDelete;//删除按钮
@property (nonatomic, assign) BOOL isFromCom;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *orderName;
@property (nonatomic, strong) NSString *goodsUrl;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *second;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, copy) void(^hasDeleteComBlock)(NSString *orderId);
@end

NS_ASSUME_NONNULL_END
