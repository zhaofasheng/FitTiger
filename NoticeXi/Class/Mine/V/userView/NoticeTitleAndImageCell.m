//
//  NoticeTitleAndImageCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTitleAndImageCell.h"

@implementation NoticeTitleAndImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(20,0,270, 55)];
        _mainL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _mainL.font = XGFifthBoldFontSize;
        [self.contentView addSubview:_mainL];
        
        _subL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-130, 0,130, 55)];
        _subL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        _subL.font = FOURTHTEENTEXTFONTSIZE;
        _subL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subL];
        
        _subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-11-24, 15, 24, 24)];
        _subImageV.image = UIImageNamed(@"cellnextbutton");
        [self.contentView addSubview:_subImageV];
        
        _leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(86, 6, 44, 44)];
        _leftImageV.contentMode = UIViewContentModeScaleAspectFit;
        _leftImageV.layer.cornerRadius = 3;
        _leftImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_leftImageV];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20,55, DR_SCREEN_WIDTH-20, 1)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        _line = line;
        [self.contentView addSubview:line];
        
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH([NoticeTools getLocalStrWith:@"groupManager.del"], 14, 65)-GET_STRWIDTH([NoticeTools getLocalStrWith:@"mineme.sendre"], 14, 65)-15-15, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"mineme.sendre"], 14, 65), 55)];
        [self.sendButton setTitleColor:[UIColor colorWithHexString: WHITEMAINCOLOR] forState:UIControlStateNormal];
        [self.sendButton setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"mineme.sendre"]:@"再發布" forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.sendButton];
        [self.sendButton addTarget:self action:@selector(sendCacheClick) forControlEvents:UIControlEventTouchUpInside];
        self.sendButton.hidden = YES;
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH([NoticeTools getLocalStrWith:@"groupManager.del"], 14, 65)-15, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.send"], 14, 65), 55)];
        [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        [self.deleteButton setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"groupManager.del"]:@"刪除" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton addTarget:self action:@selector(deleCacheClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.hidden = YES;
    }
    return self;
}

- (void)setIsSmallHeight:(BOOL)isSmallHeight{
    _isSmallHeight = isSmallHeight;
    if (isSmallHeight) {
        _mainL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
}

- (void)sendCacheClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendVoiceWith:)]) {
        [self.delegate sendVoiceWith:self.index];
    }
}
- (void)deleCacheClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVoiceWith:)]) {
        [self.delegate deleteVoiceWith:self.index];
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
