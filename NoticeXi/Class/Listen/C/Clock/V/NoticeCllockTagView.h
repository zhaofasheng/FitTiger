//
//  NoticeCllockTagView.h
//  NoticeXi
//
//  Created by li lei on 2020/4/14.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCllockTagView : UIView
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *requestBtn;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, assign) NSInteger currentChoice;
@property (nonatomic, assign) BOOL isSendTc;
@property (nonatomic,copy) void (^setTagBlock)(NSInteger clockTag);
@end

NS_ASSUME_NONNULL_END
