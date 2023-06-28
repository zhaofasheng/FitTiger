//
//  NoticeCurrentLeaveCell.m
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCurrentLeaveCell.h"

@implementation NoticeCurrentLeaveCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 44)];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.backView];
                        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 6, 32, 32)];
        [self.backView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 28, 28)];
        iconImageView.layer.cornerRadius = 13;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:UIImageNamed(@"Image_duihuanIcon")];
        [self.backView addSubview:iconImageView];
                
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+4, 0, GET_STRWIDTH([[NoticeSaveModel getUserInfo] nick_name], 12, 44), 44)];
        nameL.font = TWOTEXTFONTSIZE;
        nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        nameL.text = [[NoticeSaveModel getUserInfo] nick_name];
        [self.backView addSubview:nameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame)+2, 12, 46, 21)];
        [self.backView addSubview:self.lelveImageView];
        self.lelveImageView.noTap = YES;
        
        UILabel *leaveL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-68-25, 0, 30, 44)];
        leaveL.font = THRETEENTEXTFONTSIZE;
        leaveL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backView addSubview:leaveL];
        self.leaveL = leaveL;
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-2-33, 0, 33, 44)];
        numL.font = THRETEENTEXTFONTSIZE;
        numL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backView addSubview:numL];
        self.numL = numL;
    }
    return self;
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
