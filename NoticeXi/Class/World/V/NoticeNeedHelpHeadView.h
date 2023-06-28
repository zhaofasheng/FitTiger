//
//  NoticeNeedHelpHeadView.h
//  NoticeXi
//
//  Created by li lei on 2023/2/9.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeHelpListModel.h"
#import "NoticeIconFgView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNeedHelpHeadView : UIView
@property (nonatomic, strong) NoticeHelpListModel *hotModel;
@property (nonatomic, strong) NoticeHelpListModel *recentModel;

@property (nonatomic, strong) UIImageView *hotImg;
@property (nonatomic, strong) UIImageView *helpImg;
@property (nonatomic, strong) UILabel *hotL;
@property (nonatomic, strong) UILabel *helpL;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *hotView;
@property (nonatomic, strong) UIView *recentView;

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UIImageView *editImageView;

@property (nonatomic, strong) UIView *commentView1;
@property (nonatomic, strong) UILabel *comL1;
@property (nonatomic, strong) UIImageView *editImageView1;

@property (nonatomic, strong) NoticeIconFgView *recFgIconView;
@property (nonatomic, strong) NoticeIconFgView *hotFgIconView;
@property (nonatomic, strong) UILabel *hotNumL;
@property (nonatomic, strong) UILabel *recNumL;
- (void)request;
@end

NS_ASSUME_NONNULL_END
