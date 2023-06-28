//
//  NoticeSharePersonCell.m
//  NoticeXi
//
//  Created by li lei on 2020/10/22.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSharePersonCell.h"

@implementation NoticeSharePersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15, 40, 40)];
        _iconImageView.layer.cornerRadius = 40/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_iconImageView.frame)+9,70, 12)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nickNameL];


    }
    return self;
}

- (void)setFriendM:(NoticeMyFriends *)friendM{
    _friendM = friendM;
    if (friendM.isMore) {
        _iconImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_morefrib":@"Image_morefriy");
        _nickNameL.text = @"";
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:friendM.avatar_url]]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
        _nickNameL.text = friendM.nick_name;
    }

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
