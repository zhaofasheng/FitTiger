//
//  NoticeTestFinishView.m
//  NoticeXi
//
//  Created by li lei on 2021/6/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestFinishView.h"

@implementation NoticeTestFinishView

- (instancetype)initWithShowUserInfo{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-150)/2, (DR_SCREEN_HEIGHT-250)/2, 150, 138)];
        self.backImageView = imageView;
        imageView.image = UIImageNamed(@"Image_dingzhiwancc");
        [self addSubview:imageView];

        self.mainL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+30, DR_SCREEN_WIDTH, 30)];
        self.mainL.font = XGTwentyTwoBoldFontSize;
        self.mainL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.mainL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mainL];
        
        self.subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainL.frame)+20, DR_SCREEN_WIDTH, 55)];
        self.subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.subL.font = FOURTHTEENTEXTFONTSIZE;
        self.subL.numberOfLines = 0;
        self.subL.text = [NoticeTools getLocalStrWith:@"test.finish"];
        self.subL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.subL];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitMessage) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)waitMessage{
    self.time++;
    if (self.time == 2) {
        [self.timer invalidate];
        if (self.hideBlock) {
            self.hideBlock(YES);
        }
        [self removeFromSuperview];
    }
}
- (void)showChoiceView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    
}

@end
