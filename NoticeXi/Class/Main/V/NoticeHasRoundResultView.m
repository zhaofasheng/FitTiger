//
//  NoticeHasRoundResultView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasRoundResultView.h"

@implementation NoticeHasRoundResultView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTap)];
        [self addGestureRecognizer:tap];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,315, 430)];
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        self.contentView.center = self.center;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 42,self.contentView.frame.size.width, 16)];
        titleL.text = [NoticeTools getTextWithSim:@"与其浪费时间犹豫，不如立刻马上" fantText:@"與其浪費時間猶豫，不如立刻馬上"];
        titleL.textColor = GetColorWithName(VMainThumeWhiteColor);
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL];
        
        UILabel *titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleL.frame)+90,self.contentView.frame.size.width, 23)];
        titleL1.textColor = GetColorWithName(VMainThumeWhiteColor);
        titleL1.font = XGTwentyTwoBoldFontSize;
        titleL1.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL1];
        self.typeL = titleL1;
        
        UILabel *titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL1.frame)+30,self.contentView.frame.size.width, 40)];
        titleL2.textColor = GetColorWithName(VMainThumeWhiteColor);
        titleL2.font = [UIFont fontWithName:XGBoldFontName size:38 ];
        titleL2.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleL2];
        self.timeL = titleL2;

    }
    return self;
}

- (void)setType:(NSInteger)type{
    _type = type;
    //1:学习  2:躺尸 3：活动拉伸  4培养兴趣  5:刷最近追的剧 6阅读 7游戏
    NSString *str = nil;
    if (type == 1) {
        str = @"学习";
    }else if (type == 2){
        str = @"躺尸";
    }else if (type == 3){
        str = @"活动拉伸";
    }else if (type == 4){
        str = @"培养兴趣";
    }else if (type == 5){
        str = @"刷最近追的剧";
    }else if (type == 6){
        str = @"阅读";
    }else if (type == 7){
        str = @"游戏";
    }
    self.typeL.text = str;
}

- (void)hideTap{
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
    [self removeFromSuperview];
}

- (void)showTostView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.20, 0.20);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
