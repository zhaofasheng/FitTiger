//
//  NoticePowerCell.m
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePowerCell.h"

@implementation NoticePowerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 38)];
        [self.contentView addSubview:self.backView];
                        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 4, 30, 30)];
        [self.backView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 26, 26)];
        iconImageView.layer.cornerRadius = 13;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:UIImageNamed(@"Image_duihuanIcon")];
        [self.backView addSubview:iconImageView];
                
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+4, 0, GET_STRWIDTH([[NoticeSaveModel getUserInfo] nick_name], 12, 38), 38)];
        nameL.font = TWOTEXTFONTSIZE;
        nameL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        nameL.text = [[NoticeSaveModel getUserInfo] nick_name];
        [self.backView addSubview:nameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameL.frame)+2, 9, 46, 21)];
        [self.backView addSubview:self.lelveImageView];
        self.lelveImageView.noTap = YES;
        
        UILabel *leaveL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-68-25, 0, 30, 38)];
        leaveL.font = THRETEENTEXTFONTSIZE;
        leaveL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backView addSubview:leaveL];
        self.leaveL = leaveL;
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-2-33, 0, 33, 38)];
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
