//
//  NoticeTimeFunView.h
//  NoticeXi
//
//  Created by li lei on 2019/5/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFireworksButton.h"
#import "NoticeVoiceListModel.h"
#import "NoticeRecoderView.h"
#import "FSCustomButton.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeFunTimeListDelegate <NSObject>

@optional
- (void)timeListHasClickReplyDelegate;
- (void)timeListHasClickReplySuccessDelegate;
- (void)hasClickShareToWorld;
- (void)needStopBecauseLy;
- (void)needStopBecauseHS;
@end

@interface NoticeTimeFunView : UIView<NoticeRecordDelegate>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *listenL;

@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIButton *selfButton;//给自己留言
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, strong) MCFireworksButton *imageView1;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic,copy) void (^refreshBlock)(BOOL noNeedRefresh);

@property (nonatomic, weak) id<NoticeFunTimeListDelegate>delegate;

- (void)likeAndShareTap;
@end

NS_ASSUME_NONNULL_END
