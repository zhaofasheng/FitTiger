//
//  NoticeReadHeJiCell.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadHeJiCell.h"

@implementation NoticeReadHeJiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 120)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, backView.frame.size.width-20, 80)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.contentL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.contentL];
        
        UIButton *readButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-66-6, 6, 66, 24)];
        readButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        readButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        readButton.layer.cornerRadius = 3;
        readButton.layer.masksToBounds = YES;
        [readButton setTitle:[NoticeTools getLocalStrWith:@"luy.langdu"] forState:UIControlStateNormal];
        [readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [readButton addTarget:self action:@selector(readClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:readButton];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 100, 20)];
        self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        [backView addSubview:self.numL];
    }
    return self;
}

- (void)setReadModel:(NoticeVoiceReadModel *)readModel{
    _readModel = readModel;
    
    self.contentL.attributedText = readModel.fourAttTextStr;
    self.contentL.textAlignment = NSTextAlignmentCenter;
    self.contentL.numberOfLines = 0;
}

- (void)readClick{
    if (self.readingBlock) {
        self.readingBlock(self.readModel);
    }
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
