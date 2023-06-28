//
//  NoticeListPlayer.m
//  NoticeXi
//
//  Created by li lei on 2018/11/16.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeListPlayer.h"

@implementation NoticeListPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(frame.size.height/4, (frame.size.height-20)/2, 20, 20);
        
        [self.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:114", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:11", 14, 14), 14)];
        self.timeL.font = FOURTHTEENTEXTFONTSIZE;
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.textColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
        [self addSubview:self.timeL];
        
    }
    return self;
}

- (void)startOrStop{
    
}

- (void)setTimeLen:(NSString *)timeLen{
    _timeLen = timeLen;
    self.timeL.text = [self getMMSSFromSS:_timeLen];
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    if (str_second.integerValue < 10) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}

- (void)refreWithFrame{
    CGRect  frame = self.frame;
    
    self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:110", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
}
@end
