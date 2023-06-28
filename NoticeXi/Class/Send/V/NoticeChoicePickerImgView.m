//
//  NoticeChoicePickerImgView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoicePickerImgView.h"

@implementation NoticeChoicePickerImgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, -252, DR_SCREEN_WIDTH,232)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
        self.keyView.userInteractionEnabled = YES;
        
        for (int i = 0; i < 2; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-185)/2+125*i, self.keyView.frame.size.height-72-20-8-60, 60, 88)];
            tapView.tag = i;
            [self.keyView addSubview:tapView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funTap:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            NSString *name = [NSString stringWithFormat:@"lyPickerimg%d",i];
            imageV.image = UIImageNamed(name);
            [tapView addSubview:imageV];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+8, 60, 20)];
            label.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textAlignment = NSTextAlignmentCenter;
            if (i==0) {
                label.text = [NoticeTools getLocalStrWith:@"luy.looksay"];
            }else{
                label.text = [NoticeTools getLocalStrWith:@"luy.lookspeaker"];
            }
            [tapView addSubview:label];
        }

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)disMissTap{
    self.keyView.frame =  CGRectMake(0, -252, DR_SCREEN_WIDTH,232);
    [self removeFromSuperview];
}

- (void)funTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    self.keyView.frame =  CGRectMake(0, -252, DR_SCREEN_WIDTH,232);
    [self removeFromSuperview];
    if (self.typeChoiceBlock) {
        self.typeChoiceBlock(tapV.tag==0?YES:NO);
    }
}

- (void)show{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, -20, DR_SCREEN_WIDTH, 232);
    }];
}


@end
