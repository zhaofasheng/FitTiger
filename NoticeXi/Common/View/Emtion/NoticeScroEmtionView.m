//
//  NoticeScroEmtionView.m
//  NoticeXi
//
//  Created by li lei on 2020/12/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeScroEmtionView.h"

#import "SPMultipleSwitch.h"
@implementation NoticeScroEmtionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height-40-BOTTOM_HEIGHT)];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*3, 0);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        __weak typeof(self) weakSelf = self;
        self.emotionView  = [[NoticeEmotionView alloc] initWithNoHot];
        self.emotionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.emotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(url, buckId, pictureId, isHot);
            }
        };
        self.emotionView.addMoreBlock = ^(BOOL addMore) {
            if (weakSelf.pushBlock) {
                weakSelf.pushBlock(YES);
            }
        };

        [self.scrollView addSubview:self.emotionView];
        
        self.hotEmotionView  = [[NoticeEmotionView alloc] initWithHot];
        self.hotEmotionView.frame = CGRectMake(DR_SCREEN_WIDTH,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.hotEmotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.hotEmotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(url, buckId, pictureId, isHot);
            }
        };
        self.hotEmotionView.collectBlock = ^(BOOL collect) {
            [weakSelf.emotionView.collectionView.mj_header beginRefreshing];
        };
        [self.scrollView addSubview:self.hotEmotionView];
        
        self.cumEmotionView  = [[NoticeEmotionView alloc] initWithCu];
        self.cumEmotionView.frame = CGRectMake(DR_SCREEN_WIDTH*2,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.cumEmotionView.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, frame.size.height-40-BOTTOM_HEIGHT);
        self.cumEmotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            if (weakSelf.sendBlock) {
                weakSelf.sendBlock(url, buckId, pictureId, isHot);
            }
        };
        self.cumEmotionView.collectBlock = ^(BOOL collect) {
            [weakSelf.emotionView.collectionView.mj_header beginRefreshing];
        };
        [self.scrollView addSubview:self.cumEmotionView];
        
        self.isSelfEmotion = YES;
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-180)/2, frame.size.height-40-BOTTOM_HEIGHT, 40, 40)];
        [btn1 setImage:UIImageNamed(@"Image_selfemoti_b") forState:UIControlStateNormal];
        [self addSubview:btn1];
        self.selfBtn = btn1;
        [btn1 addTarget:self action:@selector(selfBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+30, frame.size.height-40-BOTTOM_HEIGHT, 40, 40)];
        [btn2 setImage:UIImageNamed(@"Image_hotemoti_b") forState:UIControlStateNormal];
        [self addSubview:btn2];
        self.hotBtn = btn2;
        [btn2 addTarget:self action:@selector(hotBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+30, frame.size.height-40-BOTTOM_HEIGHT, 40, 40)];
        [btn3 setImage:UIImageNamed(@"Image_cuem") forState:UIControlStateNormal];//Image_cuemy
        [self addSubview:btn3];
        self.cuBtn = btn3;
        [btn3 addTarget:self action:@selector(cuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)cuBtnClick{
    [self.selfBtn setImage:UIImageNamed(@"Image_nochoicesefl") forState:UIControlStateNormal];
    [self.hotBtn setImage:UIImageNamed(@"Image_hotemoti_b") forState:UIControlStateNormal];
    [self.cuBtn setImage:UIImageNamed(@"Image_cuemy") forState:UIControlStateNormal];//Image_cuemy
    self.scrollView.contentOffset = CGPointMake(DR_SCREEN_WIDTH*2,0);
}

- (void)selfBtnClick{
    [self.selfBtn setImage:UIImageNamed(@"Image_selfemoti_b") forState:UIControlStateNormal];
    [self.hotBtn setImage:UIImageNamed(@"Image_hotemoti_b") forState:UIControlStateNormal];
    [self.cuBtn setImage:UIImageNamed(@"Image_cuem") forState:UIControlStateNormal];//Image_cuemy
    self.scrollView.contentOffset = CGPointMake(0,0);
}

- (void)hotBtnClick{
    [self.selfBtn setImage:UIImageNamed(@"Image_nochoicesefl") forState:UIControlStateNormal];
    [self.hotBtn setImage:UIImageNamed(@"Image_choicehot") forState:UIControlStateNormal];
    [self.cuBtn setImage:UIImageNamed(@"Image_cuem") forState:UIControlStateNormal];//Image_cuemy
    self.scrollView.contentOffset = CGPointMake(DR_SCREEN_WIDTH,0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;

    if (page == 0) {
        [self.selfBtn setImage:UIImageNamed(@"Image_selfemoti_b") forState:UIControlStateNormal];
        [self.hotBtn setImage:UIImageNamed(@"Image_hotemoti_b") forState:UIControlStateNormal];
        [self.cuBtn setImage:UIImageNamed(@"Image_cuem") forState:UIControlStateNormal];//Image_cuemy
    }else if (page == 1){
        [self.selfBtn setImage:UIImageNamed(@"Image_nochoicesefl") forState:UIControlStateNormal];
        [self.hotBtn setImage:UIImageNamed(@"Image_choicehot") forState:UIControlStateNormal];
        [self.cuBtn setImage:UIImageNamed(@"Image_cuem") forState:UIControlStateNormal];//Image_cuemy
    }
    else{
        [self.selfBtn setImage:UIImageNamed(@"Image_nochoicesefl") forState:UIControlStateNormal];
        [self.hotBtn setImage:UIImageNamed(@"Image_hotemoti_b") forState:UIControlStateNormal];
        [self.cuBtn setImage:UIImageNamed(@"Image_cuemy") forState:UIControlStateNormal];//Image_cuemy
    }
}


- (void)refreshEmotion{
    self.emotionView.isDown = YES;
    [self.emotionView requestEmotion];
}

@end
