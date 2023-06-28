//
//  NoticeChoiceRecoderView.m
//  NoticeXi
//
//  Created by li lei on 2020/8/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceRecoderView.h"

@implementation NoticeChoiceRecoderView

- (instancetype)initWithShowChoiceSendType{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        [self addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self addSubview:imageView];
        imageView.image = UIImageNamed(@"Image_recbackimg");
        self.backImageView = imageView;
        self.backImageView.hidden = YES;
        
        UIImageView *recoderImageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-58-30)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-58-20, 58+30, 58+30)];
        [imageView addSubview:recoderImageV];
        recoderImageV.image = UIImageNamed(@"Image_recbackimgsmal");
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30-270, 315, 270)];
        contentView.backgroundColor = GetColorWithName(VBackColor);
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        self.contentView = contentView;
        [self addSubview:contentView];
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent)];
        [contentView addGestureRecognizer:contentTap];
        
        NSArray *arr = [NoticeTools isWhiteTheme]?@[@"Image_cr1_b",@"Image_cr2_b",@"Image_cr3_b"]:@[@"Image_cr1_y",@"Image_cr2_y",@"Image_cr3_y"];
        for (int i = 0; i < 3; i++) {
            UIImageView *markImagV = [[UIImageView alloc] initWithFrame:CGRectMake(67, 30+80*i, 50, 50)];
            markImagV.image = UIImageNamed(arr[i]);
            [self.contentView addSubview:markImagV];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markImagV.frame)+15, markImagV.frame.origin.y, 182,50)];
            label.font = [UIFont systemFontOfSize:17];
            label.textColor = GetColorWithName(VMainTextColor);
            [self.contentView addSubview:label];
            
            if (i == 1) {
                NSString *str = [NoticeTools getTextWithSim:@"深度整理" fantText:@"深度整理"];
                label.text = str;
                label.frame = CGRectMake(CGRectGetMaxX(markImagV.frame)+15, markImagV.frame.origin.y+7, 182,17);
                UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markImagV.frame)+15, CGRectGetMaxY(label.frame)+7, 182, 13)];
                subL.textColor = GetColorWithName(VDarkTextColor);
                subL.font = THRETEENTEXTFONTSIZE;
                subL.text = [NoticeTools getTextWithSim:@"不可共享到操场" fantText:@"不可共享到操場"];
                [self.contentView addSubview:subL];
            }else if (i == 0){
                NSString *str = [NoticeTools getTextWithSim:@"快速整理" fantText:@"快速整理"];
                label.text = str;
            }else{
                label.text = [NoticeTools isSimpleLau]?@"文字整理":@"文字整理";
            }
            
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, markImagV.frame.origin.y,315, 50)];
            tapView.tag = i;
            tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            [self.contentView addSubview:tapView];
            
            tapView.userInteractionEnabled = YES;
            UITapGestureRecognizer *funTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funTapWith:)];
            [tapView addGestureRecognizer:funTap];
        }
    }
    return self;
}

- (void)funTapWith:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (self.choiceTag) {
        self.choiceTag(tapV.tag);
    }
    [self dissMissView];
}

- (void)dissMissView{
    [self removeFromSuperview];
}

- (void)showChoiceView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}
- (void)tapContent{
    
}

@end
