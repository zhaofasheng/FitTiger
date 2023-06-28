//
//  NoticeDdcirHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2022/1/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeDdcirHeaderView.h"
#import "NoticeTosatAllDdView.h"
@implementation NoticeDdcirHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DR_SCREEN_WIDTH-40, 80)];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        backView.layer.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.1].CGColor;
        [self addSubview:backView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH-40, 80);
        [backView addSubview:visualView];
        self.visualView = visualView;
        self.backView = backView;
        self.blurEffect = blurEffect;
        
 
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12,12, 72, 72)];
        self.titleImageView.layer.cornerRadius = 4;
        self.titleImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.titleImageView];
        self.titleImageView.clipsToBounds = YES;
        self.titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(92, 12, backView.frame.size.width-92-5, 72)];
        self.topicL.font = EIGHTEENTEXTFONTSIZE;
        self.topicL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView addSubview:self.topicL];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(12, 92, 0, 0)];
        self.nameL.font = THRETEENTEXTFONTSIZE;
        self.nameL.textColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.8];
        [self.backView addSubview:self.nameL];
        self.nameL.numberOfLines = 0;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTap)];
        [self.nameL addGestureRecognizer:tap];
        self.nameL.userInteractionEnabled = YES;
        
        self.xuxianImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
        _xuxianImageV.image = UIImageNamed(@"Image_xuxiancir");
        [self.backView addSubview:self.xuxianImageV];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(12, self.frame.size.height-22-15, 200, 22)];
        self.numL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.numL.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:self.numL];
    }
    return self;
}

- (void)setActivityM:(NoticeTopicModel *)activityM{
    _activityM = activityM;
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:activityM.http_img_url]];
    self.topicL.text = activityM.title;
    
    if (activityM.isMoreFiveLines) {
        self.nameL.attributedText = activityM.fiveAttTextStr;
        self.nameL.frame = CGRectMake(12, 92, self.backView.frame.size.width-24, activityM.fiveTextHeight);
        self.backView.frame = CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 92+activityM.fiveTextHeight+15);
    }else{
        self.nameL.attributedText = activityM.allTextAttStr;
        self.nameL.frame = CGRectMake(12, 92, self.backView.frame.size.width-24, activityM.textHeight);
        self.backView.frame = CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 92+activityM.textHeight+15);
    }
    self.visualView.frame = self.backView.bounds;
    self.nameL.numberOfLines = 0;
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.backView.frame.size.height+20+30+15+22);
    self.xuxianImageV.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
    
    self.numL.frame = CGRectMake(12, self.frame.size.height-22-15, 200, 22);
}

- (void)detailTap{
    NoticeTosatAllDdView *detailView = [[NoticeTosatAllDdView alloc] initWithFrame:CGRectZero];
    detailView.activityM = self.activityM;
    [detailView showView];
}

@end
