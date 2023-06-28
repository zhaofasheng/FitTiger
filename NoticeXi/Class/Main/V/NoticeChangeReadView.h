//
//  NoticeChangeReadView.h
//  NoticeXi
//
//  Created by li lei on 2019/3/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NoiceRainSnowFlowerDelegate <NSObject>
@optional
- (void)getAminationWithTag:(NSInteger)tag;

@end

@interface NoticeChangeReadView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) id<NoiceRainSnowFlowerDelegate>delegate;

- (void)show;
@end

NS_ASSUME_NONNULL_END
