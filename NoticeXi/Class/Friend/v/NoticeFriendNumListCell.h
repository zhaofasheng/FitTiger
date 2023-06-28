//
//  NoticeFriendNumListCell.h
//  NoticeXi
//
//  Created by li lei on 2019/3/6.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeFriendNum.h"



NS_ASSUME_NONNULL_BEGIN

@protocol FriendListDelegate <NSObject>

@optional
- (void)playVoiceWith:(NSInteger)index;
- (void)clickButtonInCellWith:(NSInteger)index;
@end

@interface NoticeFriendNumListCell : UITableViewCell
@property (nonatomic, weak) id <FriendListDelegate>delegate;
@property (nonatomic, strong) NoticeFriendNum *people;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *whiteV;
@end

NS_ASSUME_NONNULL_END
