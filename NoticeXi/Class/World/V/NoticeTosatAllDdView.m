//
//  NoticeTosatAllDdView.m
//  NoticeXi
//
//  Created by li lei on 2022/1/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTosatAllDdView.h"

@implementation NoticeTosatAllDdView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH-40, 380)];
        backView.layer.cornerRadius = 20;
        backView.layer.masksToBounds = YES;
        backView.layer.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1].CGColor;
        [self addSubview:backView];
        self.backView = backView;
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20, 72, 72)];
        self.titleImageView.layer.cornerRadius = 4;
        self.titleImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.titleImageView];
        self.titleImageView.clipsToBounds = YES;
        self.titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, backView.frame.size.width-92-5, 72)];
        self.topicL.font = EIGHTEENTEXTFONTSIZE;
        self.topicL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.topicL];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 104, DR_SCREEN_WIDTH-40, 380-104-BOTTOM_HEIGHT)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.backView addSubview:self.scrollView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        self.nameL.font = THRETEENTEXTFONTSIZE;
        self.nameL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [self.scrollView addSubview:self.nameL];
        self.nameL.numberOfLines = 0;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.backView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
    }
    return self;
}

- (void)setActivityM:(NoticeTopicModel *)activityM{
    _activityM = activityM;
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:activityM.http_img_url]];
    self.topicL.text = activityM.title;
    self.nameL.attributedText = activityM.allTextAttStr;
    self.nameL.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-40, activityM.textHeight);
    self.scrollView.contentSize = CGSizeMake(0, activityM.textHeight);
}

- (void)showView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.backView.frame.size.height+10, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
