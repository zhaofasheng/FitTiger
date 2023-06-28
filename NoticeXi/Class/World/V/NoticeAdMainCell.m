//
//  NoticeAdMainCell.m
//  NoticeXi
//
//  Created by li lei on 2022/1/14.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeAdMainCell.h"

@implementation NoticeAdMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 92)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 72)];
        [backView addSubview:self.coverImageView];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.layer.cornerRadius = 2;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.clipsToBounds = YES;
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.textColor = [UIColor whiteColor];
        self.numL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.numL.font = [UIFont systemFontOfSize:9];
        [self.coverImageView addSubview:self.numL];
        self.numL.layer.cornerRadius = 7;
        self.numL.layer.masksToBounds = YES;
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(142, 15, 150, 22)];
        self.nameL.font = XGSIXBoldFontSize;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.nameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(142, 43,backView.frame.size.width-5-142,36)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.numberOfLines = 2;
        self.contentL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.contentL];
    }
    return self;
}

- (void)setModel:(NoticeWriteRecodModel *)model{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    if (model.show_type.intValue == 3 && model.num.intValue) {
        self.numL.hidden = NO;
        self.numL.text = model.num;
    }else{
        self.numL.hidden = YES;
    }
    self.nameL.text = model.title;
    self.contentL.text = model.desc;
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
