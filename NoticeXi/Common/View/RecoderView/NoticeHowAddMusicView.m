//
//  NoticeHowAddMusicView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeHowAddMusicView.h"

@implementation NoticeHowAddMusicView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NoticeTools getLocalType]?@"How to upload": @"如何上传";
        [self addSubview:label];

        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(10, STATUS_BAR_HEIGHT, 42, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"Image_blackBack"] forState:UIControlStateNormal];
        [self addSubview:backButton];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        [self addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(0, (DR_SCREEN_WIDTH-40)*690/327+50);
        scrollView.bounces = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)*690/327+50)];
        imageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_howaddmusic"]);
        [scrollView addSubview:imageView];
    }
    return self;
}

- (void)backToPageAction{
    [self removeFromSuperview];
}

@end
