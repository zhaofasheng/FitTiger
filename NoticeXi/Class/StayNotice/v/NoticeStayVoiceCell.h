//
//  NoticeStayVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMessage.h"
@protocol NoticeAgreeFriendDelegate <NSObject>

- (void)agreaaFriendWith:(NSInteger)index;
- (void)refusFriendWith:(NSInteger)index;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeStayVoiceCell : BaseCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<NoticeAgreeFriendDelegate>delegate;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) NoticeMessage *message;
@property (nonatomic, strong) NoticeMessage *other;
@property (nonatomic, strong) NoticeMessage *bbsM;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *voitImagView;
@property (nonatomic, strong) UIButton *agreenBtn;
@end

NS_ASSUME_NONNULL_END
