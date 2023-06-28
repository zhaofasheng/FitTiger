//
//  NoticeWorldVoiceListViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeHeaderDataView.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWorldVoiceListViewController : BaseTableViewController<NoticeAssestDelegate,JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isSpec;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, assign) BOOL isPager;
@property (nonatomic, assign) BOOL isTestGround;//文字广场
@property (nonatomic, assign) BOOL isHotLovePlan;//温暖计划
@property (nonatomic, assign) BOOL isHotLovePlanMark;//温暖计划
@property (nonatomic, assign) BOOL isVoice;//语音心情
@property (nonatomic, assign) BOOL isSame;//同频域
@property (nonatomic, assign) BOOL fromMain;//来自于主页
@property (nonatomic,copy) void (^playStatusBlock)(BOOL isPlaying);
@property (nonatomic, strong) NSString *passWd;
@property (nonatomic, strong) NoticeHeaderDataView *dataView;
@end

NS_ASSUME_NONNULL_END
