//
//  NoticeSendBBSController.h
//  NoticeXi
//
//  Created by li lei on 2020/11/5.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendBBSController : UIViewController
@property (nonatomic, strong) NSString *manageCode;
@property (nonatomic, strong) NoticeBBSModel *bbsM;
@property (nonatomic, assign) BOOL isFromCaiNa;//采纳过来的要先投稿成贴子然后再进行编辑
@property (nonatomic,copy) void (^managerTypeBlock)(NSInteger type,NSString *postId);//1采纳，2删除
@end

NS_ASSUME_NONNULL_END
