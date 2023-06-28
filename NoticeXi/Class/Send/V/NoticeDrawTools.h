//
//  NoticeDrawTools.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWPopMenu.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NoticeChoicePenAndColorDelegate <NSObject>

@optional
- (void)choicePenWidth:(CGFloat)width;
- (void)choiceColorWith:(UIColor *)color;
- (void)choiceXpcWith:(CGFloat)width;
- (void)cancelXpcWith:(CGFloat)width  color:(UIColor *)color;

@end

@interface NoticeDrawTools : UIView
@property (nonatomic, strong)CWPopMenu *menu;
@property (nonatomic, strong)CWPopMenu *menu1;
@property (nonatomic, strong)CWPopMenu *colorMenu;
@property (nonatomic, weak) id <NoticeChoicePenAndColorDelegate>delegate;
@property (nonatomic, assign) CGFloat oldxpcWidth;
@property (nonatomic, strong) UIColor *oldColor;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) CGFloat oldWidth;

@property (nonatomic, assign)UIImageView *oldImageView1;
@property (nonatomic, assign)UIImageView *oldImageView2;

@property (nonatomic, assign) BOOL choicePen;
@end

NS_ASSUME_NONNULL_END
