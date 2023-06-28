//
//  NoticeShopComUserView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopComUserView.h"
#import "UIView+CLSetRect.h"
@implementation NoticeShopComUserView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
      
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 396)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:_contentView];
        [_contentView setCornerOnTop:10];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,58, DR_SCREEN_WIDTH, 28)];
        titleL.font = XGTwentyBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.text = @"你对买家的印象如何？";
        titleL.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:titleL];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, DR_SCREEN_WIDTH, 20)];
        label.text = @"是否尊重你？";
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_contentView addSubview:label];
        
        NSArray *arr = @[@"很好",@"有点受伤",@"收到重创"];
        for (int i = 0; i < 3; i++) {
            UIView *comView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88*3-40)/2+108*i, CGRectGetMaxY(titleL.frame)+56, 88, 110)];
            comView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            comView.layer.cornerRadius = 10;
            comView.layer.masksToBounds = YES;
            comView.userInteractionEnabled = YES;
            [_contentView addSubview:comView];
            comView.tag = i;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 48, 48)];
            imageView.userInteractionEnabled = YES;
            [comView addSubview:imageView];
            NSString *imgName = [NSString stringWithFormat:@"shopgoodcomimg_%d",i+1];
            imageView.image = UIImageNamed(imgName);
            
            UILabel *goodL = [[UILabel alloc] initWithFrame:CGRectMake(0, 72,88, 22)];
            goodL.font = FIFTHTEENTEXTFONTSIZE;
            goodL.textColor = [UIColor colorWithHexString:@"#25262E"];
            goodL.text = arr[i];
            goodL.textAlignment = NSTextAlignmentCenter;
            [comView addSubview:goodL];
            
            if(i == 0){
                self.goodView = comView;
                self.goodL = goodL;
            }else if (i==1){
                self.nomerView = comView;
                self.nomerL = goodL;
            }else{
                self.badView = comView;
                self.badL = goodL;
            }
            
            UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodLikeTap:)];
            [comView addGestureRecognizer:comTap];
        }
        
        self.comButton = [[UIButton alloc] initWithFrame:CGRectMake(68, 300, DR_SCREEN_WIDTH-68*2, 40)];
        self.comButton.layer.cornerRadius = 20;
        self.comButton.layer.masksToBounds = YES;
        [self.comButton setTitle:@"确认添加" forState:UIControlStateNormal];
        self.comButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.comButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.comButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [_contentView addSubview:self.comButton];
        [self.comButton addTarget:self action:@selector(comClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
     
    }
    return self;
}

- (void)goodLikeTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    self.goodView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.nomerView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.badView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.goodL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.nomerL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.badL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    if(tapV.tag == 0){
        self.goodView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.goodL.textColor = [UIColor whiteColor];
        self.score = @"1";
    }else if (tapV.tag == 1){
        self.nomerView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.nomerL.textColor = [UIColor whiteColor];
        self.score = @"2";
    }else{
        self.badView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.badL.textColor = [UIColor whiteColor];
        self.score = @"3";
    }
    self.comButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)comClick{
    if(self.score.intValue){
        if(self.scoreBlock){
            self.scoreBlock(self.score);
        }
        [self dissMissTap];
    }
}


- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{

    [UIView animateWithDuration:0.2 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 396);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
