//
//  NoticeDanMuHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuHeaderView.h"
@implementation NoticeDanMuHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height)];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, 0);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        __weak typeof(self) weakSelf = self;
        self.playeBoKeView = [[NoticePlayerBokeView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, scrollView.frame.size.height)];
        [scrollView addSubview:self.playeBoKeView];
        self.playeBoKeView.choiceDanMuBlock = ^(BOOL goDanMu) {
            [weakSelf hotBtnClick];
        };
        self.playeBoKeView.clickListBlock = ^(BOOL list) {
            if (weakSelf.clickListBlock) {
                weakSelf.clickListBlock(YES);
            }
        };
////        self.listView = [[NoticeDanMuMoveListView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH, 0, DR_SCREEN_WIDTH, scrollView.frame.size.height)];
////        [scrollView addSubview:self.listView];
////
////        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20,0,GET_STRWIDTH(@"简介简介见", 16, 44), 44)];
////        btn1.titleLabel.font = XGSIXBoldFontSize;
////        [btn1 setTitle:[NoticeTools getLocalStrWith:@"bk.jjjie"] forState:UIControlStateNormal];
////        [btn1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
////        [self addSubview:btn1];
////        self.selfBtn = btn1;
////        [btn1 addTarget:self action:@selector(selfBtnClick) forControlEvents:UIControlEventTouchUpInside];
////
////        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+40,0,GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44)+15, 44)];
////        [btn2 setTitle:[NoticeTools getLocalStrWith:@"bk.list"] forState:UIControlStateNormal];
////        [btn2 setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
////        btn2.titleLabel.font = XGSIXBoldFontSize;
////        [self addSubview:btn2];
////        self.hotBtn = btn2;
////        [btn2 addTarget:self action:@selector(hotBtnClick) forControlEvents:UIControlEventTouchUpInside];
////
////        self.isOpen = YES;
//        self.openBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-33,23/2, 33, 21)];
//        [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
//        [self addSubview:self.openBtn];
//        [self.openBtn addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
////
////        self.line = [[UIView alloc] initWithFrame:CGRectMake(20+(btn1.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44), 2)];
////        self.line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
////        self.line.layer.cornerRadius = 1;
////        self.line.layer.masksToBounds = YES;
////        [self addSubview:self.line];
    }
    return self;
}

- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
    
    [self.playeBoKeView.iconImageView sd_setImageWithURL:[NSURL URLWithString:bokeModel.avatar_url]];
    self.playeBoKeView.nickNameL.text = bokeModel.nick_name?bokeModel.nick_name:@"声昔官方播客";
    self.playeBoKeView.introL.attributedText = bokeModel.allTextAttStr;
    self.playeBoKeView.introL.numberOfLines = 0;
    self.playeBoKeView.introL.frame = CGRectMake(0,0, DR_SCREEN_WIDTH-30, bokeModel.textHeight);
    self.playeBoKeView.scrollView.contentSize = CGSizeMake(0, bokeModel.textHeight);
    if (bokeModel.user_id.intValue == 1) {
        self.playeBoKeView.markImage.hidden = NO;
    }else{
        self.playeBoKeView.markImage.hidden = YES;
    }
    self.playeBoKeView.bokeModel = bokeModel;
    

    
}
//
//- (void)openClick{
//    self.isOpen = !self.isOpen;
//    [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
//    if (self.hideDanMuBlock) {
//        self.hideDanMuBlock(self.isOpen);
//    }
//}

- (void)selfBtnClick{
    self.isInduce = YES;
    [self.selfBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    self.line.frame = CGRectMake(20+(self.selfBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44), 2);
    self.scrollView.contentOffset = CGPointMake(0,0);
    if (self.hideKeyBordBlock) {
        self.hideKeyBordBlock(YES);
    }
    if (self.hideinputBlock) {
        self.hideinputBlock(YES);
    }
}

- (void)hotBtnClick{
    self.isInduce = NO;
    if (self.hideinputBlock) {
        self.hideinputBlock(NO);
    }
    [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.selfBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    self.line.frame = CGRectMake(self.hotBtn.frame.origin.x+(self.hotBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44), 2);
    self.scrollView.contentOffset = CGPointMake(DR_SCREEN_WIDTH,0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;
    
    if (page == 0) {
        [self.selfBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.hotBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.line.frame = CGRectMake(20+(self.selfBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"book.jianjie"], 16, 44), 2);
        if (self.hideKeyBordBlock) {
            self.hideKeyBordBlock(YES);
        }
        if (self.hideinputBlock) {
            self.hideinputBlock(YES);
        }
    }else{
        
        self.isInduce = NO;
        [self.hotBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.selfBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.line.frame = CGRectMake(self.hotBtn.frame.origin.x+(self.hotBtn.frame.size.width-GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44))/2, 42, GET_STRWIDTH([NoticeTools getLocalStrWith:@"bk.list"], 16, 44), 2);
        if (self.hideinputBlock) {
            self.hideinputBlock(NO);
        }
    }
}
@end
