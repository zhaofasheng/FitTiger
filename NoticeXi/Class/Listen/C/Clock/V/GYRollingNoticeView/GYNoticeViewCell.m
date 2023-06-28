//
//  GYNoticeViewCell.m
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import "GYNoticeViewCell.h"

@implementation GYNoticeViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupInitialUI];
    }
    return self;
}

- (void)setupInitialUI
{
    self.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.2];

    _textLabel = [[UILabel alloc]init];
    _textLabel.font = THRETEENTEXTFONTSIZE;
    _textLabel.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    [self.contentView addSubview:_textLabel];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,2.5,25,25)];
    _iconImageView.layer.cornerRadius = 25/2;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _textLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+5, 0, 230 - 20-10-25,30);
}

- (void)setComM:(NoticeBBSComent *)comM{
    _comM = comM;
    _textLabel.text = comM.comment_content;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comM.userInfo.avatar_url]
                                     placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                              options:SDWebImageRefreshCached];
}

- (void)setStr:(NSString *)str{
    _str = str;
    self.iconImageView.hidden = YES;
    self.textLabel.frame = CGRectMake(0, 0,self.frame.size.width, 30);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:9];
    self.textLabel.text = str;
}

@end
