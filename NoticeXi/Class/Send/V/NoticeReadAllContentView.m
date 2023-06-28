//
//  NoticeReadAllContentView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadAllContentView.h"

@implementation NoticeReadAllContentView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        

        self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, self.frame.size.height-NAVIGATION_BAR_HEIGHT)];
        [self addSubview:self.backView];
        self.backView.showsVerticalScrollIndicator = NO;
        self.backView.showsHorizontalScrollIndicator = NO;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH-40, 28)];
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleL.font = XGEightBoldFontSize;
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.titleL];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(0,40,DR_SCREEN_WIDTH-40, 20)];
        self.nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.nameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(0,100,DR_SCREEN_WIDTH-40, 0)];
        self.contentL.font = EIGHTEENTEXTFONTSIZE;
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.contentL];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setReadModel:(NoticeVoiceReadModel *)readModel{
    _readModel = readModel;
    self.contentL.frame = CGRectMake(0,100, DR_SCREEN_WIDTH-40, readModel.textHeight);
    self.titleL.text = readModel.title;
    self.nameL.text = readModel.author;
    self.contentL.attributedText = readModel.allTextAttStr;
    self.contentL.numberOfLines = 0;
    self.contentL.textAlignment = NSTextAlignmentCenter;
    self.backView.contentSize = CGSizeMake(0, readModel.textHeight+100+NAVIGATION_BAR_HEIGHT);
    [self.backView setContentOffset:CGPointMake(self.backView.contentOffset.x, 0)
        animated:NO];
}

- (void)refreshUI{
    self.backView.frame = CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, self.frame.size.height-NAVIGATION_BAR_HEIGHT);
}

- (void)setIsRecoder:(BOOL)isRecoder{
    _isRecoder = isRecoder;
    if (isRecoder) {
        self.disBtn.hidden = NO;
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-30)/2, 52, 30)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#F7F8FC"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        cancelBtn.layer.cornerRadius = 3;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _disBtn = cancelBtn;
        [self bringSubviewToFront:_disBtn];
    }
}

- (void)disTap{
    if (self.isRecoder) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    [CoreAnimationEffect animationEaseOut:self];
    self.hidden = YES;
}

- (void)cancelClick{
    [CoreAnimationEffect animationEaseOut:self];
    if (!self.isRecoder) {
        self.hidden = YES;
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    if (self.cancelBlock) {
        self.cancelBlock(YES);
    }
}

@end
