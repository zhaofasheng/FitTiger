//
//  NoticeTostWhtieVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTostWhtieVoiceView.h"

@implementation NoticeTostWhtieVoiceView
{
    LGAudioPlayer *_audioPlayer;
}
- (instancetype)initWithShow:(NoticeWhiteVoiceListModel *)cardM{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        self.userInteractionEnabled = YES;

        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-270)/2, (DR_SCREEN_HEIGHT-354)/2, 270, 354)];
        contentView.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.contentView = contentView;
        [self addSubview:contentView];
        
        _audioPlayer = [[LGAudioPlayer alloc] init];
        [_audioPlayer startPlayWithUrl:cardM.audio_url isLocalFile:NO];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 270, 354)];
        [self.contentView addSubview:imageView];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:cardM.card_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height-120, imageView.frame.size.width, 120)];
            backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
            [imageView addSubview:backView];
            
            UIView *titlev = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 46, 79)];
            titlev.layer.borderWidth = 1;
            titlev.layer.borderColor = [UIColor colorWithHexString:@"#5C5F66"].CGColor;
            [backView addSubview:titlev];
            
            UILabel *nameL1 = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 44, 77/2)];
            nameL1.textColor = [UIColor colorWithHexString:@"#EBECF0"];
            nameL1.font = XGTwentyTwoBoldFontSize;
            nameL1.textAlignment = NSTextAlignmentCenter;
            if (cardM.card_title.length) {
                nameL1.text = [cardM.card_title substringToIndex:1];
            }
            [titlev addSubview:nameL1];
            
            UILabel *nameL2 = [[UILabel alloc] initWithFrame:CGRectMake(1,CGRectGetMaxY(nameL1.frame), 44, 77/2)];
            nameL2.textColor = [UIColor colorWithHexString:@"#EBECF0"];
            nameL2.font = XGTwentyTwoBoldFontSize;
            nameL2.textAlignment = NSTextAlignmentCenter;
            if (cardM.card_title.length >= 2) {
                nameL2.text = [cardM.card_title substringWithRange:NSMakeRange(1, 1)];
            }
            [titlev addSubview:nameL2];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(118, 33, 90, 22)];
            label.textColor =[UIColor colorWithHexString:@"#FFFFFF"];
            label.font = SIXTEENTEXTFONTSIZE;
            label.text = [NoticeTools getLocalStrWith:@"bz.getzzs"];
            [backView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(118,CGRectGetMaxY(label.frame)+3, 118, 32)];
            label1.textColor =[UIColor colorWithHexString:@"#8A8F99"];
            label1.font = FOURTHTEENTEXTFONTSIZE;
            label1.text = [NoticeTools getLocalStrWith:@"bz.howlook"];
            [backView addSubview:label1];
        }];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)waitMessage{
    self.time++;
    if (self.time == 3) {
        [self.timer invalidate];
        [UIView animateWithDuration:1 animations:^{
            self.contentView.frame = CGRectMake((DR_SCREEN_WIDTH-270)/2, -DR_SCREEN_HEIGHT, 270, 354+40);
        } completion:^(BOOL finished) {
            [self dissMissView];
        }];
    }
}

- (void)dissMissView{
    [_audioPlayer stopPlaying];
    [self removeFromSuperview];
}

- (void)showCardView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}
@end
