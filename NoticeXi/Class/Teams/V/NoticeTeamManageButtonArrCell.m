//
//  NoticeTeamManageButtonArrCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamManageButtonArrCell.h"
#import "UIView+CLSetRect.h"
@implementation NoticeTeamManageButtonArrCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //昵称
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(35, 0,DR_SCREEN_WIDTH-70, 50)];
        _titleL.font = EIGHTEENTEXTFONTSIZE;
        _titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:_titleL];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [_titleL setAllCorner:25];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
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
