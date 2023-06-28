//
//  NoticeSearchChatCell.m
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchChatCell.h"

@implementation NoticeSearchChatCell
{
    UIButton *_beizhuBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
   
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,14.5,35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 0,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15, 64.5)];
        _nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
   
        
        _beizhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, 41/2, 24, 24)];
        [_beizhuBtn setBackgroundImage:UIImageNamed(@"Image_sendtextbtn") forState:UIControlStateNormal];
        [_beizhuBtn addTarget:self action:@selector(beizhuClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_beizhuBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 64.5, DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
     
    }
    return self;
}

- (void)setFriendM:(NoticeFriendAcdModel *)friendM{
    _friendM = friendM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:friendM.avatar_url]];
    self.nickNameL.text = friendM.nick_name;
}

- (void)beizhuClick{
    if (self.sendBlcok) {
        self.sendBlcok(self.friendM);
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
