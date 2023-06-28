//
//  NoticeMyFriendCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyFriends.h"
#import "NoticeMyCareModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePiPeiChoiceDelegate <NSObject>

@optional
- (void)choicePipeiUserWithTag:(NSInteger)tag;
- (void)tapIconWithTag:(NSInteger)tag;
- (void)sendImageToFriend:(NoticeMyFriends *)user;
@end

@interface NoticeMyFriendCell : BaseCell
@property (nonatomic, strong) NoticeMyFriends *friends;
@property (nonatomic, strong) NoticeMyCareModel *careModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *friendTimeL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL isPipei;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) BOOL isCall;//打电话
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIImage *sendImage;
@property (nonatomic, weak) id <NoticePiPeiChoiceDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
