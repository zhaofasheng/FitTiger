//
//  NoticeWhiteCardChatView.h
//  NoticeXi
//
//  Created by li lei on 2022/5/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChats.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWhiteCardChatView : UIView

@property (nonatomic, strong) NoticeChats *chat;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *getLabel;

@property (nonatomic, strong) UIView *fgView;
@end

NS_ASSUME_NONNULL_END
