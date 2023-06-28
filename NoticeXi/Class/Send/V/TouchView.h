//
//  TouchView.h
//  TuYaBan2
//
//  Created by Ibokan on 15/9/24.
//  Copyright © 2015年 Crazy凡. All rights reserved.
//

#import <UIKit/UIKit.h> 

typedef void(^LMBlock)(CGPoint point , short flag);
@interface TouchView : UIView
@property (nonatomic,strong) LMBlock block;
@end
