//
//  NoticeReadEveryDayCell.h
//  NoticeXi
//
//  Created by li lei on 2021/6/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeReadEveryDayCell : UITableViewCell

@property (nonatomic, strong) NoticeBannerModel *bannerM;

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
