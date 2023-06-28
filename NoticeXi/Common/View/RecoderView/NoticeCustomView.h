//
//  NoticeCustomView.h
//  NoticeXi
//
//  Created by li lei on 2018/11/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustomView : UIView
@property (nonatomic, strong) UIScrollView *scroVlew;
@property (nonatomic, strong) YYImage *yyImage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UILabel *textL;
@end

NS_ASSUME_NONNULL_END
