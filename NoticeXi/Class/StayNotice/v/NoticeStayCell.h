//
//  NoticeStayCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeStaySys.h"
#import "NoticeManagerGroupReplyModel.h"
#import "NoticeMoveMemberModel.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeStayCell : BaseCell
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NoticeStaySys *stay;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL canTap;
@property (nonatomic, assign) BOOL isHUIS;
@property (nonatomic, assign) BOOL isSL;
@property (nonatomic, assign) BOOL needTm;
@property (nonatomic, strong) UIView *mbView;

@property (nonatomic, strong) NoticeManagerGroupReplyModel *groupModel;
@property (nonatomic, strong) NoticeStaySys *tuyaModel;
@property (nonatomic, strong) UIImageView *subImageV;
@property (nonatomic, strong) UIButton *whoBtn;
@property (nonatomic, strong) NoticeMoveMemberModel *moveModel;
@property (nonatomic, copy) void(^longtapBlock)(NoticeStaySys *stay);
@property (nonatomic, strong) UIButton *failButton;
@end

NS_ASSUME_NONNULL_END
