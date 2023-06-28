//
//  NoticeSendView.h
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChatRecordView.h"

@protocol NoticeSendDelegate <NSObject>

@optional
- (void)sendImageView;
- (void)onStartRecording;
- (void)onStopRecording;
- (void)onCancelRecording;
- (void)sendTime:(NSInteger)time path:(NSString *_Nullable)path;
- (void)sendDefault;
- (void)sendTextDelegate;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendView : UIView<NoticeSendMessageClickDelegate,NoticeRecordDelegate,UITextFieldDelegate>
@property (nonatomic, weak) id <NoticeSendDelegate>delegate;
@property (nonatomic, strong) UIButton    *recordButton;
@property (nonatomic, assign) NoticeAudioRecordPhase recordPhase;
@property (nonatomic, strong) NoticeChatRecordView *recodeView;
@property (nonatomic, strong) NSString *localAACUrl; //aac地址
@property (nonatomic, strong) LGVoiceRecorder *recorder;
@property (nonatomic, assign) NSUInteger audioTimeLen;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL canSend;
@property (nonatomic, copy) void (^overGuidelock)(BOOL isGiveUp);
@property (nonatomic, assign) BOOL isHs;
@property (nonatomic, assign) BOOL needHelp;
@property (nonatomic, strong) UIButton *vipButton;
@property (nonatomic, strong) UIButton *badButton;
@property (nonatomic, strong) NSString *userFlag;
@property (nonatomic, strong,nullable) NSTimer *recordTimer; //录音定时器
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *carmBtn;
@property (nonatomic, strong) UIButton *httpBtn;
@property (nonatomic, strong) UIButton *whiteBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIImageView *choiceImgV;
- (instancetype)initWithisHs:(BOOL)ishs;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
