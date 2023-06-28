//
//  NoticeDuiHuanRecoderCell.m
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDuiHuanRecoderCell.h"

@implementation NoticeDuiHuanRecoderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:backView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 36, 36)];
        self.iconImageView.layer.cornerRadius = 18;
        self.iconImageView.layer.masksToBounds = YES;
        [backView addSubview:self.iconImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+9, 15, 200, 21)];
        self.nameL.font = XGFifthBoldFontSize;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
  
        [backView addSubview:self.nameL];
        
        
        self.codeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+9, CGRectGetMaxY(self.nameL.frame)+4, 200, 16)];
        self.codeL.font = ELEVENTEXTFONTSIZE;
        self.codeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6];
        
        [backView addSubview:self.codeL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+9, CGRectGetMaxY(self.codeL.frame)+4, 200, 16)];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6];

        [backView addSubview:self.timeL];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-60, 15, 60, 28)];
        self.numL.font = XGTwentyFifBoldFontSize;
        self.numL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];

        self.numL.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.numL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(66, 89, DR_SCREEN_WIDTH-66, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [backView addSubview:line];
    }
    return self;
}

- (void)setDModel:(NoticeDuiHRecoderModel *)dModel{
    _dModel = dModel;
    self.nameL.text = dModel.product_name;
    self.codeL.text = [NSString stringWithFormat:@"%@：%@",[NoticeTools getLocalStrWith:@"zb.dhm"],dModel.code];
    self.timeL.text = dModel.created_at;
    self.numL.text = dModel.points;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dModel.product_icon]];
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
