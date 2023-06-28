//
//  NoticeShareLinkCell.h
//  NoticeXi
//
//  Created by li lei on 2020/12/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareLinkCell : UIView
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isJoinGroupVoice;
@property (nonatomic, copy)  void(^dissMissTapBlock)(BOOL diss);
@end

NS_ASSUME_NONNULL_END
