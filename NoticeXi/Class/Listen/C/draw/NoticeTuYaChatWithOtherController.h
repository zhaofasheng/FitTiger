//
//  NoticeTuYaChatWithOtherController.h
//  NoticeXi
//
//  Created by li lei on 2020/6/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeDrawList.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTuYaChatWithOtherController : BaseTableViewController
@property (nonatomic, strong) NoticeDrawList *curentDraw;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *drawId;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, assign) BOOL fromManager;
@property (nonatomic, assign) BOOL fromNomerl;
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, copy)  void(^backBlock)(BOOL back);
@end

NS_ASSUME_NONNULL_END
