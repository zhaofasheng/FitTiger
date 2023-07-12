//
//  NoticeHMemberTeamCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeHMemberTeamCell.h"
#import "UIView+CLSetRect.h"
@implementation NoticeHMemberTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,0, 40, 40)];
        [_iconImageView setAllCorner:20];
        [self.contentView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 44,56, 17)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:_nickNameL];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
  
        self.contentView.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNameNotice:) name:@"CHANGETEAMMASSNICKNAMENotification" object:nil];
    }
    return self;
}

- (void)editNameNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSString *userId = Dictionary[@"userId"];
    NSString *name = Dictionary[@"nickName"];
    if([self.person.userId isEqualToString:userId]){
        self.person.name = name;
        self.nickNameL.text = name;
    }
}

- (void)setPerson:(YYPersonItem *)person{
    _person = person;
    self.nickNameL.text = person.name;
    self.markImage.hidden = [person.userId isEqualToString:@"1"]?NO:YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:person.avatar_url]];
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
