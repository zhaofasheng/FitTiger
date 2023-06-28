//
//  NoticeUseTextView.h
//  NoticeXi
//
//  Created by li lei on 2020/12/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTeamChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUseTextView : UIView
@property (nonatomic, strong) UILabel *callChatNameL;
@property (nonatomic, strong) UILabel *callChatContentL;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) UIImageView *upImageView;
@property (nonatomic, strong) NoticeTeamChatModel *chatModel;
@property (nonatomic, copy) void (^locationUseBlock)(BOOL upLocation);
@end

NS_ASSUME_NONNULL_END
