//
//  NoticeVoiceReadHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadHeaderView.h"

@implementation NoticeVoiceReadHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 84, 123)];
        self.coverImageView.layer.cornerRadius = 4;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self addSubview:self.coverImageView];
        
        self.nameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame)+5, 40,DR_SCREEN_WIDTH-84-5-20, 22)];
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:self.nameL];
        
        self.contentL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.coverImageView.frame)+5, 40+25,DR_SCREEN_WIDTH-84-5-20, 22)];
        self.contentL.font = TWOTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.contentL];
    }
    return self;
}
- (void)setReadModel:(NoticeVoiceReadModel *)readModel{
    _readModel = readModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:readModel.cover_url]];
    self.nameL.text = readModel.title;
    self.contentL.text = readModel.type.intValue==2?readModel.show_at: readModel.author;
}
@end
