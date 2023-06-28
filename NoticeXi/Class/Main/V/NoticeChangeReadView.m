//
//  NoticeChangeReadView.m
//  NoticeXi
//
//  Created by li lei on 2019/3/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeReadView.h"
#import "NoticeCustumButton.h"
@implementation NoticeChangeReadView
{
    NSMutableArray *_buttonArr1;
    NSMutableArray *_buttonArr2;
    CAEmitterLayer * rainEmitterLayer;
    CAEmitterCell * rainCell;
    CGPoint animationPoint;
    UILabel *_titL;
    UILabel *_headeL1;
    UILabel *_headeL2;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEMCOLORNOTICATION" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"CHANGETHEMCOLORNOTICATION" object:nil];
        //  动画缩放开始的点
        animationPoint = CGPointMake(0, 0);
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 358+STATUS_BAR_HEIGHT)];
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.contentView];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0,self.contentView.frame.size.height, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.contentView.frame.size.height)];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.userInteractionEnabled = YES;
        [self addSubview:tapView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissShadowView)];
        [tapView addGestureRecognizer:tap];
        
        UILabel *headL = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+35, DR_SCREEN_WIDTH, 22)];
        headL.textAlignment = NSTextAlignmentCenter;
        headL.font = XGTwentyTwoBoldFontSize;
        headL.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        headL.text = GETTEXTWITE(@"sx3.1.setcj");
        _titL = headL;
        [self.contentView addSubview:headL];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(headL.frame)+25, DR_SCREEN_WIDTH-20, 13)];
        label1.font = THRETEENTEXTFONTSIZE;
        label1.textColor =  [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        label1.text = [NoticeTools isSimpleLau] ? @"白天/夜间" : @"白天/夜間:";
        [self.contentView addSubview:label1];
        _headeL1 = label1;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label1.frame)+85, DR_SCREEN_WIDTH-20, 13)];
        label2.font = THRETEENTEXTFONTSIZE;
        label2.textColor =  [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        label2.text = [NoticeTools isSimpleLau] ? @"气氛" : @"氣氛:";
        [self.contentView addSubview:label2];
        _headeL2 = label2;
        
        _buttonArr1 = [NSMutableArray new];
        _buttonArr2 = [NSMutableArray new];
        
        NSArray *imgA1 = @[@"Image_ms_white",@"Image_ms_night"];
        NSArray *imgAy = @[@"Image_ms_whiteye",@"Image_ms_nightye"];
        NSArray *titl1 = @[@"白昼",@"夜晚"];
        for (int i = 0; i < 2; i++) {
            NoticeCustumButton *button = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(20+(45+42+40)*i, CGRectGetMaxY(label1.frame)+20, 45+42, 45)];
            [button setImageView: [NoticeTools isWhiteTheme]? imgA1[i]:imgAy[i] label:titl1[i]];
            button.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeWH:)];
            [button addGestureRecognizer:tap];
            [self.contentView addSubview:button];
            [_buttonArr1 addObject:button];
            
            if ([NoticeTools isWhiteTheme]) {
                if (i == 0) {
                    button.isSelect = YES;
                }
                if (i == 1) {
                    button.isSelect = NO;
                }
            }else{
                if (i == 1) {
                    button.isSelect = YES;
                }
                if (i == 0) {
                    button.isSelect = NO;
                }
                
            }
        }
        
        NSArray *imgA2 = @[@"ll_img1",@"ll_img2",@"ll_img3",@"ll_img4",@"ll_img5",@"ll_img6"];
        NSArray *imgA3 = @[@"ll_imgye1",@"ll_imgye2",@"ll_imgye3",@"ll_imgye4",@"ll_imgye5",@"ll_imgye6"];
        //NSArray *titl2 = @[[NoticeTools isSimpleLau] ?@"无":@"無",@"雨",@"雪",[NoticeTools isSimpleLau] ?@"叶":@"葉",@"花",[NoticeTools isWhiteTheme]?@"枫":@"楓"];
        for (int j = 0; j < 3; j++) {
            NoticeCustumButton *button = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(20+(45+42+40)*j, CGRectGetMaxY(label2.frame)+20, 45+42, 45)];
            [button setImageView:[NoticeTools isWhiteTheme] ?imgA2[j] : imgA3[j] label:@""];
            button.tag = j;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLL:)];
            [button addGestureRecognizer:tap];
            [self.contentView addSubview:button];
            [_buttonArr2 addObject:button];
        }
        
        for (int k = 0; k < 3; k++) {
            NoticeCustumButton *button = [[NoticeCustumButton alloc] initWithFrame:CGRectMake(20+(45+42+40)*k, CGRectGetMaxY(label2.frame)+20+65, 45+42, 45)];
            [button setImageView:imgA2[k+3] label:@""];
            button.tag = k+3;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLL:)];
            [button addGestureRecognizer:tap];
            [self.contentView addSubview:button];
            [_buttonArr2 addObject:button];
        }
        
        
        
        for (NoticeCustumButton *buttons in _buttonArr2) {
            if ([NoticeTools getType] == 0 || [NoticeTools getType] > 100) {
                if (buttons.tag == 0) {
                    buttons.isSelect = YES;
                }else{
                    buttons.isSelect = NO;
                }
            }else{
                if (buttons.tag == [NoticeTools getType]) {
                    buttons.isSelect = YES;
                }else{
                    buttons.isSelect = NO;
                }
            }
        }
    }
    return self;
}

- (void)changeColor{
    NSArray *imgA2 = @[@"ll_img1",@"ll_img2",@"ll_img3",@"ll_img4",@"ll_img5",@"ll_img6"];
    NSArray *imgA3 = @[@"ll_imgye1",@"ll_imgye2",@"ll_imgye3",@"ll_imgye4",@"ll_imgye5",@"ll_imgye6"];
    NSInteger index = 0;
    for (NoticeCustumButton *buttons in _buttonArr2) {
        buttons.imageView.image = [NoticeTools isWhiteTheme] ? UIImageNamed(imgA2[index]):UIImageNamed(imgA3[index]);
        buttons.label.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        buttons.selectView.image = UIImageNamed([NoticeTools isWhiteTheme] ? @"ll_select_img":@"ll_select_imgye");
   
        index++;
    }
    
    NSArray *imgA1 = @[@"Image_ms_white",@"Image_ms_night"];
    NSArray *imgAy = @[@"Image_ms_whiteye",@"Image_ms_nightye"];
    NSInteger index1 = 0;
    for (NoticeCustumButton *buttons in _buttonArr1) {
        buttons.imageView.image = [NoticeTools isWhiteTheme] ? UIImageNamed(imgA1[index1]):UIImageNamed(imgAy[index1]);
        buttons.label.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        buttons.selectView.image = UIImageNamed([NoticeTools isWhiteTheme] ? @"ll_select_img":@"ll_select_imgye");
        if ([NoticeTools isWhiteTheme]) {
            if (index1 == 0) {
                buttons.isSelect = YES;
            }
            if (index1 == 1) {
                buttons.isSelect = NO;
            }
        }else{
            if (index1 == 1) {
                buttons.isSelect = YES;
            }
            if (index1 == 0) {
                buttons.isSelect = NO;
            }
        }
        index1++;
    }
    _titL.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
    self.contentView.backgroundColor = GetColorWithName(VBackColor);
    _headeL1.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
    _headeL2.textColor = _headeL1.textColor;
}

//白天夜间切换
- (void)changeWH:(UITapGestureRecognizer *)tap{
    NoticeCustumButton *tapV = (NoticeCustumButton *)tap.view;
    for (NoticeCustumButton *allV in _buttonArr1) {
        if (allV.tag == tapV.tag) {
            allV.isSelect = YES;
        }else{
            allV.isSelect = NO;
        }
    }
    if (tapV.tag == 0) {
        [NoticeTools changeThemeWith:@"whiteColor"];
    }else{
        [NoticeTools changeThemeWith:@"nightColor"];
    }
    
    [self changeColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEMCOLORNOTICATIONTAB" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEMCOLORNOTICATION" object:nil];
}

//下雨下雪切换
- (void)changeLL:(UITapGestureRecognizer *)tap{
    NoticeCustumButton *tapV = (NoticeCustumButton *)tap.view;
    for (NoticeCustumButton *allV in _buttonArr2) {
        if (allV.tag == tapV.tag) {
            allV.isSelect = YES;
        }else{
            allV.isSelect = NO;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getAminationWithTag:)]) {
        [NoticeTools saveType:tapV.tag];
        [self.delegate getAminationWithTag:tapV.tag];
    }
}


- (void)disMissShadowView{
    // 动画由大变小
    CGFloat offsetX = animationPoint.x - self.contentView.frame.size.width / 2;
    CGFloat offsetY = animationPoint.y - self.contentView.frame.size.height / 2;
    self.contentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
    } completion:^(BOOL finished) {
        self.contentView.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}

- (void)show{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HASCLICKREADERSHOW" object:nil];
    CGFloat offsetX = animationPoint.x - self.contentView.frame.size.width / 2;
    CGFloat offsetY = animationPoint.y - self.contentView.frame.size.height / 2;
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    _titL.text = GETTEXTWITE(@"sx3.1.setcj");

    NSArray *imgA2 = @[@"ll_img1",@"ll_img2",@"ll_img3",@"ll_img4",@"ll_img5",@"ll_img6"];
    NSArray *imgA3 = @[@"ll_imgye1",@"ll_imgye2",@"ll_imgye3",@"ll_imgye4",@"ll_imgye5",@"ll_imgye6"];
    NSArray *titl2 = @[[NoticeTools isSimpleLau] ?@"默认":@"默認",@"春沁",@"冬暖",[NoticeTools isSimpleLau] ?@"夏凉":@"夏涼",@"春和",@"秋爽"];
    
    NSInteger num = _buttonArr2.count;
    for (int j = 0; j < num; j++) {
        NoticeCustumButton *button = _buttonArr2[j];
        button.label.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        [button setImageView:[NoticeTools isWhiteTheme] ?imgA2[j] : imgA3[j] label:titl2[j]];
    }
    // 动画由小变大
    self.contentView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
    
    [UIView animateWithDuration:0.4f animations:^{
        self.contentView.transform = CGAffineTransformMake(1.05f, 0, 0, 1.0f, 0, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.contentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        } completion:^(BOOL finished) {
            //  恢复原位
            self.contentView.transform = CGAffineTransformIdentity;
        }];
    }];
}
@end






































