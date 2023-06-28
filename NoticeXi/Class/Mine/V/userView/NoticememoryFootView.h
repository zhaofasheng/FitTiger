//
//  NoticememoryFootView.h
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticememoryFootView : UICollectionReusableView
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic,  assign) BOOL isPhoto;
@property (nonatomic, strong) NoticeAbout *realisAbout;
- (void)refreshFrame;
@end

NS_ASSUME_NONNULL_END
