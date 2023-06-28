//
//  NoticePhotoNavView.h
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSmallArrModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoNavView : UIView
@property (nonatomic, strong) NoticeSmallArrModel *imgModel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *numL;
@end

NS_ASSUME_NONNULL_END
