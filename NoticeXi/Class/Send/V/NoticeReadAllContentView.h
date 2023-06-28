//
//  NoticeReadAllContentView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceReadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeReadAllContentView : UIView
@property (nonatomic, strong) NoticeVoiceReadModel *readModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *disBtn;
- (void)refreshUI;
@property (nonatomic, assign) BOOL isRecoder;
@property (nonatomic, copy) void(^cancelBlock)(BOOL cancel);
@end

NS_ASSUME_NONNULL_END
