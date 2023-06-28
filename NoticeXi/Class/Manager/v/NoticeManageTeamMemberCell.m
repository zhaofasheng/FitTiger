//
//  NoticeManageTeamMemberCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeManageTeamMemberCell.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeManageTeamMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = self.contentView.backgroundColor;
        
        self.fromL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.fromL.font = FOURTHTEENTEXTFONTSIZE;
        self.fromL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.fromL];
        
        self.checkL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.checkL.font = FOURTHTEENTEXTFONTSIZE;
        self.checkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.checkL];
        
        self.toL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.toL.font = FOURTHTEENTEXTFONTSIZE;
        self.toL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.toL];
        
        self.reasonL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.reasonL.font = TWOTEXTFONTSIZE;
        self.reasonL.numberOfLines = 0;
        self.reasonL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.reasonL];
        
        self.typeL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.typeL.font = TWOTEXTFONTSIZE;
        self.typeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.typeL];
        
        self.teamL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.teamL.font = TWOTEXTFONTSIZE;
        self.teamL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.teamL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.contentView addSubview:self.timeL];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:self.line];
        
        
        self.fromL.userInteractionEnabled = YES;
        self.toL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromTap)];
        [self.fromL addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTap)];
        [self.toL addGestureRecognizer:tap1];
    }
    return self;
}
- (void)toTap{
    if ([self.model.toUserM.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.model.toUserM.userId;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)fromTap{
    if ([self.model.fromUserM.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.model.fromUserM.userId;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)setModel:(NoticeTeamManageMemberModel *)model{
    _model = model;
    self.fromL.text = model.fromUserM.nick_name;
    self.checkL.text =self.isOut? @" 移出 ":@" 解除管理 ";
    self.toL.text = model.toUserM.nick_name;
    self.reasonL.text = self.isOut?model.reason_type:model.reason;
    if(self.isOut){
        self.typeL.text = model.is_forbid.boolValue?@"移出方式:仅移出":@"移出方式:移出并禁止加入";
        self.teamL.text = [NSString stringWithFormat:@"社团：%@", model.mass_title];
    }
    self.timeL.text = model.created_at;

    self.fromL.frame = CGRectMake(15, 15,GET_STRWIDTH(self.fromL.text, 14, 20), 20);
    self.checkL.frame = CGRectMake(CGRectGetMaxX(self.fromL.frame), 15,GET_STRWIDTH(self.checkL.text, 14, 20), 20);
    self.toL.frame = CGRectMake(CGRectGetMaxX(self.checkL.frame), 15,GET_STRWIDTH(self.toL.text, 14, 20), 20);
    if(self.isOut){
        self.reasonL.frame = CGRectMake(15, CGRectGetMaxY(self.fromL.frame)+8, DR_SCREEN_WIDTH-30, 17);
        self.typeL.frame = CGRectMake(15, CGRectGetMaxY(self.reasonL.frame)+8, DR_SCREEN_WIDTH-30, 17);
        self.teamL.frame = CGRectMake(15, CGRectGetMaxY(self.typeL.frame)+8, DR_SCREEN_WIDTH-30, 17);
        self.timeL.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(self.timeL.text, 11, 14), 65,GET_STRWIDTH(self.timeL.text, 11, 17), 17);
        self.line.frame = CGRectMake(15, CGRectGetMaxY(self.teamL.frame)+13, DR_SCREEN_WIDTH-30, 1);
    }else{
        self.reasonL.frame = CGRectMake(15, CGRectGetMaxY(self.fromL.frame)+8, DR_SCREEN_WIDTH-30, model.reasonHeight);
        self.timeL.frame = CGRectMake(15, CGRectGetMaxY(self.reasonL.frame)+4, DR_SCREEN_WIDTH-30, 14);
        self.line.frame = CGRectMake(15, CGRectGetMaxY(self.timeL.frame)+13, DR_SCREEN_WIDTH-30, 1);
    }
}

@end
