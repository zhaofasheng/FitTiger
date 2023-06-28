//
//  NoticeDanMuTypeChoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuTypeChoiceView : UIView

@property (nonatomic, strong) UIButton *moveBtn;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic,copy) void (^topBlock)(BOOL isTop);
@property (nonatomic,copy) void (^colorBlock)(NSString *color);
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end

NS_ASSUME_NONNULL_END
