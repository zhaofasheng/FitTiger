//
//  NoticeClockDaysCell.m
//  NoticeXi
//
//  Created by li lei on 2019/11/5.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockDaysCell.h"

@implementation NoticeClockDaysCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dayL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 60, 63)];
        self.dayL.textColor = GetColorWithName(VMainTextColor);
        self.dayL.font = XGFifthBoldFontSize;
        [self.contentView addSubview:self.dayL];
        
        self.seleImageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-35-22, (63-22)/2, 22, 22)];
        [self.contentView addSubview:self.seleImageVeiw];
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
