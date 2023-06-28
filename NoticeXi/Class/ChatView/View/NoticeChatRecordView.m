//
//  NoticeChatRecordView.m
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatRecordView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeChatRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UILabel * topL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-220)/2,90,60, 60)];
        topL.textAlignment = NSTextAlignmentCenter;
        topL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        topL.font = EIGHTEENTEXTFONTSIZE;
        topL.text = [NoticeTools getLocalStrWith:@"main.cancel"];
        topL.textAlignment = NSTextAlignmentCenter;
        topL.layer.cornerRadius = 30;
        topL.layer.masksToBounds = YES;
        topL.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
        topL.userInteractionEnabled = YES;
        [self addSubview:topL];
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSendMsg)];
        [topL addGestureRecognizer:cancelTap];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frame.size.width, 50)];
        _timeL.font = THIRTTYBoldFontSize;
        _timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.text = @"0s";
        [self addSubview:_timeL];
        
        _cancelL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topL.frame)+100,90, 60,60)];
        _cancelL.textAlignment = NSTextAlignmentCenter;
        _cancelL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _cancelL.font = EIGHTEENTEXTFONTSIZE;
        _cancelL.text = [NoticeTools getLocalStrWith:@"read.send"];
        _cancelL.layer.cornerRadius = 30;
        _cancelL.layer.masksToBounds = YES;
        _cancelL.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        _cancelL.userInteractionEnabled = YES;
        [self addSubview:_cancelL];
        
        UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMsg)];
        [_cancelL addGestureRecognizer:sendTap];
    }
    return self;
}

- (void)sendMsg{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSend)]) {
        [self.delegate clickSend];
    }
}

- (void)cancelSendMsg{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEnd)]) {
        [self.delegate clickEnd];
    }
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger seconds = (NSInteger)recordTime % 60;
    _timeL.text = [NSString stringWithFormat:@"%lds", seconds];
}

- (void)setPhase:(NoticeAudioRecordPhase)phase{
    if(phase == NAudioRecordPhaseStart) {
    
    } else if(phase == NAudioRecordPhaseCancelling) {
//        _cancelL.text = @"松开手指，取消发送";
//        _cancelL.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    } else {
//        _cancelL.text = @"手指上滑，取消发送";
//        _cancelL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
}

@end
