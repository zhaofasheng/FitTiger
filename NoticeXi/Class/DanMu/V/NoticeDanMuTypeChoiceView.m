//
//  NoticeDanMuTypeChoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuTypeChoiceView.h"

@implementation NoticeDanMuTypeChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        

        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, GET_STRWIDTH(@"弹幕位置", 13, 14), 14)];
        label2.text = [NoticeTools getLocalStrWith:@"bk.color"];
        label2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        label2.font = THRETEENTEXTFONTSIZE;
        [self addSubview:label2];
        
        self.colorArr = @[@"#FFFFFF",@"#FF7272",@"#FFD655",@"#20D077",@"#37BCFF"];
        self.buttonArr = [NSMutableArray new];
        for (int i = 0; i < self.colorArr.count; i++) {
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(20+((DR_SCREEN_WIDTH-120)/5+20)*i, CGRectGetMaxY(label2.frame)+12,(DR_SCREEN_WIDTH-120)/5, 31)];
            colorView.layer.cornerRadius = 4;
            colorView.layer.masksToBounds = YES;
            [self addSubview:colorView];
            colorView.backgroundColor = [UIColor colorWithHexString:self.colorArr[i]];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(colorView.frame.origin.x-2, colorView.frame.origin.y-2, colorView.frame.size.width+4, colorView.frame.size.height+4)];
            [self addSubview:button];
            button.tag = i;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;
            if (i == 0) {
                button.layer.borderWidth = 0.5;
            }else{
                button.layer.borderWidth = 0.0;
            }
            
            button.layer.borderColor = [UIColor colorWithHexString:@"#25262E"].CGColor;
            [self addSubview:button];
            [button addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArr addObject:button];
        }
    }
    return self;
}

- (void)colorClick:(UIButton *)btn{
    for (UIButton *btn in self.buttonArr) {
        btn.layer.borderWidth = 0;
    }
    btn.layer.borderWidth = 0.5;
    if (self.colorBlock) {
        self.colorBlock(self.colorArr[btn.tag]);
    }
}

- (void)moveClick{
    self.isTop = NO;
    [self.moveBtn setBackgroundImage:UIImageNamed(self.isTop?@"Image_danmumoven":@"Image_danmumove") forState:UIControlStateNormal];
    [self.topBtn setBackgroundImage:UIImageNamed(self.isTop?@"Image_danmutop":@"Image_danmutopn") forState:UIControlStateNormal];
    if (self.topBlock) {
        self.topBlock(self.isTop);
    }
}

- (void)topClick{
    self.isTop = YES;
    [self.moveBtn setBackgroundImage:UIImageNamed(self.isTop?@"Image_danmumoven":@"Image_danmumove") forState:UIControlStateNormal];
    [self.topBtn setBackgroundImage:UIImageNamed(self.isTop?@"Image_danmutop":@"Image_danmutopn") forState:UIControlStateNormal];
    if (self.topBlock) {
        self.topBlock(self.isTop);
    }
}

@end
