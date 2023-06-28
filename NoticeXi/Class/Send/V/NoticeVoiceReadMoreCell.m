//
//  NoticeVoiceReadMoreCell.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadMoreCell.h"

@implementation NoticeVoiceReadMoreCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 100, 123)];
        self.coverImageView.layer.cornerRadius = 4;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        self.nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+8,100, 22)];
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nameL];
        
        self.contentL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameL.frame), 100, 20)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.contentL];
        
    }
    return self;
}

- (void)setReadModel:(NoticeVoiceReadModel *)readModel{
    _readModel = readModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:readModel.cover_url]];
    self.nameL.text = readModel.title;
    self.contentL.text =readModel.type.intValue==2?readModel.show_at: readModel.author;
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
