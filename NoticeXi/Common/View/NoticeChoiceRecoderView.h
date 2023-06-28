//
//  NoticeChoiceRecoderView.h
//  NoticeXi
//
//  Created by li lei on 2020/8/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceRecoderView : UIView
@property (nonatomic,copy) void (^choiceTag)(NSInteger tag);
@property (nonatomic, strong)  UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;

- (instancetype)initWithShowChoiceSendType;
- (void)showChoiceView;
@end

NS_ASSUME_NONNULL_END
