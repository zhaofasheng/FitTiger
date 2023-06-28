//
//  TouchView.m
//  TuYaBan2
//
//  Created by Ibokan on 15/9/24.
//  Copyright © 2015年 Crazy凡. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.block([[touches anyObject]locationInView:self],0);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.block([[touches anyObject]locationInView:self],1);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.block([[touches anyObject]locationInView:self],2);
}
@end
