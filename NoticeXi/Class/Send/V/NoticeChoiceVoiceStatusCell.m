//
//  NoticeChoiceVoiceStatusCell.m
//  NoticeXi
//
//  Created by li lei on 2022/1/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceVoiceStatusCell.h"

@implementation NoticeChoiceVoiceStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        
        self.mainL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 20)];
        self.mainL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.mainL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.mainL];
        
        self.subL = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, DR_SCREEN_WIDTH-40, 17)];
        self.subL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.subL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.subL];
        
        self.subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, 17, 24, 24)];
        self.subImageV.image = UIImageNamed(@"Image_signmark_b");
        [self.contentView addSubview:self.subImageV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 57, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self.contentView addSubview:line];
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
