//
//  NoticeHelpQiuzhutieView.m
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpQiuzhutieView.h"
#import "NoticeHelpBaseController.h"
#import "NoticeHelpDetailController.h"
@implementation NoticeHelpQiuzhutieView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30,126)];
        backView.contentMode = UIViewContentModeScaleAspectFill;
        backView.clipsToBounds = YES;
        backView.userInteractionEnabled = YES;
        backView.image = UIImageNamed(@"Image_helpbackimg");
        [self addSubview:backView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
        titleL.text = [NoticeTools getLocalStrWith:@"help.qiuz"];
        titleL.font = XGTwentyTwoBoldFontSize;
        titleL.textColor = [UIColor whiteColor];
        [backView addSubview:titleL];
        
        UIButton *intoBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-30-15, 10, 30, 30)];
        [intoBtn addTarget:self action:@selector(tielistClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:intoBtn];
        
        UIImageView *intoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 20, 20)];
        intoImgV.image = UIImageNamed(@"Image_ddqin");
        [intoBtn addSubview:intoImgV];

        self.hotImg = [[UIImageView alloc] initWithFrame:CGRectMake(15,58, 16, 16)];
        self.hotImg.image = UIImageNamed(@"Image_hotimg");
        [backView addSubview:self.hotImg];
        
        self.hotL = [[UILabel alloc] initWithFrame:CGRectMake(39, 55,backView.frame.size.width-39-5, 22)];
        self.hotL.font = XGSIXBoldFontSize;
        self.hotL.textColor = [UIColor whiteColor];
        self.hotL.userInteractionEnabled = YES;
        UITapGestureRecognizer *hotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotDetail)];
        [self.hotL addGestureRecognizer:hotTap];
        [backView addSubview:self.hotL];
        
        self.helpImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 92, 16, 16)];
        self.helpImg.image = UIImageNamed(@"Image_newimg");
        [backView addSubview:self.helpImg];
        
        self.helpL = [[UILabel alloc] initWithFrame:CGRectMake(39,89,backView.frame.size.width-39-5, 22)];
        self.helpL.font = XGSIXBoldFontSize;
        self.helpL.textColor = [UIColor whiteColor];
        [backView addSubview:self.helpL];
        self.helpL.userInteractionEnabled = YES;
        UITapGestureRecognizer *helpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpDetail)];
        [self.helpL addGestureRecognizer:helpTap];
    }
    return self;
}

- (void)hotDetail{
    if (!self.hotModel || !self.hotModel.title.length) {
        return;
    }
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = self.hotModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)helpDetail{
    if (!self.recentModel) {
        return;
    }
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = self.recentModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)tielistClick{
    NoticeHelpBaseController *ctl = [[NoticeHelpBaseController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setHotModel:(NoticeHelpListModel *)hotModel{
    _hotModel = hotModel;
    self.hotL.text = hotModel.title;
}

- (void)setRecentModel:(NoticeHelpListModel *)recentModel{
    _recentModel = recentModel;
    self.helpL.text = recentModel.title;
}

@end
