//
//  NoticeSendStatusView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendStatusView.h"

@implementation NoticeSendStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.nameView = [[UIView alloc] initWithFrame:CGRectMake(41, 0, 0, 20)];
        self.nameView.backgroundColor = [[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:0.2];
        self.nameView.layer.cornerRadius = 10;
        self.nameView.layer.masksToBounds = YES;
        
        [self addSubview:self.nameView];
        
        self.musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 12, 12)];
        self.musicImageView.image = UIImageNamed(@"voiceMusic_Image");
        [self.nameView addSubview:self.musicImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0,20)];
        self.nameL.font = ELEVENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.nameView addSubview:self.nameL];
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
        [self addSubview:self.statusImageView];
        
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20)];
        [self.closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
        

    }
    return self;
}

- (void)setStatusM:(NoticeVoiceStatusDetailModel *)statusM{
    _statusM = statusM;
    self.nameL.text = statusM.describe;
    [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:statusM.picture_url]];
    
    self.nameView.frame = CGRectMake(41, 0, GET_STRWIDTH(self.nameL.text, 11, 20)+20+10, 20);
    self.nameL.frame = CGRectMake(20, 0, GET_STRWIDTH(self.nameL.text, 11, 20), 20);
    self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20);
}
@end
