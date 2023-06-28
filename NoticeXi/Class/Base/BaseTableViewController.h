//
//  BaseTableViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTitleAndImageCell.h"
#import "NoticeClickVoiceMore.h"
#import <MJRefresh.h>
#import "AppDelegate.h"
#import "NoticeNoDataView.h"
#import "UIImage+Color.h"
#import "NoticeCustumeNavView.h"
#import "NoticeCustumBackImageView.h"
#import "NoticeNoNetWorkView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeTableViewScrollContentSet <NSObject>

@optional
- (void)tableViewScrollViewContentSet:(CGFloat)offSet isUp:(BOOL)isUp;

@end

@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NoticeVoiceClickMoreSuccess,NoticeAssestDelegate>

@property (nonatomic, weak) id <NoticeTableViewScrollContentSet>delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) LCActionSheet *priSheet;
@property (nonatomic, assign) BOOL noNav;
@property (nonatomic, assign) BOOL canReoadData;//可以刷新音频播放数据
@property (nonatomic, assign) BOOL isPlayFromFirst;//从头开始播放
@property (nonatomic, strong) NoticeNoNetWorkView *noNetWorkView;//无网络提示
@property (nonatomic, assign) BOOL needPasue;
@property (nonatomic, assign) BOOL noNeedReceComment;
@property (nonatomic, assign) NSInteger choicemoreTag;
@property (nonatomic, assign) NSInteger lastPlayerTag;
@property (nonatomic, assign) CGFloat draFlot;
@property (nonatomic, assign) CGFloat progross;
@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoticeClickVoiceMore *clickMore;//心情点击更多工具
@property (nonatomic, strong) NoticeFloatView *floatView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL canActionForAssest;//判断是否可以执行信息流助手方法
@property (nonatomic, assign) BOOL canShowAssest;
@property (nonatomic, assign) BOOL isSection;//判断cell是放在row还是section
@property (nonatomic, assign) BOOL isAutoPlayer;//判断cell是放在row还是section
@property (nonatomic, assign) BOOL isPushMoreToPlayer;//判断是否是自动拉取更多去播放
@property (nonatomic, assign) BOOL isrefreshNewToPlayer;//刷新数据的时候停止自动往下播放
@property (nonatomic, assign) BOOL stopAutoPlayerForDissapear;//刷新数据的时候停止自动往下播放
@property (nonatomic, assign) BOOL needBackGroundView;//是否需要背景图(导航栏会自动透明)
@property (nonatomic, assign) BOOL needHideNavBar;//是否需要隐藏导航栏
@property (nonatomic, strong) NoticeNoDataView *queshenView;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@property (nonatomic, assign) CGFloat effect;
@property (nonatomic, assign) BOOL canNotLoadNewData;//重复点击执行当中
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) UIVisualEffectView * effectView;
//- (void)refreshFloatButton:(BOOL)isPlaying;
- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing;
- (void)iconTapAssest;
//- (void)nextForAssest;
//- (void)proForAssest;
//- (void)autoOrNoAutoForAssest;
//- (void)backToTopForAssest;
//- (void)showAssestView;
- (void)reSetPlayerData;
- (void)reStopPlay;
- (void)addPlayNum:(NoticeVoiceListModel *)model;
- (void)changeSkin;
@end

NS_ASSUME_NONNULL_END
