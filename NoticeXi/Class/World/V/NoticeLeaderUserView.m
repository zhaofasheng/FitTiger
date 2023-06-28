//
//  NoticeLeaderUserView.m
//  NoticeXi
//
//  Created by li lei on 2021/7/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeLeaderUserView.h"

@implementation NoticeLeaderUserView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-DR_SCREEN_WIDTH,DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
   
        self.parser = [[SVGAParser alloc] init];
        //bottombig
        [self.parser parseWithNamed:@"zhishi" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
        
        [self addSubview:self.svagPlayer];
        
        UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH-TAB_BAR_HEIGHT, 50, 50)];
        [cancelbtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
        [self addSubview:cancelbtn];
        [cancelbtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)cancelClick{
    [NoticeTools setMarkForlogin];
    [self.svagPlayer pauseAnimation];
    [self removeFromSuperview];
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}
@end
