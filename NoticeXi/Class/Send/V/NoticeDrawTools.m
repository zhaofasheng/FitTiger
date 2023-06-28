//
//  NoticeDrawTools.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawTools.h"
#import "NoticeColorChoiceViewController.h"
@implementation NoticeDrawTools
{
    NSMutableArray *_penBtnArr;
    NSMutableArray *_cBtnArr;
    NSInteger _oldChoiceTag;
    UIView *_choiceView;
    BOOL _choiceC;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        self.userInteractionEnabled = YES;
        _btnArr = [NSMutableArray new];
        _imgArr = [NSMutableArray new];
        self.oldColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.oldWidth = 1;
        _choicePen = YES;
        _choiceC = NO;
        _oldxpcWidth = 30;
        _oldChoiceTag = 0;
        
        NSArray *imgArr = @[@"draw_b",@"draw_c",@"draw_1",@"draw_2c",@"draw_3c",@"draw_4c",@"draw_5c",@"draw_6c"];
        for (int i = 0; i < 8; i++) {
            if (i < 2) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42*i,frame.size.height-42, 32,32)];
                NSString *str = [NSString stringWithFormat:@"%@",imgArr[i]];
                imgView.image = UIImageNamed(str);
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                imgView.tag = i;
                imgView.userInteractionEnabled = YES;
                if (i == 0) {
                    imgView.frame  = CGRectMake((DR_SCREEN_WIDTH-42*8)/2-5,self.frame.size.height-27-32, 32,32);
                    _oldImageView1 = imgView;
                }else{
                    imgView.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42,self.frame.size.height-27-32, 32,32);
                    _oldImageView2 = imgView;
                    _oldImageView2.alpha = 0.4;
                }
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choicePenOrClear:)];
                [imgView addGestureRecognizer:tap];
                [_imgArr addObject:imgView];
                [self addSubview:imgView];
            }else{
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42*i,frame.size.height-27-42+10, 42,42)];
                NSString *str = [NSString stringWithFormat:@"%@",imgArr[i]];
                [btn setImage:UIImageNamed(str) forState:UIControlStateNormal];
                
                btn.tag = i - 2;
                [btn addTarget:self action:@selector(choiceColorClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btnArr addObject:btn];
                [self addSubview:btn];
                if ( i == 7) {
                    _choiceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
                    _choiceView.backgroundColor = [UIColor clearColor];
                    _choiceView.layer.cornerRadius = _choiceView.frame.size.height/2;
                    _choiceView.layer.masksToBounds = YES;
                    _choiceView.center = btn.center;
                    [self addSubview:_choiceView];
                }
            }
        }
    }
    return self;
}

- (CWPopMenu *)menu{
    if (!_menu) {
        _menu = [[CWPopMenu alloc]initWithArrow:CGPointMake(_oldImageView1.center.x,DR_SCREEN_HEIGHT-_oldImageView1.frame.size.height-10-40) menuSize:CGSizeMake(158,64) arrowStyle:CWPopMenuArrowBottomHeader];
        _menu.menuViewBgColor = [UIColor colorWithHexString:@"#1D1E24"];
        _menu.alpha = 0.1;
        
        _penBtnArr = [NSMutableArray new];
        NSArray *imgArr = @[@"penc0",@"pen1",@"pen2",@"pen3",@"pen4"];
        for (int i = 0; i < 5; i++) {
            UIButton *penBtn = [[UIButton alloc] initWithFrame:CGRectMake((_menu.menuView.frame.size.width-22*5-20)/2+27*i, (_menu.menuView.frame.size.height-22)/2, 22, 22)];
            [_penBtnArr addObject:penBtn];
            NSString *str =  [NSString stringWithFormat:@"%@",imgArr[i]];
            [penBtn setImage:UIImageNamed(str) forState:UIControlStateNormal];
            penBtn.tag = i;
            [penBtn addTarget:self action:@selector(choicePenClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menu.menuView addSubview:penBtn];
        }
    }
    return _menu;
}

- (CWPopMenu *)colorMenu{
    if (!_colorMenu) {
    
        UIButton *btn = _btnArr[5];
        _colorMenu = [[CWPopMenu alloc]initWithArrow:CGPointMake(btn.center.x,DR_SCREEN_HEIGHT-btn.frame.size.height-10) menuSize:CGSizeMake(DR_SCREEN_WIDTH-50,DR_SCREEN_WIDTH-50+115) arrowStyle:CWPopMenuArrowBottomfooter];
        _colorMenu.menuViewBgColor = [UIColor colorWithHexString:@"#1D1E24"];
        _colorMenu.alpha = 0.1;
        _colorMenu.userInteractionEnabled = YES;
        NoticeColorChoiceViewController *ctl = [[NoticeColorChoiceViewController alloc] init];
        ctl.view.frame = CGRectMake(0,0, _colorMenu.menuView.frame.size.width,115+_colorMenu.menuView.frame.size.width);
        ctl.getcolor.frame = CGRectMake(0, 0, ctl.view.frame.size.width,ctl.view.frame.size.height);
        [_colorMenu.menuView addSubview:ctl.view];

        __weak __block NoticeDrawTools *copy_self = self;
        [ctl.getcolor setBlock:^(UIColor *color)
         {
             self->_choiceView.backgroundColor = color;
             if (copy_self.delegate && [copy_self.delegate respondsToSelector:@selector(choiceColorWith:)]) {
                 [copy_self.delegate choiceColorWith:color];
             }
             copy_self.oldColor = color;
         }];
    }
    return _colorMenu;
}

- (CWPopMenu *)menu1{
    if (!_menu1) {
        _menu1 = [[CWPopMenu alloc]initWithArrow:CGPointMake(_oldImageView2.center.x,DR_SCREEN_HEIGHT-_oldImageView2.frame.size.height-10-40) menuSize:CGSizeMake(150,56) arrowStyle:CWPopMenuArrowBottomHeader];
        _menu1.menuViewBgColor = [UIColor colorWithHexString:@"#1D1E24"];
        _menu1.alpha = 0.1;
        
        _cBtnArr = [NSMutableArray new];
        NSArray *imgArr = @[@"xpc0",@"xpc1",@"xpcc2"];
        for (int i = 0; i < 3; i++) {
            UIButton *penBtn = [[UIButton alloc] initWithFrame:CGRectMake((_menu1.menuView.frame.size.width-30*3-10)/2+35*i, (_menu1.menuView.frame.size.height-30)/2,30, 30)];
            [_cBtnArr addObject:penBtn];
            NSString *str =   [NSString stringWithFormat:@"%@",imgArr[i]];
            [penBtn setBackgroundImage:UIImageNamed(str) forState:UIControlStateNormal];
            penBtn.tag = i;
            [penBtn addTarget:self action:@selector(choicePenClick1:) forControlEvents:UIControlEventTouchUpInside];
            [_menu1.menuView addSubview:penBtn];
        }
    }
    return _menu1;
}

//选择橡皮檫
- (void)choicePenClick1:(UIButton *)btn{
    
    for (UIButton *penbtn in _cBtnArr) {
        NSString *imgName = [NSString stringWithFormat:@"xpc%ld",(long)penbtn.tag];
        [penbtn setBackgroundImage:UIImageNamed(imgName) forState:UIControlStateNormal];
    }
    NSString *imgNamec = [NSString stringWithFormat:@"xpcc%ld",(long)btn.tag];
    [btn setBackgroundImage:UIImageNamed(imgNamec) forState:UIControlStateNormal];
    
    NSArray *arr = @[@"5",@"15",@"30"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceXpcWith:)]) {
        [self.delegate choiceXpcWith:[arr[btn.tag] floatValue]];
    }
    self.oldxpcWidth = [arr[btn.tag] floatValue];
}


//选择颜色
- (void)choiceColorClick:(UIButton *)btn{
    
    if (!_choicePen) {
        _oldChoiceTag = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelXpcWith:color:)]) {
            [self.delegate cancelXpcWith:self.oldWidth color:self.oldColor];
        }
        _choicePen = YES;
        _choiceC = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.oldImageView1.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2-5-5,self.frame.size.height-27-37, 32+10,32+5);
            self->_oldImageView2.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42,self.frame.size.height-27-32, 32,32);
            self.oldImageView2.alpha = 0.4;
        }];
    }
    
    NSArray *imgArr = @[@"draw_1c",@"draw_2c",@"draw_3c",@"draw_4c",@"draw_5c",@"draw_6c"];
    NSArray *imgArr1 = @[@"draw_1",@"draw_2",@"draw_3",@"draw_4",@"draw_5",@"draw_6"];
    for (UIButton *btns in _btnArr) {
        NSString *str = [NSString stringWithFormat:@"%@",imgArr[btns.tag]];
        [btns setImage:UIImageNamed(str) forState:UIControlStateNormal];
    }
    NSString *str1 = [NSString stringWithFormat:@"%@",imgArr1[btn.tag]];
    [btn setImage:UIImageNamed(str1) forState:UIControlStateNormal];
    
    NSArray *arr = @[@"#FFFFFF",@"#0099E6",@"#20D077",@"#E6C14D",@"#E69191"];
    if (btn.tag == 5) {
        [self.colorMenu showMenu:YES];
        return;
    }
    _choiceView.backgroundColor = [UIColor clearColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceColorWith:)]) {
        [self.delegate choiceColorWith:[UIColor colorWithHexString:arr[btn.tag]]];
    }
    self.oldColor = [UIColor colorWithHexString:arr[btn.tag]];
}

- (void)choiceColorWithColor:(UIColor *)color{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceColorWith:)]) {
        [self.delegate choiceColorWith:color];
    }
    self.oldColor = color;
}

//选择笔
- (void)choicePenClick:(UIButton *)btn{
    
    for (UIButton *penbtn in _penBtnArr) {
        NSString *imgName = [NSString stringWithFormat:@"pen%ld",(long)penbtn.tag];
        [penbtn setImage:UIImageNamed(imgName) forState:UIControlStateNormal];
    }
    NSString *imgNamec = [NSString stringWithFormat:@"penc%ld",(long)btn.tag];
    [btn setImage:UIImageNamed(imgNamec) forState:UIControlStateNormal];
    
    NSArray *arr = @[@"1",@"3",@"5",@"10",@"20"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choicePenWidth:)]) {
        [self.delegate choicePenWidth:[arr[btn.tag] floatValue]];
    }
    self.oldWidth = [arr[btn.tag] floatValue];
}

- (void)choicePenOrClear:(UITapGestureRecognizer *)tap{
    UIImageView *tapImagView = (UIImageView *)tap.view;
    
    if (tapImagView.tag == 0 && _oldChoiceTag == 0) {//选择的是上次的
        [self.menu showMenu:YES];
        return;
    }
    
    if (tapImagView.tag == 1 && _oldChoiceTag == 1) {//选择的是上次的
        [self.menu1 showMenu:YES];
        return;
    }

    tapImagView.alpha = 1;
    if (tapImagView.tag == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelXpcWith:color:)]) {
            [self.delegate cancelXpcWith:self.oldWidth color:self.oldColor];
        }
        _choicePen = YES;
        _choiceC = NO;
        [UIView animateWithDuration:0.3 animations:^{
            tapImagView.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2-5-5,self.frame.size.height-27-37, 32+10,32+5);
            self->_oldImageView2.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42,self.frame.size.height-27-32, 32,32);
            self.oldImageView2.alpha = 0.4;
        }];
       
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(choiceXpcWith:)]) {
            [self.delegate choiceXpcWith:self.oldxpcWidth];
        }
        _choicePen = NO;
        _choiceC = YES;
        [UIView animateWithDuration:0.3 animations:^{
            tapImagView.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2+42-5,self.frame.size.height-27-37, 32+10,32+5);
            self->_oldImageView1.frame = CGRectMake((DR_SCREEN_WIDTH-42*8)/2-5,self.frame.size.height-27-32, 32,32);
            self.oldImageView1.alpha = 0.4;
        }];
    }

    _oldChoiceTag = tapImagView.tag;
}

@end
