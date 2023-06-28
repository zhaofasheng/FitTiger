//
//  NoticePhotoNavView.m
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoNavView.h"

@implementation NoticePhotoNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#252525"] colorWithAlphaComponent:0.5];
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
        _backButton = backBtn;
        [self addSubview:backBtn];
        
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-backBtn.frame.size.width, STATUS_BAR_HEIGHT,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [saveBtn setImage:UIImageNamed(@"self_card_chimg") forState:UIControlStateNormal];
        _saveButton = saveBtn;
        [self addSubview:saveBtn];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.textColor = [UIColor whiteColor];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = FOURTHTEENTEXTFONTSIZE;
        [self addSubview:self.timeL];
        
        self.numL = [[UILabel alloc] init];
        self.numL.textColor = [UIColor whiteColor];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.font = [UIFont systemFontOfSize:9];
        [self addSubview:self.numL];
    }
    return self;
}

- (void)setImgModel:(NoticeSmallArrModel *)imgModel{
    _imgModel = imgModel;
    if (imgModel.imgsCount.integerValue > 1) {
        self.timeL.frame = CGRectMake(CGRectGetMaxX(_backButton.frame), STATUS_BAR_HEIGHT+8, DR_SCREEN_WIDTH-CGRectGetMaxX(_backButton.frame)*2, 14);
        self.numL.frame = CGRectMake(self.timeL.frame.origin.x,CGRectGetMaxY(self.timeL.frame)+7, self.timeL.frame.size.width, 9);
        self.numL.hidden = NO;
    }else{
        self.numL.hidden = YES;
        self.timeL.frame = CGRectMake(CGRectGetMaxX(_backButton.frame), STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-CGRectGetMaxX(_backButton.frame)*2,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    }
    self.timeL.text = imgModel.currentModel.photoTime;
    self.numL.text = [NSString stringWithFormat:@"%@/%@",imgModel.currentCount,imgModel.imgsCount];
}

@end
