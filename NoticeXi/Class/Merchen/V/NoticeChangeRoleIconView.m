//
//  NoticeChangeRoleIconView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeRoleIconView.h"

@implementation NoticeChangeRoleIconView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = YES;
        

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(78, 85, 160, 160)];
        self.backImageView = imageView;
        self.backImageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"nochoiceroleimg"]);
        self.backImageView.userInteractionEnabled = YES;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315, 429)];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        self.contentView.center = self.center;
        [self.contentView addSubview:self.backImageView];
        
        self.roleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(78, 265, 64, 64)];
        self.roleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roleTap1)];
        [self.roleImageView addGestureRecognizer:tap1];
        [self.contentView addSubview:self.roleImageView];
        
        self.choiceImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 4, 20, 20)];
        self.choiceImage1.image = UIImageNamed(@"Image_shoprole");
        [self.roleImageView addSubview:self.choiceImage1];
        
        self.roleImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(174, 265, 64, 64)];
        self.roleImageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roleTap2)];
        [self.roleImageView1 addGestureRecognizer:tap2];
        [self.contentView addSubview:self.roleImageView1];
        
        self.choiceImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 4, 20, 20)];
        self.choiceImage2.image = UIImageNamed(@"Image_shoprole");
        [self.roleImageView1 addSubview:self.choiceImage2];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 315,25)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = XGEightBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.text = @"选个你的角色吧";
        [self.contentView addSubview:label];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(315-15-24, 15, 24, 24)];
        [cancelBtn setImage:UIImageNamed(@"liuyimage") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
        UIButton *sureButon = [[UIButton alloc] initWithFrame:CGRectMake(58, 359, 200, 40)];
        sureButon.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
        [sureButon setTitle:@"确认" forState:UIControlStateNormal];
        [sureButon setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        sureButon.titleLabel.font = SIXTEENTEXTFONTSIZE;
        sureButon.layer.cornerRadius = 20;
        sureButon.layer.masksToBounds = YES;
        [sureButon addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sureButon];
        self.sureButton = sureButon;
    }
    return self;
}

- (void)sureClick{
    if(self.role){
        if(self.refreshRoleBlock){
            self.refreshRoleBlock(self.role,self.url);
        }
        [self cancelClick];
    }
}

- (void)setMyShopModel:(NoticeMyShopModel *)myShopModel{
    _myShopModel = myShopModel;
    
    if(myShopModel.role_listArr.count >= 2){
        NoticeMyShopModel *roleM1 = myShopModel.role_listArr[0];
        [self.roleImageView sd_setImageWithURL:[NSURL URLWithString:roleM1.role_img_url]];
        
        NoticeMyShopModel *roleM2 = myShopModel.role_listArr[1];
        [self.roleImageView1 sd_setImageWithURL:[NSURL URLWithString:roleM2.role_img_url]];
    }
    
    if(myShopModel.myShopM.role.integerValue > 0){
        for (int i = 0; i < myShopModel.role_listArr.count; i++) {
            NoticeMyShopModel *roleM = myShopModel.role_listArr[i];
            if([roleM.role isEqualToString:myShopModel.myShopM.role]){
                if(i == 0){
                    [self roleTap1];
                }else{
                    [self roleTap2];
                }
            }
        }
    }
}

- (void)roleTap1{
    if(_myShopModel.role_listArr.count >= 2){
        NoticeMyShopModel *roleM1 = _myShopModel.role_listArr[0];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:roleM1.role_img_url]];
        self.role = roleM1.role;
        self.url = roleM1.role_img_url;
        self.choiceImage1.image = UIImageNamed(@"Image_choiceadd_b");
        self.choiceImage2.image = UIImageNamed(@"Image_shoprole");
        self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)roleTap2{
    if(_myShopModel.role_listArr.count >= 2){
        NoticeMyShopModel *roleM1 = _myShopModel.role_listArr[1];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:roleM1.role_img_url]];
        self.role = roleM1.role;
        self.url = roleM1.role_img_url;
        self.choiceImage2.image = UIImageNamed(@"Image_choiceadd_b");
        self.choiceImage1.image = UIImageNamed(@"Image_shoprole");
        self.sureButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)cancelClick{
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

@end
