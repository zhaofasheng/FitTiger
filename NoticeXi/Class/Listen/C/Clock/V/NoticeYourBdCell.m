//
//  NoticeYourBdCell.m
//  NoticeXi
//
//  Created by li lei on 2020/4/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeYourBdCell.h"

@implementation NoticeYourBdCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat space = (DR_SCREEN_WIDTH-150)/6;
        UILabel *yourl = [[UILabel alloc] initWithFrame:CGRectMake(space,0, 30,83)];
        yourl.font = TWOTEXTFONTSIZE;
        yourl.text = @"你的";
        yourl.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:yourl];
        for (int i = 0; i < 4; i++) {
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(space*2+30+(space+30)*i-10,0,50,83)];
            numL.textColor = GetColorWithName(VDarkTextColor);
            numL.font = TWOTEXTFONTSIZE;
            numL.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:numL];
            if (i == 0) {
                self.tsLabel = numL;
            }else if (i == 1){
                self.mgLabel = numL;
            }else if (i == 2){
                self.shLabel = numL;
            }else{
                self.tcLabel = numL;
            }
        }
    }
    return self;
}

- (void)setSelfBd:(NoticeClockBdModel *)selfBd{
    _selfBd = selfBd;
    self.tsLabel.text = selfBd.num1.intValue?[NSString stringWithFormat:@"%@票",selfBd.num1]:@"";
    self.mgLabel.text = selfBd.num2.intValue?[NSString stringWithFormat:@"%@票",selfBd.num2]:@"";
    self.shLabel.text = selfBd.num3.intValue?[NSString stringWithFormat:@"%@票",selfBd.num3]:@"";
    self.tcLabel.text = selfBd.dubbing_num.intValue?[NSString stringWithFormat:@"%@配",selfBd.dubbing_num]:@"";
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
