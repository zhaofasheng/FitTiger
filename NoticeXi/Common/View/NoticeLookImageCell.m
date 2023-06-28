//
//  NoticeLookImageCell.m
//  NoticeXi
//
//  Created by li lei on 2020/12/28.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeLookImageCell.h"

@implementation NoticeLookImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.looKImageView = [[YYAnimatedImageView alloc] init];
        [self.contentView addSubview:self.looKImageView];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-70, 305+BOTTOM_HEIGHT)];
        self.backView.backgroundColor = GetColorWithName(VBackColor);
        [self.contentView addSubview:self.backView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-61, 10, 61, 20)];
        self.nameL.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        self.nameL.textColor = [NoticeTools getWhiteColor:@"#ffffff" NightColor:@"#b2b2b2"];
        self.nameL.font = ELEVENTEXTFONTSIZE;
        self.nameL.textAlignment = NSTextAlignmentCenter;
        self.nameL.layer.cornerRadius = 10;
        self.nameL.layer.masksToBounds = YES;
        if (![NoticeTools isWhiteTheme]) {
            self.nameL.layer.borderWidth = 1;
            self.nameL.layer.borderColor = [UIColor colorWithHexString:@"#b2b2b2"].CGColor;
        }
        [self.backView addSubview:self.nameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.backView.frame.size.width-20, self.backView.frame.size.height-20)];
        self.contentL.textColor = GetColorWithName(VMainTextColor);
        [self.backView addSubview:self.contentL];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:self.line];
        
        self.name1L = [[UILabel alloc] initWithFrame:CGRectMake(self.looKImageView.frame.size.width-10-61, 10, 61, 20)];
        self.name1L.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        self.name1L.textColor = [NoticeTools getWhiteColor:@"#ffffff" NightColor:@"#b2b2b2"];
        self.name1L.font = ELEVENTEXTFONTSIZE;
        self.name1L.text = @"沉浸感";
        self.name1L.textAlignment = NSTextAlignmentCenter;
        self.name1L.layer.cornerRadius = 10;
        self.name1L.layer.masksToBounds = YES;
        if (![NoticeTools isWhiteTheme]) {
            self.name1L.layer.borderWidth = 1;
            self.name1L.layer.borderColor = [UIColor colorWithHexString:@"#b2b2b2"].CGColor;
        }
        [self.looKImageView addSubview:self.name1L];
        
//        self.lookImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.backView.frame.size.height-BOTTOM_HEIGHT-20-40, 40, 40)];
//        [self.lookImageBtn setBackgroundImage:UIImageNamed(@"Image_lookImageTo") forState:UIControlStateNormal];
//        [self.backView addSubview:self.lookImageBtn];
//        self.lookImageBtn.hidden = YES;
//        [self.lookImageBtn addTarget:self action:@selector(gotoImage) forControlEvents:UIControlEventTouchUpInside];
//        
//        self.looKImageView.userInteractionEnabled = YES;
//        self.goFirstBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.backView.frame.size.height-BOTTOM_HEIGHT-20-40, 40, 40)];
//        [self.goFirstBtn setBackgroundImage:UIImageNamed(@"Image_gotofirst") forState:UIControlStateNormal];
//        [self.looKImageView addSubview:self.goFirstBtn];
//        self.goFirstBtn.hidden = YES;
//        [self.goFirstBtn addTarget:self action:@selector(gotoFirst) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)gotoFirst{
    if (self.goFirstBlock) {
        self.goFirstBlock(YES);
    }
}

- (void)gotoImage{
    if (self.gotImageBlock) {
        self.gotImageBlock(YES);
    }
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if (_index < 15) {
        self.backView.hidden = NO;
        self.looKImageView.hidden = YES;
    }else{
        self.looKImageView.hidden = NO;
        self.backView.hidden = YES;
    }
    self.lookImageBtn.hidden = (index == 1?NO:YES);
    self.goFirstBtn.hidden = (index == 18?NO:YES);
}

- (void)setQuestionM:(NoticeBackQustionModel *)questionM{
    _questionM = questionM;
    self.nameL.text = questionM.name;
    self.contentL.attributedText = questionM.contentAtt;
    self.contentL.textAlignment = NSTextAlignmentCenter;
    self.contentL.numberOfLines = 0;
    if (self.index < 15 && [NoticeTools isWhiteTheme]) {
        self.nameL.backgroundColor = [[UIColor colorWithHexString:questionM.color] colorWithAlphaComponent:0.3];
        self.nameL.textColor = [UIColor whiteColor];
    }else{
        self.nameL.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        self.nameL.textColor = [NoticeTools getWhiteColor:@"#ffffff" NightColor:@"#b2b2b2"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
