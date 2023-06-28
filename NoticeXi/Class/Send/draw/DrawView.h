//
//  DrawView.h
//  10-涂鸦画板
//
//  Copyright (c) 2019年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DrawDelegate <NSObject>

@optional
- (void)hasDraw;
- (void)refreshHasUndo:(BOOL)hasUndo hasReback:(BOOL)hasReback;
- (void)hasMoveX:(CGFloat)x moveY:(CGFloat)y;
@end

@interface DrawView : UIView

@property (nonatomic, weak) id <DrawDelegate>delegate;
@property (nonatomic, assign) NSInteger drawViewType;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL isTrans;
// 线段的颜色
@property (nonatomic, strong) UIColor *lineColor;

// 获取选中的照片
@property (nonatomic, strong) UIImage *image;

// 清屏
- (void)clear;

// 撤销
- (void)undo;

//恢复撤销的
- (void)reBack;
@end
