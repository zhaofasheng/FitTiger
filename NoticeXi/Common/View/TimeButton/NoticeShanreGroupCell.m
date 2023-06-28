//
//  NoticeShanreGroupCell.m
//  NoticeXi
//
//  Created by li lei on 2020/10/21.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeShanreGroupCell.h"

@implementation NoticeShanreGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 96)];
        [self.contentView addSubview:self.backView];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        
        self.groupL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 96)];
        self.groupL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.groupL.font = XGEightBoldFontSize;
        self.groupL.numberOfLines = 0;
        self.groupL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.groupL];
        
        self.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
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
