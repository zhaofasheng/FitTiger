//
//  NoticeNearSearchPersonCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeNearPerson.h"
#import "NoticeSendCardRecord.h"
@protocol NoticeDeleteFriendDelegate <NSObject>

@optional
- (void)deleteFriendIn:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNearSearchPersonCell : BaseCell
@property (nonatomic, strong) NoticeNearPerson *blackPerson;
@property (nonatomic, strong) NoticeNearPerson *whitePerson;
@property (nonatomic, strong) NoticeNearPerson *person;
@property (nonatomic, strong) NoticeSendCardRecord *recodM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id<NoticeDeleteFriendDelegate>delegate;
@property (nonatomic, assign) BOOL sendWhite;//送白噪声卡
@property (nonatomic, assign) BOOL sendAll;//群发
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, assign) BOOL isGrayList;//是灰名单
@property (nonatomic, strong) UIButton *sendWhiteBtn;
@property (nonatomic, strong) UIButton *errBtn;
@property (nonatomic, strong) UIButton *sureSendBtn;
@property (nonatomic, strong) UILabel *choiceL;
@property (nonatomic,copy) void (^sendBlock)(NoticeNearPerson *person);
@property (nonatomic,copy) void (^errBlock)(NoticeNearPerson *person);
@property (nonatomic,copy) void (^sureSendBlock)(NoticeNearPerson *person);
@end

NS_ASSUME_NONNULL_END
