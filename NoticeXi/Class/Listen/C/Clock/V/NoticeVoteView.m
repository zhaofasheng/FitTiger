//
//  NoticeVoteView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/23.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoteView.h"
#import "UIView+MGExtension.h"

@implementation NoticeVoteView

// 初始化的时候 高度可以随意给 宽度给定就好
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubView];
    }
    return self;
}

- (void) addSubView {
    self.backgroundColor = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
    UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    keyView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    [keyView addSubview:self];
    [kMainWindow addSubview:keyView];
    keyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [keyView addGestureRecognizer:tap];
    self.keyBackView = keyView;

    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_voteleft_b":@"Image_voteleft_y");
    [self addSubview:self.backImageView];
    self.backImageView.userInteractionEnabled = YES;
    
    NSArray *arr = @[@"您是天使",@"您是魔鬼",@"您是神"];
    NSArray *imgArr = @[[NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy",[NoticeTools isWhiteTheme]?@"mogui":@"moguiy",[NoticeTools isWhiteTheme]?@"Image_shen":@"Image_sheny"];
    for (int i = 0; i < arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+37*i, 20, 20)];
        imageView.image = UIImageNamed (imgArr[i]);
        [self.backImageView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, imageView.frame.origin.y, self.backImageView.frame.size.width-CGRectGetMaxX(imageView.frame)-10-5, 20)];
        label.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3e3e4a"];
        label.font = ELEVENTEXTFONTSIZE;
        label.text = arr[i];
        [self.backImageView addSubview:label];
        
        if (i == 0) {
            self.tianshiImgView = imageView;
            self.tsL = label;
        }else if (i == 1){
            self.moguiImgView = imageView;
            self.mgL = label;
        }else{
            self.shenImgView = imageView;
            self.sL = label;
        }
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y-5, self.frame.size.width, 30)];
        tapV.userInteractionEnabled = YES;
        tapV.tag = i;
        [self.backImageView addSubview:tapV];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAciton:)];
        [tapV addGestureRecognizer:tap1];
    }
}

- (void)setPyModel:(NoticeClockPyModel *)pyModel{
    _pyModel = pyModel;
    NoticeClockPyModel *model = pyModel;
    self.tsL.text = [NSString stringWithFormat:@"您是天使 %@",model.vote_option_one.integerValue?model.vote_option_one:@""];
    self.mgL.text = [NSString stringWithFormat:@"您是恶魔 %@",model.vote_option_two.integerValue?model.vote_option_two:@""];
    self.sL.text = [NSString stringWithFormat:@"您是神 %@",model.vote_option_three.integerValue?model.vote_option_three:@""];
    if ([model.vote_option isEqualToString:@"1"]) {
        self.tianshiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshic":@"tianshicy");
        self.moguiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
        self.shenImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shen":@"Image_sheny");
    }else if ([model.vote_option isEqualToString:@"2"]){
        self.tianshiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
        self.moguiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"moguic":@"moguicy");
        self.shenImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shen":@"Image_sheny");
    }else if ([model.vote_option isEqualToString:@"3"]){
        self.tianshiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
        self.moguiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
        self.shenImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shenc":@"Image_shency");
    }else{
        self.tianshiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
        self.moguiImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
        self.shenImgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shen":@"Image_sheny");
    }
}

- (void)tapAciton:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (self.clickBlock) {
        self.clickBlock(tapV.tag);
    }
    [self dismiss];
}

- (void)actionClick:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    [self dismiss];
}

- (void) configData {
    self.isAnimation    = self.isAnimation ? self.isAnimation : NO;
    self.backgroundColor          = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
    [self show];
}

-(void)showWithView:(UIView *)view {
    
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    
    //默认数据配置
    [self configData];
    
    self.frame = CGRectMake(15, relyPoint.y - self.frame.size.height - view.height , self.frame.size.width, self.frame.size.height);

}


- (void)show
{
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.keyBackView addSubview:self];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveLinear animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [self.keyBackView removeFromSuperview];
}


@end
