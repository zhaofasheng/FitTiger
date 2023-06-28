//
//  NoticeWriteRecodCell.m
//  NoticeXi
//
//  Created by li lei on 2021/12/8.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWriteRecodCell.h"

@implementation NoticeWriteRecodCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dayL = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 200, 33)];
        self.dayL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.dayL.font = XGTwentyTwoBoldFontSize;
        [self.contentView addSubview:self.dayL];
        
        self.yearL = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.dayL.frame), 200, 20)];
        self.yearL.font = FOURTHTEENTEXTFONTSIZE;
        self.yearL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.yearL];
        
        self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 79, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-150-NAVIGATION_BAR_HEIGHT-79)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.backView];
        self.backView.bounces = NO;
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        self.backView.showsVerticalScrollIndicator = NO;
        self.backView.showsHorizontalScrollIndicator = NO;
        
        self.bannereImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.backView.frame.size.width-20, 0)];
        [self.backView addSubview:self.bannereImageV];
        
        UIButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-32-32-32-20,CGRectGetMaxY(self.bannereImageV.frame)+15,32,32)];
        [btn setBackgroundImage:[UIImage imageNamed:@"Image_down"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tostClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:btn];
        self.downButton = btn;
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-32-20, self.downButton.frame.origin.y, 32, 32)];
        [self.likeButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:self.likeButton];
        
        
        self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+18, self.likeButton.frame.origin.y-7, 70, 17)];
        self.likeNumL.font = [UIFont systemFontOfSize:10];
        self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.backView addSubview:self.likeNumL];
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backView.frame)+10, 79, 20, self.backView.frame.size.height)];
        _bottomLine.backgroundColor = self.backView.backgroundColor;
        _bottomLine.layer.cornerRadius = 5;
        _bottomLine.layer.masksToBounds = YES;
        [self.contentView addSubview:_bottomLine];
        
        self.topLine = [[UIView alloc] initWithFrame:CGRectMake(-10, 79, 20, self.backView.frame.size.height)];
        self.topLine.backgroundColor = self.backView.backgroundColor;
        self.topLine.layer.cornerRadius = 5;
        self.topLine.layer.masksToBounds = YES;
        [self.contentView addSubview:self.topLine];
    }
    return self;
}

- (void)setModel:(NoticeWriteRecodModel *)model{
    _model = model;
    self.dayL.text = model.day;
    self.yearL.text = model.year;
    
    self.likeButton.hidden = YES;
    self.likeNumL.hidden = YES;
    self.downButton.hidden = YES;
    [self.bannereImageV sd_setImageWithURL:[NSURL URLWithString:_model.attr_pc_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image.size.width*image.size.height >0) {
            CGFloat height = (self.backView.frame.size.width-20) /image.size.width*image.size.height;
            
            self.backView.contentSize = CGSizeMake(0, height+67);
            self.bannereImageV.frame = CGRectMake(10, 10, self.backView.frame.size.width-20, height);
            self.downButton.frame = CGRectMake(DR_SCREEN_WIDTH-40-32-32-32-20,CGRectGetMaxY(self.bannereImageV.frame)+15,32,32);
            self.likeButton.frame = CGRectMake(DR_SCREEN_WIDTH-40-32-20, self.downButton.frame.origin.y, 32, 32);
            self.likeNumL.frame = CGRectMake(self.likeButton.frame.origin.x+18, self.likeButton.frame.origin.y-7, 70, 17);
            
            self.likeButton.hidden = NO;
            self.likeNumL.hidden = NO;
            self.downButton.hidden = NO;
            
            if (self.model.like_num.integerValue) {
                [self.likeButton setBackgroundImage:UIImageNamed(self.model.is_like.boolValue?@"Image_readlikess": @"Image_readlikes") forState:UIControlStateNormal];
                self.likeNumL.text = self.model.like_num;
                self.likeNumL.textColor = [UIColor colorWithHexString:self.model.is_like.boolValue? @"#F47070":@"#25262E"];
                self.likeNumL.hidden = NO;
            }else{
                self.likeNumL.hidden = YES;
                [self.likeButton setBackgroundImage:UIImageNamed(@"Image_readlike") forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)tostClick{
    if (!self.bannereImageV.image) {
        return;
    }
    [self.bannereImageV.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalType]?@"Saved to album":@"已存至手机相册"];
    }];
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"article/like/%@/%@",self.model.bannerId,self.model.is_like.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            self.model.is_like = self.model.is_like.boolValue?@"0":@"1";
            if (self.model.is_like.boolValue) {
                self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue+1];
            }else{
                self.model.like_num = [NSString stringWithFormat:@"%ld",self.model.like_num.integerValue-1];
            }
            if (self.model.like_num.integerValue) {
                [self.likeButton setBackgroundImage:UIImageNamed(self.model.is_like.boolValue?@"Image_readlikess": @"Image_readlikes") forState:UIControlStateNormal];
                self.likeNumL.text = self.model.like_num;
                self.likeNumL.textColor = [UIColor colorWithHexString:self.model.is_like.boolValue? @"#F47070":@"#25262E"];
                self.likeNumL.hidden = NO;
            }else{
                self.likeNumL.hidden = YES;
                [self.likeButton setBackgroundImage:UIImageNamed(@"Image_readlike") forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}
@end
