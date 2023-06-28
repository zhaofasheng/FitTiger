//
//  NoticeUserCenter.h
//  NoticeXi
//
//  Created by li lei on 2019/12/19.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjView.h"
#import "NoticeNoticenterModel.h"
#import "NoticeHasCenterData.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeUserCenterManagerDelegate <NSObject>

@optional
- (void)pushControllerWithType:(NSInteger)type;

@end

@interface NoticeUserCenter : UIView

@property (nonatomic, weak) id <NoticeUserCenterManagerDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame isOther:(BOOL)isOther;
@property (nonatomic, assign) BOOL haPeople;
@property (nonatomic, assign) BOOL isOther;//是否是看他人心情簿
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *peopleUserId;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeZjView *zjAll;
@property (nonatomic, strong) NoticeZjView *zjText;
@property (nonatomic, strong) NoticeZjView *zjLimit;
@property (nonatomic, strong) UIImageView *voiceImageV;
@property (nonatomic, strong) UIImageView *photoImageV;
@property (nonatomic, strong) UIImageView *timeImageV;
@property (nonatomic, strong) UIImageView *movieImageV;
@property (nonatomic, strong) UIImageView *bookImageV;
@property (nonatomic, strong) UIImageView *songImageV;
@property (nonatomic, strong) UIImageView *pyImageV;
@property (nonatomic, strong) UIImageView *drawImageV;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, strong) NoticeHasCenterData *hasDataModel;
@property (nonatomic, strong) UIView *buttonView;
@end

NS_ASSUME_NONNULL_END
