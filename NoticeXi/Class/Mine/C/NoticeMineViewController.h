//
//  NoticeMineViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceChoiceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMineViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isFromOther;
@property (nonatomic, assign) BOOL needRefreshList;
@property (nonatomic, copy) void(^hasRedViewBlock)(BOOL showRed);
@end

NS_ASSUME_NONNULL_END
