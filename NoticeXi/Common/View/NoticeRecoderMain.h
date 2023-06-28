//
//  NoticeRecoderMain.h
//  NoticeXi
//
//  Created by li lei on 2019/11/29.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
#import "NoticeChoiceRecoderView.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum NoticeRecoderType {
    NoticeRecoderDefault  = 0,//其他地方点击
    NoticeRecoderTabbar,//tababr点击
    NoticeRecoderTime,//时光机点击
    NoticeRecoderSong,//唱歌点击
    NoticeRecoderTopic,//其他地方点击
    NoticeRecoderUserCenter,//心情簿点击
    NoticeRecoderMBS,//其他地方点击
} NoticeRecoderType;

@interface NoticeRecoderMain : UIView
@property (nonatomic, assign) NoticeRecoderType type;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *recodImageView;
@property (nonatomic, assign) NSInteger maxTime;
@property (nonatomic, assign) BOOL noNeedBanner;//是否需要显示banner
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic, assign) BOOL isLongTime;//是否是录制长语音
@property (nonatomic, assign) BOOL isFromMain;
@property (nonatomic, strong) LGVoiceRecorder *recorder;
@property (nonatomic, strong) NSTimer *recordTimer; //录音定时器
@property (nonatomic, assign) NSUInteger audioTimeLen;
@property (nonatomic, strong) NSString *localAACUrl; //aac地址
@property (nonatomic, assign) NSInteger currentRecodTime;

@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) NSString *zjId;//判断是否存在专辑id
- (instancetype)initWithImageView:(NSString *)imgName type:(NoticeRecoderType)recoderType;

- (void)startRecoder;
@end

NS_ASSUME_NONNULL_END
