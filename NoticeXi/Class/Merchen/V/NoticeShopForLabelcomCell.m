//
//  NoticeShopForLabelcomCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopForLabelcomCell.h"

@implementation NoticeShopForLabelcomCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10,0, 28)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#C2680E"] colorWithAlphaComponent:0.05];
        backView.layer.cornerRadius = 14;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        self.backV = backView;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 20, 20)];
        [backView addSubview:self.iconImageView];
  
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(34,0, 0, 28)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#C2680E"];
        [backView addSubview:self.numL];

    }
    return self;
}

- (void)setModel:(NoticeComLabelModel *)model{
    _model = model;
    self.backV.frame = CGRectMake(0, 10, model.showStrWidth+20+4+20, 28);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    self.numL.frame = CGRectMake(34, 0, model.showStrWidth, 28);
    self.numL.text = model.showStr;
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
