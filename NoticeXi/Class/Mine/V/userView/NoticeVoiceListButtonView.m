//
//  NoticeVoiceListButtonView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceListButtonView.h"

@implementation NoticeVoiceListButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        MCFireworksButton *imageView1 = [[MCFireworksButton alloc] initWithFrame:CGRectMake(15,25/2,25, 25)];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        imageView1.image = GETUIImageNamed(@"shareNewButton");
        imageView1.particleImage = [UIImage imageNamed:@"like_select"];
        imageView1.particleScale = 0.05;
        imageView1.particleScaleRange = 0.02;
        _firstImageView = imageView1;
        [self addSubview:imageView1];
        

        _firstL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+7, 0, (DR_SCREEN_WIDTH-30)/3-10-20+30, 50)];
        _firstL.font = TWOTEXTFONTSIZE;
        _firstL.textColor = GetColorWithName(VDarkTextColor);
        _firstL.text = GETTEXTWITE(@"voicelist.share");
        [self addSubview:_firstL];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50)-20-7,30/2,20, 20)];
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        imageView3.image = GETUIImageNamed(@"moreButtonName");
        _thirdImageView = imageView3;
        [self addSubview:imageView3];
        
        _thirdL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50), 0,GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50), 50)];
        _thirdL.font = TWOTEXTFONTSIZE;
        _thirdL.textColor = GetColorWithName(VDarkTextColor);
        _thirdL.text = GETTEXTWITE(@"voicelist.more");
        [self addSubview:_thirdL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-((DR_SCREEN_WIDTH-30)/3))/2, 0, (DR_SCREEN_WIDTH-30)/3, 50)];
        [button setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        [button setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        button.titleLabel.font = TWOTEXTFONTSIZE;
        [button setImage:GETUIImageNamed(@"replayButtonName") forState:UIControlStateNormal];
        _replyBytton = button;
        [button addTarget:self action:@selector(replyHasClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        for (int i = 0; i < 2; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(15+((DR_SCREEN_WIDTH-30)/3*2)*i, 0, (DR_SCREEN_WIDTH-30)/3, 50)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV:)];
            [tapView addGestureRecognizer:tap];
            [self addSubview:tapView];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,50,DR_SCREEN_WIDTH, 8)];
        line.backgroundColor = GetColorWithName(VBigLineColor);
        [self addSubview:line];
        _line = line;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"CHANGETHEMCOLORNOTICATION" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEMCOLORNOTICATION" object:nil];
}

- (void)changeColor{
    [_replyBytton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    [_replyBytton setImage:GETUIImageNamed(@"replayButtonName") forState:UIControlStateNormal];
    _thirdImageView.image = GETUIImageNamed(@"moreButtonName");
    _firstImageView.image = GETUIImageNamed(@"shareNewButton");
    _firstL.textColor = GetColorWithName(VDarkTextColor);
    _thirdL.textColor = GetColorWithName(VDarkTextColor);
    _line.backgroundColor = GetColorWithName(VBigLineColor);
}

- (void)refreshColor{
    [_replyBytton setTitleColor:[NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#d3d3d3"] : GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
}

- (void)tapV:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareAndLikeClick)]) {//「有启发」点击
            [self.delegate shareAndLikeClick];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreClick)]) {//更多点击
            [self.delegate moreClick];
        }
    }
}

- (void)replyHasClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(replayClick:)]) {//悄悄话点击
        [self.delegate replayClick:_replyBytton];
    }
}

@end
