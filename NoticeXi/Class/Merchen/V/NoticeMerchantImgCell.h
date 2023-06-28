//
//  NoticeMerchantImgCell.h
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeOpenTbModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMerchantImgCell : UITableViewCell
@property (nonatomic, strong) NoticeOpenTbModel *subModel;
@property (nonatomic, strong) UIImageView *merchantImgV;
@property (nonatomic, strong) UILabel *titleL;
@end

NS_ASSUME_NONNULL_END
