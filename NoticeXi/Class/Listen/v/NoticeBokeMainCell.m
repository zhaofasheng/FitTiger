//
//  NoticeBokeMainCell.m
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBokeMainCell.h"

@implementation NoticeBokeMainCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.width*111/180)];
        [self.contentView addSubview:self.backImageView];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(8,CGRectGetMaxY(self.backImageView.frame)+8,self.backImageView.frame.size.width-16,40)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.numberOfLines = 2;
        self.titleL.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleL];

        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(8, self.frame.size.height-8-17,self.backImageView.frame.size.width-18, 17)];
        self.nameL.font = TWOTEXTFONTSIZE;
        self.nameL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:self.nameL];
        
    }
    return self;
}

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;

    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:nil];
    self.titleL.text = model.podcast_title;
    self.nameL.text = model.nick_name?model.nick_name:@"声昔官方播客";
    
    if (model.introeHeight <= 0) {
        model.introeHeight = GET_STRHEIGHT(model.podcast_title, 14, self.backImageView.frame.size.width-16);
        if (model.introeHeight > 40) {
            model.introeHeight = 40;
        }
    }
    self.titleL.frame = CGRectMake(8,CGRectGetMaxY(self.backImageView.frame)+8,self.backImageView.frame.size.width-16,model.introeHeight);
    self.hotL.hidden = model.is_hot.intValue?NO:YES;
}

- (UILabel *)hotL{
    if (!_hotL) {
        _hotL = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, GET_STRWIDTH([NoticeTools chinese:@"官方推荐" english:@"Recommended" japan:@"おすすめ"], 12, 21)+8, 21)];
        _hotL.textColor = [UIColor whiteColor];
        _hotL.font = TWOTEXTFONTSIZE;
        _hotL.textAlignment = NSTextAlignmentCenter;
        _hotL.text = [NoticeTools chinese:@"官方推荐" english:@"Recommended" japan:@"おすすめ"];
        _hotL.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        _hotL.layer.cornerRadius = 2;
        _hotL.layer.masksToBounds = YES;
        [self.backImageView addSubview:_hotL];
        
    }
    return _hotL;
}

@end
