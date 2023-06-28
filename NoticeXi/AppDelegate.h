//
//  AppDelegate.h
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAudioPlayer.h"
#import "NoiticePlayerView.h"
#import "NoticeSocketManger.h"
#import "NoticeFloatView.h"
#import "STRIAPManager.h"
#import "NoticeAudioChatTools.h" 
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) NoticeSocketManger *socketManager;
@property (nonatomic, strong) NoticeAudioChatTools *audioChatTools;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoiticePlayerView *currentPlayer;
@property (nonatomic, assign) BOOL needStop;
@property (nonatomic, assign) BOOL noNeedStop;
@property (nonatomic, assign) BOOL hasShowCallView;
@property (nonatomic, assign) BOOL isInShopChat;
@property (nonatomic, assign) BOOL canRefresDialNum;//判断是否可以刷新对话数量
@property (nonatomic, assign) BOOL needQuickRecorder;
@property (nonatomic, assign) BOOL needLeaderPage;
@property (nonatomic, assign) BOOL sendVoice;
@property (nonatomic, assign) BOOL isdownLoading;
@property (nonatomic, assign) BOOL isPlayingNoticeVice;
@property (nonatomic, assign) BOOL hasMoveFloatView;
@property (nonatomic, assign) BOOL isConnected;
@property (nonatomic, assign) BOOL isBusyForCalling;
@property (nonatomic, assign) BOOL floatViewIsOut;
@property (nonatomic, assign) BOOL isINCallPage;
@property (nonatomic, assign) BOOL noPop;
@property (nonatomic) CGPoint floatPoint;
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) UInt64 currentCallId;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) STRIAPManager *payManager;
@property (nonatomic, assign) BOOL hasYuancheng;
@property (nonatomic,copy) void (^backPlayBlock)(BOOL play);
@property (nonatomic,copy) void (^backnextBlock)(BOOL next);
@property (nonatomic,copy) void (^backpreBlock)(BOOL pre);
@property (nonatomic, assign) CGFloat effect;
@property (nonatomic, assign) CGFloat alphaValue;
@property (nonatomic, strong) NSString *appdefaultvideo;
@property (nonatomic, strong) NSString *currentGudeId;
@property (nonatomic, strong) UIImage *custumeImg;
@property (nonatomic, strong) UIImage *backImg;
@property (nonatomic, strong) UIImage *backDefaultImg;

//以下方法为播放心情时候信息流助手所用方法
@property (nonatomic, strong) NoticeFloatView *floatView;
@end

