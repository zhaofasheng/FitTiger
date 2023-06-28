//
//  NoticeManager.h
//  NoticeXi
//
//  Created by li lei on 2019/6/24.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeManagerUserDelegate <NSObject>
@optional
- (void)sureManagerClick:(NSString *_Nullable)code;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManager : UIView
@property (nonatomic, strong) UIView *tostView;
@property (nonatomic, weak) id<NoticeManagerUserDelegate>delegate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UILabel *markL;
- (void)show;

@end

NS_ASSUME_NONNULL_END
