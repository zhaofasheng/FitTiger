//
//  NoticeMBSViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMBSViewController : BaseTableViewController
@property (nonatomic, strong) NSMutableDictionary *setDic;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, assign) BOOL isTopic;
@property (nonatomic, assign) BOOL isAch;
@property (nonatomic, assign) BOOL isTab;
@property (nonatomic, assign) BOOL isShowAch;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isPy;
@property (nonatomic, assign) BOOL isDraw;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pyType;
@property (nonatomic,copy) void (^openBlock)(BOOL open);
@property (nonatomic,copy) void (^pyBlock)(NSInteger pySet);
@property (nonatomic, strong) NSString *setName;
@end

NS_ASSUME_NONNULL_END
