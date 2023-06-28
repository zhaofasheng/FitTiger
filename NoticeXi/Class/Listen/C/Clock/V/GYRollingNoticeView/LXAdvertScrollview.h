//
//  LXAdvertScrollview.h
//  LXAdvertScrollview
//
//  Created by chenergou on 2018/1/4.
//  Copyright © 2018年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYNoticeViewCell.h"
@interface LXAdvertScrollview : UIView
@property (nonatomic, assign) BOOL isStr;
@property (nonatomic, assign) BOOL needBackGround;
@property (nonatomic, strong) NSMutableArray *comArr;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
@property(nonatomic,strong)NSTimer *timer;
@end
