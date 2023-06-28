//
//  NoticeCustumButtonInToView.m
//  NoticeXi
//
//  Created by li lei on 2021/7/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumButtonInToView.h"

@implementation NoticeCustumButtonInToView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 380+96)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 10;
        self.keyView.layer.masksToBounds = YES;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, DR_SCREEN_WIDTH, 28)];
        titleL.font = XGTwentyBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        titleL.text = [NoticeTools getLocalStrWith:@"main.setQuickButton"];
        titleL.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:titleL];
        
        UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame)+6, DR_SCREEN_WIDTH, 17)];
        subL.textAlignment = NSTextAlignmentCenter;
        subL.font = TWOTEXTFONTSIZE;
        subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        subL.text = [NoticeTools getLocalStrWith:@"main.quickButtonIntro"];
        [self.keyView addSubview:subL];
        
        self.currentButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-44)/2, CGRectGetMaxY(subL.frame)+23, 44, 44)];
        [self.currentButton setBackgroundImage:UIImageNamed(@"Image_custumebtn") forState:UIControlStateNormal];
        [self.keyView addSubview:self.currentButton];
        
        UIImageView *leadImgV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-15)/2,CGRectGetMaxY(self.currentButton.frame)+16, 15, 19)];
        leadImgV.image = UIImageNamed(@"Image_leadch");
        [self.keyView addSubview:leadImgV];
        
        NSArray *arr = @[[NoticeTools getLocalStrWith:@"main.group"],[NoticeTools getLocalStrWith:@"main.py"],[NoticeTools getLocalStrWith:@"main.textGround"],[NoticeTools getLocalStrWith:@"main.book"],[NoticeTools getLocalStrWith:@"main.movie"],[NoticeTools getLocalStrWith:@"main.song"],[NoticeTools getLocalStrWith:@"listen.draw"],[NoticeTools getLocalStrWith:@"liten.bk"],[NoticeTools getLocalStrWith:@"listen.whiteVoice"]];
        self.imgArr = [[NSMutableArray alloc] init];
        CGFloat space = (DR_SCREEN_WIDTH-69*5)/2;
        for (int i = 0; i < 9; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(space+69*i, CGRectGetMaxY(self.currentButton.frame)+53, 69, 80)];
            if (i > 4) {
                tapView.frame = CGRectMake(space+69*(i-5), CGRectGetMaxY(self.currentButton.frame)+53+80, 69, 80);
            }
            tapView.userInteractionEnabled = YES;
            tapView.tag = i+1;
            [self.keyView addSubview:tapView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 14, 32, 32)];
            NSString *imgName = [NSString stringWithFormat:@"Image_fast%d",i];
            imageView.image = UIImageNamed(imgName);
            [tapView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+2, 69, 20)];
            label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = arr[i];
            [tapView addSubview:label];
            
            UIImageView *choiceImg = [[UIImageView alloc] initWithFrame:CGRectMake(51, 0, 16, 16)];
            choiceImg.image = UIImageNamed(@"Image_nochoicesh");
            [tapView addSubview:choiceImg];
            [self.imgArr addObject:choiceImg];
        }
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.keyView.frame.size.height-50-35, (DR_SCREEN_WIDTH-60)/2, 35)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        cancelBtn.layer.cornerRadius = 8;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
        cancelBtn.layer.borderWidth = 1;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame)+20, self.keyView.frame.size.height-50-35, (DR_SCREEN_WIDTH-60)/2, 35)];
        [sureBtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        sureBtn.layer.cornerRadius = 8;
        sureBtn.layer.masksToBounds = YES;
        [self.keyView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
    }
    return self;
}


- (void)choiceTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (self.type == tapV.tag) {
        self.type = 0;
    }else{
        self.type = tapV.tag;
        [self.moveImageView removeFromSuperview];
        self.moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tapV.frame.origin.x+19, tapV.frame.origin.y+14, 32, 32)];
        NSString *imgName = [NSString stringWithFormat:@"Image_fast%ld",self.type-1];
        self.moveImageView.image = UIImageNamed(imgName);
        [self.keyView addSubview:self.moveImageView];
        [UIView animateWithDuration:0.3 animations:^{
            self.moveImageView.frame = self.currentButton.frame;
        } completion:^(BOOL finished) {
            [self.moveImageView removeFromSuperview];
            if (self.type) {
                NSString *imgName = [NSString stringWithFormat:@"Image_fast%ld",self.type-1];
                [self.currentButton setBackgroundImage:UIImageNamed(imgName) forState:UIControlStateNormal];
            }else{
                [self.currentButton setBackgroundImage:UIImageNamed(@"Image_custumebtn") forState:UIControlStateNormal];
            }
        }];
    }
        
    for (int i = 0; i < self.imgArr.count; i++) {
        UIImageView *choiceImg = self.imgArr[i];
        if (self.type) {
            if (i == self.type-1) {
                choiceImg.image = UIImageNamed(@"Image_choicesh");
            }else{
                choiceImg.image = UIImageNamed(@"Image_nochoicesh");
            }
        }else{
            choiceImg.image = UIImageNamed(@"Image_nochoicesh");
        }
    }
}

- (void)showShareView{
    
    if ([NoticeTools getFastButton]) {
        NSString *imgName = [NSString stringWithFormat:@"Image_fast%ld",[NoticeTools getFastButton]-1];
        [self.currentButton setBackgroundImage:UIImageNamed(imgName) forState:UIControlStateNormal];
    }else{
        [self.currentButton setBackgroundImage:UIImageNamed(@"Image_custumebtn") forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < self.imgArr.count; i++) {
        UIImageView *choiceImg = self.imgArr[i];
        if ([NoticeTools getFastButton]) {
            if (i == [NoticeTools getFastButton]-1) {
                choiceImg.image = UIImageNamed(@"Image_choicesh");
            }else{
                choiceImg.image = UIImageNamed(@"Image_nochoicesh");
            }
        }else{
            choiceImg.image = UIImageNamed(@"Image_nochoicesh");
        }
    }
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+10, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureClick{
    [NoticeTools setfastButtonWith:self.type];
    if (self.clickvoiceBtnBlock) {
        self.clickvoiceBtnBlock(self.type);
    }
    [self cancelClick];
}
@end
