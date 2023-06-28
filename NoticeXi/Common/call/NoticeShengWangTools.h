//
//  NoticeShengWangTools.h
//  NoticeXi
//
//  Created by li lei on 2021/10/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeCallVoiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShengWangTools : UIView
// 定义 agoraKit 变量

@property (nonatomic, strong) UIImageView *contentView;

- (void)show;

//加入频道
- (void)joinCancel:(NSString *)channelName token:(NSString *)token uid:(NSInteger)uid;

//离开频道
- (void)leaveChannel;

//是否处于流星语匹配时间
- (NSInteger)getOutDateDifference;

@property (nonatomic, assign) NSInteger waitTime;
@property (nonatomic, strong) NoticeCallVoiceModel *callModel;
@property (nonatomic, assign) BOOL noJoin;
@property (nonatomic, assign) BOOL isOut;
@property (nonatomic, assign) BOOL cannotClick;
@property (nonatomic, assign) NSInteger status;//0 没点击匹配，1.匹配中  2.点击了匹配后的匹配中 3.匹配成功，聊天中
@property (nonatomic, assign) NSInteger chatTime;
@property (nonatomic, strong) UIButton *callButton;

@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, strong) NSTimer *outTimer;
@property (nonatomic, strong) NSString *timestr;
@property (nonatomic, strong) NSString *outTimestr;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, assign) NSInteger outTime;//剩余匹配时间
@property (nonatomic, strong) CAEmitterLayer *colorBallLayer;
@property (nonatomic, strong) UIView *iconView;
@property (nonatomic, strong) UIView *anView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *jubaoBtn;
@end

NS_ASSUME_NONNULL_END
