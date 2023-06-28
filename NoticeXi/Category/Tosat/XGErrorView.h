//
//  XGErrorView.h
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/3.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGErrorView : UIView

@property (nonatomic, copy) NSString *errorText;

- (id)initWithFrame:(CGRect)frame errorText:(NSString *)errorText;

@end
