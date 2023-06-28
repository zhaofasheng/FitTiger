//
//  RXPopBoxCell.m
//  COMEngine
//
//  Created by 赵发生 on 2021/2/25.
//  Copyright © 2021 赵发生. All rights reserved.
//

#import "RXPopBoxCell.h"

@implementation RXPopBoxCell

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.contentView.backgroundColor = backColor;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bottomLabel.textColor = [UIColor whiteColor];
        self.bottomLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.bottomLabel];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-1, (frame.size.height-20)/2, 1, 20)];
        self.line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
        // 动画高亮变色效果
    [UIView animateWithDuration:0.2 animations:^{
        if (highlighted) {
            self.contentView.backgroundColor = [UIColor blackColor];
        } else {
            self.contentView.backgroundColor = self.backColor;
        }
    }];
}

@end
