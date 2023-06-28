//
//  NoticeBannerCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBannerCell : BaseCell
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIImageView *bannerImageV;
@property (nonatomic, strong) UIImageView *contentImageV;
@property (nonatomic, strong) NoticeBannerModel *bannerM;
@property (nonatomic,copy) void (^refreshBlock)(BOOL refresh);
@property (nonatomic,copy) void (^changeBlock)(NSString *bannerId);
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
