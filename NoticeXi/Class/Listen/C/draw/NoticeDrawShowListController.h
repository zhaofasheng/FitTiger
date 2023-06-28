//
//  NoticeDrawShowListController.h
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDrawShowListController : BaseTableViewController
@property (nonatomic, assign) NSInteger listType;//0 今日推荐，1热门，2实时，3我的作品，4，收藏,5,别人的作品,6作品单页,7有人喜欢了你的画
@property (nonatomic,copy) void (^setHotBlock)(BOOL goHot);
@property (nonatomic,copy) void (^setNowBlock)(BOOL goNow);
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSString *artId;
@property (nonatomic, assign) BOOL isFromCenter;
@property (nonatomic, assign) BOOL isPicker;
@property (nonatomic, assign) BOOL isShowSend;

@property (nonatomic, assign) BOOL isFromMyDraw;
@end

NS_ASSUME_NONNULL_END
