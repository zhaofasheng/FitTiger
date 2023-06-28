//
//  NoticeTextZJContentCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJContentCell.h"

@implementation NoticeTextZJContentCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(30,0,DR_SCREEN_WIDTH-60,DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH-40-22)];
        backView.backgroundColor = GetColorWithName(VBackColor);
        backView.layer.cornerRadius = 5;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        
        self.scrollView = [[NoticeScrollView alloc] initWithFrame:CGRectMake(0,45+15+15,DR_SCREEN_WIDTH-60,DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH-40-22-60-15)];
        self.scrollView.backgroundColor = GetColorWithName(VBackColor);
        self.scrollView.layer.cornerRadius = 5;
        self.scrollView.layer.masksToBounds = YES;
        [backView addSubview:self.scrollView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+15+15, backView.frame.size.width-30, 25)];
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.titleL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, backView.frame.size.width-30, 15)];
        self.timeL.textColor = GetColorWithName(VMainTextColor);
        self.timeL.font = FIFTHTEENTEXTFONTSIZE;
        [backView addSubview:self.timeL];
        
        _lockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-18,12, 18, 18)];
        _lockImageV.image = UIImageNamed(@"Imagelock");
        _lockImageV.hidden = YES;
        [backView addSubview: _lockImageV];
        
        self.contentL = [[UILabel alloc] init];
        self.contentL.textColor = GetColorWithName(VMainTextColor);
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.scrollView addSubview:self.contentL];
    }
    return self;
}


- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    self.timeL.text = voiceM.longTextListTime;
    self.titleL.text = voiceM.title;
    self.lockImageV.hidden = _voiceM.is_private.integerValue?NO:YES;
    self.contentL.frame = CGRectMake(30, 0,self.scrollView.frame.size.width-60, voiceM.zjContentHeight);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width-60, voiceM.zjContentHeight);
    self.contentL.attributedText = voiceM.zjAttTextStr;
    self.contentL.numberOfLines = 0;
}

@end
