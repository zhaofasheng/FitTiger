//
//  NoticeCustumButton.m
//  NoticeXi
//
//  Created by li lei on 2019/3/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumButton.h"

@implementation NoticeCustumButton

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.height, frame.size.height)];
        [self addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+7, 0, frame.size.width-7-self.imageView.frame.size.width, frame.size.height)];
        self.label.font = THRETEENTEXTFONTSIZE;
        self.label.textColor = [UIColor colorWithHexString: [NoticeTools isWhiteTheme] ? @"#B8B0B0":@"#72727f"];
        [self addSubview:self.label];
        
        self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake(45/4*3, 0, 14, 14)];
        self.selectView.image = UIImageNamed([NoticeTools isWhiteTheme] ? @"ll_select_img":@"ll_select_imgye");
        [self addSubview:self.selectView];
        self.selectView.hidden = YES;
    }
    return self;
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.selectView.hidden = !isSelect;
}

- (void)setImageView:(NSString *)imageName label:(NSString *)labelName{
    self.imageView.image = UIImageNamed(imageName);
    self.label.text = labelName;
}

@end
