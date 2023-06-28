//
//  NoticePerCell.m
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePerCell.h"

@implementation NoticePerCell
{
    
    UILabel *_nameL;
    UILabel *_fromL;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [_iconImageView addSubview:mbView];
        }
    
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_iconImageView.frame)+15,65, 11)];
        _nameL.font = ELEVENTEXTFONTSIZE;
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_nameL];
        
        _fromL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_nameL.frame)+6,65, 11)];
        _fromL.font = ELEVENTEXTFONTSIZE;
        _fromL.textColor = GetColorWithName(VMainTextColor);
        _fromL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_fromL];
    }
    return self;
}

- (void)setPerson:(NoticeAllPersonlity *)person{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:person.role_pic_url]
                 placeholderImage:GETUIImageNamed(@"img_empty")
                          options:SDWebImageRefreshCached];
    _nameL.text = person.role_name;
    _fromL.text = [NSString stringWithFormat:@"%@",person.role_from];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
