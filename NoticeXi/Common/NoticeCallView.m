//
//  NoticeCallView.m
//  NoticeXi
//
//  Created by li lei on 2023/3/24.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCallView.h"
#import "TUICore.h"
#import "TUICallKit.h"
#import "TUILogin.h"
#import <ImSDK_Plus/ImSDK_Plus.h>
#import "TUICallKitGCDTimer.h"
#import "TUICallingAction.h"
#import "TUICallingStatusManager.h"
#import "NoticeXi-Swift.h"
#import "NoticeShopJubaoView.h"
#import "NoticeShopjuBuView.h"
#import "NoticeTimerTools.h"
@interface NoticeCallView()

@property (nonatomic, strong) StarsOverlay *starsView;
@property (nonatomic, strong) NSMutableDictionary *parm;
@end

@implementation NoticeCallView
{
    UIView *_volumeView;
    UIView *_userVolumeView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        imageView.image = UIImageNamed(@"calling_backimg");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        self.starsView = [[StarsOverlay alloc] initWithFrame:imageView.bounds];
        [imageView addSubview:self.starsView];
        
        
        self.endButton = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-32)/2, 60, 32)];
        self.endButton.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.endButton.layer.cornerRadius = 16;
        self.endButton.layer.masksToBounds = YES;
        self.endButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.endButton setTitle:@"结束" forState:UIControlStateNormal];
        [self.endButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self addSubview:self.endButton];
        [self.endButton addTarget:self action:@selector(endCall) forControlEvents:UIControlEventTouchUpInside];
        
        self.muteButton = [[FSCustomButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-212)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-30-82, 56, 82)];
        [self.muteButton setImage:UIImageNamed(@"tencent_openmuteimg") forState:UIControlStateNormal];//tencent_closemuteimg
        [self.muteButton setTitle:@"关麦" forState:UIControlStateNormal];
        self.muteButton.buttonImagePosition = FSCustomButtonImagePositionTop;
        [self.muteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.muteButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.muteButton addTarget:self action:@selector(mutClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.muteButton];
        
        self.mirButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.muteButton.frame)+100, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-30-82, 56, 82)];
        [self.mirButton setImage:UIImageNamed(@"tencent_openmirimg") forState:UIControlStateNormal];//tencent_closemirimg
        [self.mirButton setTitle:@"扩音" forState:UIControlStateNormal];
        self.mirButton.buttonImagePosition = FSCustomButtonImagePositionTop;
        [self.mirButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mirButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.mirButton addTarget:self action:@selector(mirClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mirButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMiseeShow) name:@"SHOPOVERCHATORDER" object:nil];
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errroOver) name:@"NEEDOVERVOICECHAT" object:nil];
        
        self.shopIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88*2-8)/2, NAVIGATION_BAR_HEIGHT+66, 88, 88)];
        self.shopIconImageView.layer.cornerRadius = 44;
        self.shopIconImageView.layer.masksToBounds = YES;
        self.shopIconImageView.userInteractionEnabled = YES;
        [self addSubview:self.shopIconImageView];
        self.shopIconImageView.image = UIImageNamed(@"call_iconshop");
        
        _volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, 88, 0)];
        _volumeView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.2];
        [self.shopIconImageView addSubview:_volumeView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopIconImageView.frame)-8, NAVIGATION_BAR_HEIGHT+66, 88, 88)];
        self.iconImageView.layer.cornerRadius = 44;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.userInteractionEnabled = YES;
        self.iconImageView.image = UIImageNamed(@"call_iconuser");
        [self addSubview:self.iconImageView];
        
        _userVolumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, 88, 0)];
        _userVolumeView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.2];
        [self.iconImageView addSubview:_userVolumeView];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.iconImageView.frame)+30, DR_SCREEN_WIDTH, 22)];
        self.markL.text = @"1鲸币/分钟 已通话";
        self.markL.textColor = [UIColor whiteColor];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.markL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.markL.frame)+6, DR_SCREEN_WIDTH, 22)];
        self.timeL.textColor = [UIColor whiteColor];
        self.timeL.font = XGTwentyEigthBoldFontSize;
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.text = @"00:00:00";
        [self addSubview:self.timeL];
        
        self.timeOutL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+10, DR_SCREEN_WIDTH, 22)];
        self.timeOutL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.timeOutL.font = FOURTHTEENTEXTFONTSIZE;
        self.timeOutL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeOutL];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, self.mirButton.frame.origin.y-156, DR_SCREEN_WIDTH-60, 106)];
        contentView.backgroundColor = [[UIColor colorWithHexString:@"#373451"] colorWithAlphaComponent:0.8];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        
        CGFloat height = GET_STRHEIGHT(@"·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理", 12, DR_SCREEN_WIDTH-90);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,(106-height)/2, DR_SCREEN_WIDTH-90, height)];
        label.font = TWOTEXTFONTSIZE;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithHexString:@"#CECCE1"];
        label.text = @"·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理";
        [contentView addSubview:label];
        self.noticeL = label;
        
        UILabel *jubaoL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-60, STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        jubaoL.text = @"举报";
        jubaoL.font = SIXTEENTEXTFONTSIZE;
        jubaoL.textColor = [UIColor whiteColor];
        jubaoL.textAlignment = NSTextAlignmentRight;
        jubaoL.userInteractionEnabled = YES;
        UITapGestureRecognizer *jubaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jubaoClick)];
        [jubaoL addGestureRecognizer:jubaoTap];
        [self addSubview:jubaoL];
    }
    return self;
}

- (void)setFromUserId:(NSString *)fromUserId{
    _fromUserId = fromUserId;
    if (!_fromUserId) {
        return;
    }
    if([_fromUserId isEqualToString:[NoticeTools getuserId]]){//如果来电者是自己的，那么自己是买家，否则自己是卖家
        self.endButton.hidden = NO;
    }else{
        self.endButton.hidden = YES;
    }
    DRLog(@"来电者%@  自己%@",fromUserId,[NoticeTools getuserId]);
}

- (void)setToUserId:(NSString *)toUserId{
    _toUserId = toUserId;
    if(!_toUserId){
        return;
    }
    if([_toUserId isEqualToString:[NoticeTools getuserId]]){//如果来电者是自己的，那么自己是买家，否则自己是卖家
        self.endButton.hidden = YES;
    }else{
        self.endButton.hidden = NO;
    }
    DRLog(@"打给%@ 自己%@",toUserId,[NoticeTools getuserId]);
}

- (void)jubaoClick{
    if(!self.roomId){
        return;
    }
    __weak typeof(self) weakSelf = self;
    if(self.fromUserId){//有来电者，说明自己是店主
        NoticeShopjuBuView *jubaoView = [[NoticeShopjuBuView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [jubaoView showJuBao];
        jubaoView.shopjubaoBlock = ^(NSInteger tag) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:weakSelf.roomId forKey:@"roomId"];
            [parm setObject:[NSString stringWithFormat:@"%ld",weakSelf.totalTime] forKey:@"second"];
            [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if(success){
                    DRLog(@"店主举报用户成功");
                    if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
                        [TUICallingAction hangup];
                    };
                    [weakSelf dissMiseeShow];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
                    [alerView showXLAlertView];
                }
            } fail:^(NSError * _Nullable error) {
            }];
   
        };
    }else{//没有来电者，有去电者，说明自己是买家
        if(self.toUserId){
            NoticeShopJubaoView *jubaoView = [[NoticeShopJubaoView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            [jubaoView showJuBao];
            jubaoView.shopjubaoBlock = ^(NSInteger tag) {
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:weakSelf.roomId forKey:@"roomId"];
                [parm setObject:[NSString stringWithFormat:@"%ld",weakSelf.totalTime] forKey:@"second"];
                [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if(success){
                        DRLog(@"用户举报店主成功");
                        if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
                            [TUICallingAction hangup];
                        };
                        [weakSelf dissMiseeShow];
                        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
                        [alerView showXLAlertView];
                    }
                } fail:^(NSError * _Nullable error) {
                }];
            };
        }
    }
}

- (void)setRoomId:(NSString *)roomId{
    _roomId = roomId;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/getOrder/%@",roomId] Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.chatInfoModel = [NoticeChatingInfoModel mj_objectWithKeyValues:dict[@"data"]];
            self.markL.text = [NSString stringWithFormat:@"%@鲸币/分钟 已通话",self.chatInfoModel.price];
            if (self.fromUserId) {//有来电者，说明自己是店主
                
            }else if(self.toUserId){//有去电者，说明自己是买家
                NSString *str = [NSString stringWithFormat:@"聊天时长最多%d分钟，超时自动结束通话\n\n·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理",(int)(self.chatInfoModel.second.intValue/60)];
                CGFloat height = GET_STRHEIGHT(str, 12, DR_SCREEN_WIDTH-90);
                self.noticeL.frame = CGRectMake(15,(106-height)/2, DR_SCREEN_WIDTH-90, height);
                self.noticeL.text = str;
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refreshStars{
    [self.starsView randomizeEmitterPosition];
}

- (void)setUserVolume:(CGFloat)userVolume{

    CGFloat height1 = userVolume * 0.88;
    _userVolumeView.frame = CGRectMake(0, 88-height1, 88, height1);
}

- (void)setShopVolume:(CGFloat)shopVolume{
    CGFloat height = shopVolume * 0.88;
    _volumeView.frame = CGRectMake(0, 88-height, 88, height);
}

//是否开扬声器
- (void)mirClick{
    self.isSpeaker = !self.isSpeaker;
    if(self.isSpeaker){
        [self.mirButton setImage:UIImageNamed(@"tencent_closemirimg") forState:UIControlStateNormal];//
        [self.mirButton setTitle:@"已扩音" forState:UIControlStateNormal];
    }else{
        [self.mirButton setImage:UIImageNamed(@"tencent_openmirimg") forState:UIControlStateNormal];//tencent_closemirimg
        [self.mirButton setTitle:@"扩音" forState:UIControlStateNormal];
    }
    [TUICallingAction selectAudioPlaybackDevice];
    
}

//是否关麦
- (void)mutClick{
    self.closeMicrophone = !self.closeMicrophone;
    if (self.closeMicrophone){
        [self.muteButton setImage:UIImageNamed(@"tencent_closemuteimg") forState:UIControlStateNormal];
        [self.muteButton setTitle:@"已关麦" forState:UIControlStateNormal];
        [TUICallingAction closeMicrophone];
    }else{
        [self.muteButton setImage:UIImageNamed(@"tencent_openmuteimg") forState:UIControlStateNormal];
        [self.muteButton setTitle:@"关麦" forState:UIControlStateNormal];
        [TUICallingAction openMicrophone];
    }
}

//结束通话
- (void)endCall{
    
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定结束通话吗？" message:nil sureBtn:@"再想想" cancleBtn:@"结束" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
                [TUICallingAction hangup];
            };
            [weakSelf dissMiseeShow];
        }
    };
    [alerView showXLAlertView];

}

- (void)showCallView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [rootWindow bringSubviewToFront:self];
    if(!self.timerName.length){
        [self startTimer];
    }
    if (self.fromUserId) {//如果有来电者，代表自己是店主，店主不需要挂断电话的按钮
     //   self.endButton.hidden = YES;
    }
    [self creatShowAnimation];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
 
    return format_time;
 
}

- (void)creatShowAnimation
{
    self.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dissMiseeShow{

    [NoticeTimerTools deleteTimer:self.timerName];
    self.timerName = nil;
    [self removeFromSuperview];

}

- (void)startTimer {
    self.totalTime = 0;
    NSTimeInterval interval = 1.0;
    __weak typeof(self) weakSelf = self;
    self.timerName = [NoticeTimerTools timerTask:^{
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.totalTime += (NSInteger)interval;
        strongSelf.timeL.text = [weakSelf getMMSSFromSS:[NSString stringWithFormat:@"%ld",strongSelf.totalTime]];
        
        if(weakSelf.roomId){
            [weakSelf.parm setObject:@"shopOrderRoom" forKey:@"flag"];
            [weakSelf.parm setObject:weakSelf.roomId forKey:@"roomId"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:weakSelf.parm];
        }
        
        if(weakSelf.chatInfoModel.second.intValue){
            if(weakSelf.fromUserId){//卖家
                if((weakSelf.chatInfoModel.second.intValue - strongSelf.totalTime) <= 30){
                    weakSelf.timeOutL.text = [NSString stringWithFormat:@"%lds后订单即将自动结束",weakSelf.chatInfoModel.second.intValue - strongSelf.totalTime];
                }
            }else if (weakSelf.toUserId){//买家
                if((weakSelf.chatInfoModel.second.intValue - strongSelf.totalTime) <= 30){
                    weakSelf.timeOutL.text = [NSString stringWithFormat:@"鲸币余额已不足，%lds后订单即将自动结束",weakSelf.chatInfoModel.second.intValue - strongSelf.totalTime];
                }
            }
            if((weakSelf.chatInfoModel.second.intValue - strongSelf.totalTime) <= 0){
                if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
                    DRLog(@"超时取消通话");
                    [TUICallingAction hangup];
                };
                [weakSelf dissMiseeShow];
            }
        }
    } start:0 interval:interval repeats:YES async:NO];
}

//双方都网络等原因无法通话，后台自动结束订单
- (void)errroOver{
    if ([TUICallingStatusManager shareInstance].callStatus != TUICallStatusNone){
        [TUICallingAction hangup];
    };
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"由于双方设备网络无法链接等情况导致通话中断" message:nil cancleBtn:@"好的，知道了"];
    [alerView showXLAlertView];
    [self dissMiseeShow];
}

- (NSMutableDictionary *)parm{
    if(!_parm){
        _parm = [[NSMutableDictionary alloc] init];
    }
    return _parm;
}
@end
