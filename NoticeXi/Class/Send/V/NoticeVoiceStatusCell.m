//
//  NoticeVoiceStatusCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceStatusCell.h"

@implementation NoticeVoiceStatusCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-32)/2, (frame.size.height-32-28)/2, 32, 32)];
        self.statusImageView.image = UIImageNamed(@"Image_statuse");
        [self.contentView addSubview:self.statusImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusImageView.frame)+10, frame.size.width, 18)];
        self.nameL.text = @"开心到飞起";
        self.nameL.font = THRETEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameL];
    }
    return self;
}

- (void)setStatusM:(NoticeVoiceStatusDetailModel *)statusM{
    [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:statusM.picture_url]];
    self.nameL.text = statusM.describe;
}
@end
