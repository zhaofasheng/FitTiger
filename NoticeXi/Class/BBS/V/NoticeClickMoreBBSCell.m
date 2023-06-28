//
//  NoticeClickMoreBBSCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeClickMoreBBSCell.h"

@implementation NoticeClickMoreBBSCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        [btn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [btn setTitle:[NoticeTools getLocalStrWith:@"zj.creat"] forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:btn];
        btn.enabled = NO; 
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
