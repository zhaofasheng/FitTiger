//
//  NoticeBokeTosatView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBokeTosatView : UIView
@property (nonatomic, strong)  UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void(^refreshDataBlock)(BOOL refresh);
- (void)showChoiceView;
@end

NS_ASSUME_NONNULL_END
