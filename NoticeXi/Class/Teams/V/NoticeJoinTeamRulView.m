//
//  NoticeJoinTeamRulView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJoinTeamRulView.h"
#import "UIView+CLSetRect.h"
@implementation NoticeJoinTeamRulView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 467)];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        self.contentView.image = UIImageNamed(@"rulcontent_img");
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 20+DR_SCREEN_WIDTH*106/375-10, DR_SCREEN_WIDTH-40, self.contentView.frame.size.height-BOTTOM_HEIGHT-10-40-15-20-DR_SCREEN_WIDTH*106/375+10)];
        backV.backgroundColor = [UIColor whiteColor];
        [backV setAllCorner:20];
        [self.contentView addSubview:backV];
        
        self.contentL = [[NoticeTextView alloc] initWithFrame:CGRectMake(10, 30, DR_SCREEN_WIDTH-60,backV.frame.size.height-40)];
        self.contentL.font = THRETEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        self.contentL.editable = NO;
        [backV addSubview:self.contentL];
        self.contentL.isContent = YES;
        self.contentL.textContainerInset = UIEdgeInsetsMake(10, -5, 0, -5);
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*106/375)];
        imageV.image = UIImageNamed(@"rulcontent_imgtitle");
        [self.contentView addSubview:imageV];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,self.contentView.frame.size.height-40-BOTTOM_HEIGHT-10, DR_SCREEN_WIDTH-40, 40)];
        [cancelBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [cancelBtn setAllCorner:20];
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
    }
    return self;
}

- (void)showrulView{

    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{
    if(self.knowBlock){
        self.knowBlock(YES);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
