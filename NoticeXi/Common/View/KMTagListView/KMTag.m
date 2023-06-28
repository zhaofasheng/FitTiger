//
//  KMTag.m
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "KMTag.h"

@implementation KMTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setupWithText:(NSString*)text {
    
    self.text = text;
    self.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    self.font = [UIFont systemFontOfSize:14];
    UIFont* font = self.font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width + 20, size.height + 10);
    self.frame = frame;
    
}

- (void)setupCousTumeWithText:(NSString *)text{
    self.text = text;
    self.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    self.font = [UIFont systemFontOfSize:14];
    UIFont* font = self.font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width + 20, size.height + 10);
    self.frame = frame;
    self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.layer.cornerRadius = frame.size.height/2;
    self.layer.masksToBounds = YES;
}

@end
