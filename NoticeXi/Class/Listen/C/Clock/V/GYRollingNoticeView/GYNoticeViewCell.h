//
//  GYNoticeViewCell.h
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSComent.h"
@interface GYNoticeViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) NoticeBBSComent *comM;

@end
