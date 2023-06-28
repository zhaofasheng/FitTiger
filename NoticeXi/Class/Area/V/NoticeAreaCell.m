//
//  NoticeAreaCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAreaCell.h"

@implementation NoticeAreaCell
{
    UILabel *_areaL;
    UILabel *_numL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _areaL = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, (DR_SCREEN_WIDTH-30)/2, 45)];
        _areaL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _areaL.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:_areaL];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_areaL.frame), 0, (DR_SCREEN_WIDTH-30)/2, 45)];
        _numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _numL.textAlignment = NSTextAlignmentRight;
        _numL.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:_numL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setModel:(NoticeAreaModel *)model{
    _areaL.text = model.area_name;
    _numL.text = [NSString stringWithFormat:@"+%@",model.phone_code];
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
