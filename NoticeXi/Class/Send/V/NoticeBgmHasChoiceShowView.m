//
//  NoticeBgmHasChoiceShowView.m
//  NoticeXi
//
//  Created by li lei on 2022/4/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBgmHasChoiceShowView.h"

@implementation NoticeBgmHasChoiceShowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.nameView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 0, 20)];
        self.nameView.backgroundColor = [[UIColor colorWithHexString:@"#DD9B57"] colorWithAlphaComponent:0.2];
        self.nameView.layer.cornerRadius = 10;
        self.nameView.layer.masksToBounds = YES;
        
        [self addSubview:self.nameView];
        

        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 12, 12)];
        self.markImageView.image = UIImageNamed(@"ly_moon");
        [self.nameView addSubview:self.markImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0,20)];
        self.nameL.font = ELEVENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#A0784F"];
        [self.nameView addSubview:self.nameL];
 
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20)];
        [self.closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
        [self addSubview:self.closeBtn];
    }
    return self;
}

- (void)setIsReedit:(BOOL)isReedit{
    _isReedit = isReedit;
    if (isReedit) {
        self.closeBtn.hidden = YES;
        self.nameView.backgroundColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:0.1];
        self.nameL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.markImageView.image = UIImageNamed(@"ly_moonn");
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.nameL.text = title;
    if(self.isaddSend){
        self.nameL.font = TWOTEXTFONTSIZE;
        self.markImageView.frame = CGRectMake(0, 2, 16, 16);
        self.nameL.frame = CGRectMake(20, 0, GET_STRWIDTH(self.nameL.text, 12, 20), 20);
        self.nameView.frame = CGRectMake(self.isShow?0: 15, 0, self.nameL.frame.size.width+10+20, 20);
        self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20);
    }else{
        self.nameL.frame = CGRectMake(20, 0, GET_STRWIDTH(self.nameL.text, 11, 20), 20);
        self.nameView.frame = CGRectMake(self.isShow?0: 15, 0, self.nameL.frame.size.width+10+20, 20);
        self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.nameView.frame)+12, 0, 20, 20);
    }
}


@end
