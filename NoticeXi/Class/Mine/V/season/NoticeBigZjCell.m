//
//  NoticeBigZjCell.m
//  NoticeXi
//
//  Created by li lei on 2019/8/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBigZjCell.h"

@implementation NoticeBigZjCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [GetColorWithName(VlistColor) colorWithAlphaComponent:0];
        _zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH-32,DR_SCREEN_WIDTH-32)];
        _zjImageView.layer.cornerRadius = 10;
        _zjImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_zjImageView];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_zjImageView.frame)+10, _zjImageView.frame.size.width, 15)];
        _nameL.numberOfLines = 1;
        _nameL.textColor = GetColorWithName(VDarkTextColor);
        _nameL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:_nameL];
    }
    return self;
}
- (void)setZjModel:(NoticeZjModel *)zjModel{
    _zjModel = zjModel;
    _nameL.text = zjModel.album_name;
    [_zjImageView sd_setImageWithURL:[NSURL URLWithString:zjModel.album_cover_url]
                    placeholderImage:GETUIImageNamed(@"img_empty")
                             options:SDWebImageRefreshCached];
}

@end
