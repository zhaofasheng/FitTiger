//
//  NoticeCenterInfoTostView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCenterInfoTostView.h"

@implementation NoticeCenterInfoTostView


- (instancetype)initWithShowUserInfo{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-60, 480)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#65A8FF"];
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        self.contentView.center = self.center;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-227)/2, 54/2, 227, 36)];
        imageView.image = UIImageNamed(@"Image_livez");
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer *itap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self addGestureRecognizer:itap];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, DR_SCREEN_WIDTH-60, 190)];
        colorView.backgroundColor = [UIColor colorWithHexString:@"#92C1FF"];
        [self.contentView addSubview:colorView];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-60-150)/2,20, 150,150)];
        _iconImageView.layer.cornerRadius = 150/2;
        _iconImageView.layer.masksToBounds = YES;
        [colorView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;

        NSArray *arr = @[[NoticeTools chinese:@"姓名" english:@"Nickname" japan:@"ニックネーム"],[NoticeTools chinese:@"昔龄" english:@"Been here" japan:@"ユーザー"],[NoticeTools chinese:@"记录心情" english:@"Record" japan:@"SNS"]];
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(colorView.frame)+20+57*i, DR_SCREEN_WIDTH-60-60, 17)];
            label.font = TWOTEXTFONTSIZE;
            label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
            label.text = arr[i];
            [self.contentView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(label.frame)+4, DR_SCREEN_WIDTH-60-60, 22)];
            label1.font = EIGHTEENTEXTFONTSIZE;
            label1.textColor = [UIColor whiteColor];
            [self.contentView addSubview:label1];
            if (i==0) {
                self.nickNameL = label1;
            }else if ( i == 1){
                self.timeL = label1;
            }else{
                self.numL = label1;
            }
        }
  
    }
    return self;
}

- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    self.nickNameL.text = userM.nick_name;

    self.timeL.text = [NSString stringWithFormat:@"%@天（%@入驻）",userM.comeHereDays,userM.sgjTime];
    
    if (userM.isMoreFiveMin) {
        self.numL.text = [NSString stringWithFormat:@"%@%@",userM.allVoiceTime,[NoticeTools getLocalType] > 0?@"Min":@"分钟"];
    }else{
        self.numL.text = [NSString stringWithFormat:@"%@%@",userM.allVoiceTime,[NoticeTools getLocalType] > 0?@"S":@"秒"];
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
