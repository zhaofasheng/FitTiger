//
//  NoticeRetestHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2019/1/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeTestDetailDelegate <NSObject>

@optional
- (void)tapWithTypeOrNum:(BOOL)isType;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRetestHeaderView : UIView
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIImageView *tongzuImageView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *addnums;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, weak) id <NoticeTestDetailDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
