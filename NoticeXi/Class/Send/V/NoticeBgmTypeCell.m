//
//  NoticeBgmTypeCell.m
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBgmTypeCell.h"

@implementation NoticeBgmTypeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-60)/2, 68)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        self.iconImageView.layer.cornerRadius = 4;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
        [backView addSubview:self.iconImageView];
        
        self.playBtn = [[UIImageView alloc] initWithFrame:CGRectMake(22, 22, 24, 24)];
        self.playBtn.image = UIImageNamed(@"Image_bfzdyyy");//Image_ztzdyyy
        [backView addSubview:self.playBtn];
     
        self.nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(70, 8, backView.frame.size.width-72, 20)];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.nameL];
        
        self.useButton = [[UIButton alloc] initWithFrame:CGRectMake((backView.frame.size.width-68-36)/2+68, CGRectGetMaxY(self.nameL.frame)+12, 36, 20)];
        self.useButton.layer.cornerRadius = 2;
        self.useButton.layer.masksToBounds = YES;
        self.useButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.useButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        [self.useButton setTitle:[NoticeTools getLocalStrWith:@"songList.use"] forState:UIControlStateNormal];
        [self.useButton addTarget:self action:@selector(useClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.useButton];
    }
    return self;
}

- (void)setModel:(NoticeTextZJMusicModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.bgmM.image_url]];
    self.nameL.text = model.bgmM.tips;
    
    self.nameL.textColor = model.isSelect?[UIColor colorWithHexString:@"#0099E6"]:[UIColor colorWithHexString:@"#25262E"];
    self.playBtn.image = UIImageNamed(model.isPlaying?@"Image_ztzdyyy":@"Image_bfzdyyy");
}

- (void)useClick{
    if (self.useMusicBlock) {
        self.useMusicBlock(self.model);
    }
}

@end
