//
//  NoticeButtonSelectView.h
//  NoticeXi
//
//  Created by li lei on 2023/5/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeButtonSelectView : UIView
@property (nonatomic, copy) void(^choiceSelectIndexBlock)(NSInteger index);
@property (nonatomic, assign) NSInteger choiceIndex;

@property (nonatomic, strong) UILabel *voiceBtn;
@property (nonatomic, strong) UILabel *groupBtn;
@property (nonatomic, strong) UILabel *helpBtn;

@property (nonatomic, assign) CGFloat nomerWidth1;
@property (nonatomic, assign) CGFloat nomerWidth2;
@property (nonatomic, assign) CGFloat nomerWidth3;

@property (nonatomic, assign) CGFloat boldWidth1;
@property (nonatomic, assign) CGFloat boldWidth2;
@property (nonatomic, assign) CGFloat boldWidth3;

@property (nonatomic, strong) UIImageView *bowenImageView;
@end

NS_ASSUME_NONNULL_END
