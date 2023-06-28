//
//  NoticeRecoderView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGVoiceRecorder.h"
#import "QQTagView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeRecordDelegate <NSObject>
@optional
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength;
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength musiceId:(NSString *)musicId;
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength atArr:(NSMutableArray *)atArr;
- (void)recoderSureWithPathWithNoClick:(NSString *)locaPath time:(NSString *)timeLength;
- (void)deleteVoice;
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength isNiMing:(BOOL)isNiming;
- (void)longTapToSendText;
- (void)hideRecoderView;
- (void)reRecoderLocalVoice;
- (void)giveUpRecoderIng:(BOOL)isClear;
@end
@interface NoticeRecoderView : UIView<QQTagViewDelegate>

@property (nonatomic, weak) id<NoticeRecordDelegate>delegate;

@property (nonatomic, strong) UIView *functionView;
- (instancetype)shareRecoderViewWithSong:(BOOL)isSong;
- (instancetype)shareRecoderViewWithPeiYing:(NSString *)content;
- (instancetype)shareRecoderViewWith:(NSString *)title;
- (instancetype)shareRecoderViewWithNoclean;
//判断是否来自开屏页面
- (instancetype)shareRecoderViewWithStartRecod:(LGVoiceRecorder*)recoder;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) NSUInteger audioTimeLen;
@property (nonatomic, strong) LGVoiceRecorder *recorder;
@property (nonatomic, assign) BOOL needCancel;
@property (nonatomic, assign) BOOL hideCancel;
@property (nonatomic, assign) BOOL sayToSelf;
@property (nonatomic, assign) BOOL quickLook;
@property (nonatomic, assign) BOOL isFromMain;
@property (nonatomic, assign) BOOL neeAutoRecoder;//需要随机播放bgm
@property (nonatomic, assign) BOOL isUseMeesage;
@property (nonatomic, assign) BOOL needLongTap;//是否需要长按打字
@property (nonatomic, assign) NSInteger timeLength;
@property (nonatomic, assign) NSInteger pyTag;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) UIView *groupBtnView;
@property (nonatomic, assign) BOOL isReply;//是否是回复
@property (nonatomic, assign) BOOL isHS;//是否是悄悄话
@property (nonatomic, assign) BOOL isPy;//是否是配音
@property (nonatomic, assign) BOOL isSayToSelf;//给自己留言
@property (nonatomic, strong) NSString *adressUrl;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isCheers;
@property (nonatomic, assign) BOOL noReplay;//是否需要循环播放
@property (nonatomic, assign) BOOL isHasAdress;//是否已经存在地址
@property (nonatomic, assign) BOOL needLookPhoto;
@property (nonatomic, assign) BOOL isSendTextMBS;//是否是长按发送留言资源
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, assign) BOOL startRecdingNeed;
@property (nonatomic, assign) BOOL noPushLeade;
@property (nonatomic, assign) BOOL isSong;//是否是唱回忆
@property (nonatomic, assign) BOOL isLongTime;//是否是录制长语音
@property (nonatomic, assign) BOOL isDb;//是否是录制声昔独白
@property (nonatomic, assign) BOOL isShort;//是否语音拆成小段
@property (nonatomic, assign) BOOL isLong;//单条常语音
@property (nonatomic, assign) BOOL isRgister;//注册页
@property (nonatomic, assign) BOOL isE;//注册页
@property (nonatomic, assign) BOOL isGroupChatAt;//社团聊天语音需要艾特功能
@property (nonatomic, strong) NSMutableArray *memberArr;
@property (nonatomic, strong) NSString *chatTips;//聊天原则
@property (nonatomic, copy) void (^sendBlock)(NSString *url, NSString *buckId);
@property (nonatomic, copy) void (^overGuidelock)(BOOL isGiveUp);
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong) NSMutableArray *assestArr;
@property (nonatomic, strong) NSMutableArray *assestImageArr;

@property (nonatomic, strong) NSString *iconUrl;
@property(nonatomic, strong) QQTagView *HeaderView;
@property (nonatomic, strong) NSMutableArray *atArr;

@property (nonatomic, strong) UIImageView *clickRecoImageView;
@property (nonatomic, strong) UIImageView *clickFinishImageView;

- (void)canDismiss;
- (void)canDismissWithNoClear;
- (void)show;
@end

NS_ASSUME_NONNULL_END
