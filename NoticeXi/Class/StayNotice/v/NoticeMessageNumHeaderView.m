//
//  NoticeMessageNumHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2022/8/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMessageNumHeaderView.h"

@implementation NoticeMessageNumHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 120)];
        backImageView.userInteractionEnabled = YES;
        backImageView.image = UIImageNamed(@"Image_tmqis");
        [self addSubview:backImageView];
        
        CGFloat space = (DR_SCREEN_WIDTH-48*4)/5;
        NSArray *imagArr = @[@"img_push1",@"img_push2",@"img_push3",@"img_push4"];
        NSArray *titleArr = @[[NoticeTools getLocalType] > 0?[NoticeTools getLocalStrWith:@"message.artcle"]: @"读书文章",[NoticeTools getLocalStrWith:@"push.ce9"],[NoticeTools getLocalStrWith:@"message.likeNotice"],[NoticeTools getLocalStrWith:@"message.eachMessage"]];
        for (int i = 0; i < 4; i++) {
            UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space+(48+space)*i, 30, 48, 48)];
            btnImageView.image = UIImageNamed(imagArr[i]);
            btnImageView.tag = i;
            [backImageView addSubview:btnImageView];
            btnImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
            [btnImageView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(space+(48+space)*i-10, CGRectGetMaxY(btnImageView.frame)+4, 68, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            label.userInteractionEnabled = YES;
            label.tag = i;
            label.text = titleArr[i];
            [backImageView addSubview:label];
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
            [label addGestureRecognizer:tap1];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnImageView.frame)-7, btnImageView.frame.origin.y, 14, 14)];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = FOURTHTEENTEXTFONTSIZE;
            label1.textColor = [UIColor whiteColor];
            label1.font = [UIFont systemFontOfSize:9];
            label1.layer.cornerRadius = 7;
            label1.layer.masksToBounds = YES;
            label1.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
            [backImageView addSubview:label1];
            label1.hidden = YES;
            if (i == 0) {
                self.arcL = label1;
            }else if (i==1){
                self.sysL = label1;
            }else if (i==2){
                self.likeL = label1;
            }else{
                self.msgL = label1;
            }
        }
    }
    return self;
}

- (void)imgTap:(UITapGestureRecognizer *)tap{
    UIImageView *tapView = (UIImageView *)tap.view;
    if (self.pushBlock) {
        self.pushBlock(tapView.tag);
    }
}

- (void)labelTap:(UITapGestureRecognizer *)tap{
    UILabel*tapView = (UILabel *)tap.view;
    if (self.pushBlock) {
        self.pushBlock(tapView.tag);
    }
}
@end
