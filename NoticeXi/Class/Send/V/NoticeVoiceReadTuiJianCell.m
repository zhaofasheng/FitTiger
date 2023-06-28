//
//  NoticeVoiceReadTuiJianCell.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadTuiJianCell.h"

@implementation NoticeVoiceReadTuiJianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 84, 103)];
        self.coverImageView.layer.cornerRadius = 4;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        self.nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+8,100, 22)];
        self.nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.nameL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.nameL];
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame)+15, 0, DR_SCREEN_WIDTH-40-84-15, 103)];
        backView.image = UIImageNamed(@"Image_readingtextbak");
        [self.contentView addSubview:backView];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, backView.frame.size.width, 83)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.contentL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:self.contentL];
        self.contentL.numberOfLines = 0;
        
        UIButton *readButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-66, CGRectGetMaxY(backView.frame)+8, 66, 24)];
        readButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        readButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        readButton.layer.cornerRadius = 3;
        readButton.layer.masksToBounds = YES;
        [readButton setTitle:[NoticeTools getLocalStrWith:@"luy.langdu"] forState:UIControlStateNormal];
        [readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [readButton addTarget:self action:@selector(readClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:readButton];

    }
    return self;
}

- (void)setReadModel:(NoticeVoiceReadModel *)readModel{
    _readModel = readModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:readModel.cover_url]];
    NSString *str = [NSString stringWithFormat:@"%@ %@",readModel.title, readModel.type.intValue == 2?readModel.show_at:readModel.author];
    self.nameL.attributedText = [DDHAttributedMode setSizeAndColorString:str setColor:[UIColor colorWithHexString:@"#25262E"] setSize:16 setLengthString:readModel.title beginSize:0];
    
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
