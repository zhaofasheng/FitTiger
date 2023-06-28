//
//  NoticeTagChoiceView.m
//  NoticeXi
//
//  Created by li lei on 2020/5/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTagChoiceView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeTagChoiceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-88, NAVIGATION_BAR_HEIGHT, 88, 80)];
        imageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_paixub_b":@"Image_paixub_y");
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        NSArray *arr = @[@"最早优先",@"最新优先"];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10+30*i, 88, 30)];
            btn.titleLabel.font = THRETEENTEXTFONTSIZE;
            btn.tag = i;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            if ( i == 0) {
                self.firstBtn = btn;
            }else{
                self.secBtn = btn;
            }
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.firstBtn.frame), 68, 1)];
        line.backgroundColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#72727F"];
        [imageView addSubview:line];
    }
    return self;
}

- (void)setIsNew:(BOOL)isNew{
    _isNew = isNew;
    if (isNew) {
        [self.secBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        [self.firstBtn setTitleColor:[NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"] forState:UIControlStateNormal];
    }else{
        [self.firstBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        [self.secBtn setTitleColor:[NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"] forState:UIControlStateNormal];
    }
}

- (void)choiceClick:(UIButton *)button{
    if (self.isNew && button.tag == 1) {
        [self dissMiss];
        return;
    }
    
    if (!self.isNew && button.tag == 0) {
        [self dissMiss];
        return;
    }
    
    if (self.newBlock) {
        self.newBlock(button.tag == 0? NO:YES);
    }
    [self dissMiss];
}

- (void)dissMiss{
    [self removeFromSuperview];
}

- (void)showTostView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

@end
