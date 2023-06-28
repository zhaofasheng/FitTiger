//
//  NoticeShareLineChatView.h
//  NoticeXi
//
//  Created by li lei on 2022/5/30.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChats.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareLineChatView : UIView
@property (nonatomic, strong) NoticeChats *chat;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameL;

@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UILabel *statusL;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UILabel *tcL;
@end

NS_ASSUME_NONNULL_END
