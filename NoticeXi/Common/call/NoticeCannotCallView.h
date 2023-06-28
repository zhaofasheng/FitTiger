//
//  NoticeCannotCallView.h
//  NoticeXi
//
//  Created by li lei on 2021/10/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCannotCallView : UIView

@property (nonatomic, strong) UIImageView *imageView;
- (void)show;
@property (nonatomic,copy) void (^closkBlock)(BOOL clock);
@end

NS_ASSUME_NONNULL_END
