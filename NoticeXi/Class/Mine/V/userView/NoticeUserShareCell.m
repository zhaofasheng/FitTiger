//
//  NoticeUserShareCell.m
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserShareCell.h"

@implementation NoticeUserShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, 40)];
        self.iconImageView.layer.cornerRadius = 20;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(self.iconImageView.frame)+3, 60,17)];
        self.nameL.font = TWOTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.nameL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameL];
        
        self.moreL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.moreL.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.moreL.textAlignment = NSTextAlignmentCenter;
        self.moreL.font = THRETEENTEXTFONTSIZE;
        self.moreL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.moreL.layer.cornerRadius = 20;
        self.moreL.text = [NoticeTools getLocalStrWith:@"movie.more"];
        self.moreL.layer.masksToBounds = YES;
        [self.iconImageView addSubview:self.moreL];
    }
    return self;
}

- (void)setFriendM:(NoticeFriendAcdModel *)friendM{
    _friendM = friendM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:friendM.avatar_url]];
    self.nameL.text = friendM.nick_name;
    
    if (friendM.more) {
        self.moreL.hidden = NO;
        self.nameL.hidden = YES;
    }else{
        self.moreL.hidden = YES;
        self.nameL.hidden = NO;
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
