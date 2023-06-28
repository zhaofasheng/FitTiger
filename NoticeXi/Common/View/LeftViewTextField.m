//
//  LeftViewTextField.m
//  NoticeXi
//
//  Created by li lei on 2020/1/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "LeftViewTextField.h"

@implementation LeftViewTextField

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 20, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 20, 0);
}
@end
