//
//  NoticeTeamRpelyView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/15.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamRpelyView : UIView
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, copy) void (^closeUseBlock)(BOOL close);
@property (nonatomic, assign) BOOL isSelf;
@end

NS_ASSUME_NONNULL_END
