//
//  NoticeGroupListCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGroupListCell.h"
#import "UIView+CLSetRect.h"
@implementation NoticeGroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 108)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        [self.backView setRightAndBottonCorner:20];
        
        self.groupImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 56, 56)];
        [self.backView addSubview:self.groupImageView];
        
        self.groupNameL = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, self.backView.frame.size.width-80-50, 28)];
        self.groupNameL.font = XGEightBoldFontSize;
        self.groupNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.groupNameL];
        
        self.numL = [[UILabel alloc] init];
        self.numL.font = THRETEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.numL];
        self.numL.frame = CGRectMake(self.backView.frame.size.width-15-GET_STRWIDTH(self.numL.text, 13, 18), 20, GET_STRWIDTH(self.numL.text, 13, 18), 18);
        
        self.peopleNumView = [[UIImageView alloc] initWithFrame:CGRectMake(self.numL.frame.origin.x-17, 21, 16, 16)];
        self.peopleNumView.image = UIImageNamed(@"grouppeoplenum_img");
        [self.backView addSubview:self.peopleNumView];
        
        UIView *msgView = [[UIView alloc] initWithFrame:CGRectMake(80, 56, self.backView.frame.size.width-80-15, 36)];
        msgView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [msgView setAllCorner:8];
        [self.backView addSubview:msgView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
        [self.iconImageView setAllCorner:10];
        [msgView addSubview:self.iconImageView];
        self.iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
        
        self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, self.backView.frame.size.width-80-50, 36)];
        self.msgL.font = FOURTHTEENTEXTFONTSIZE;
        self.msgL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [msgView addSubview:self.msgL];
    }
    return self;
}

- (void)setGroupModel:(NoticeGroupListModel *)groupModel{
    _groupModel = groupModel;
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.img_url]];
    self.groupNameL.text = groupModel.title;
    self.msgL.frame = CGRectMake(32, 0, self.backView.frame.size.width-80-50, 36);
    self.iconImageView.hidden = groupModel.lastMsgModel.contentType?NO:YES;
    self.msgL.hidden = groupModel.lastMsgModel.contentType?NO:YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:groupModel.lastMsgModel.fromUserM.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"]];
    self.msgL.text = groupModel.lastMsgModel.contentType==1?groupModel.lastMsgModel.content:(groupModel.lastMsgModel.contentType==2?@"「图片」":@"「语音」");
    if (groupModel.lastMsgModel.contentType > 3) {
        self.msgL.text = @"请更新到最新版本查看";
    }
    
    if(groupModel.call_id.integerValue > 0){
        self.numL.text = @"有人@我";
        self.numL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.peopleNumView.image = UIImageNamed(@"Image_bodyat");
    }else if (groupModel.is_join.boolValue){
        self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.numL.text = groupModel.unread_num.intValue > 99?@"99+":(groupModel.unread_num.intValue>0?groupModel.unread_num:@"");
        self.peopleNumView.image = UIImageNamed(@"Image_teammsgnum");
    }else{
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.numL.text = groupModel.member_num.intValue?groupModel.member_num:@"";
        self.peopleNumView.image = UIImageNamed(@"grouppeoplenum_img");
    }
    
    if(groupModel.is_join.boolValue){
        NSMutableArray *alreadyArr = [NoticeTools getTeamChatArrArrarychatId:[NSString stringWithFormat:@"%@-%@",groupModel.teamId,[NoticeTools getuserId]]];
        if(alreadyArr.count){
            self.numL.text = @"发送失败";
            self.numL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
            self.peopleNumView.image = UIImageNamed(@"Image_failimg");
        }
        
        NSString *saveContent = [NoticeComTools getInputWithKey: [NSString stringWithFormat:@"teamChat%@%@",[NoticeTools getuserId],groupModel.teamId]];
        if(saveContent && saveContent.length){
            self.iconImageView.hidden = YES;
            self.msgL.hidden = NO;
            self.msgL.frame = CGRectMake(8, 0, self.backView.frame.size.width-80-50+24, 36);
            self.msgL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"[草稿]%@",saveContent] setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"[草稿]" beginSize:0];
        }
    }
    
    self.numL.frame = CGRectMake(self.backView.frame.size.width-GET_STRWIDTH(self.numL.text, 13, 18)-15, 21, GET_STRWIDTH(self.numL.text, 13, 18), 18);
    self.peopleNumView.frame = CGRectMake(self.numL.frame.origin.x-17, 21, 16, 16);

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
