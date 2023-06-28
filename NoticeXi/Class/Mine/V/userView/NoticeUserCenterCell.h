//
//  NoticeUserCenterCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "DDHAttributedMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserCenterCell : BaseCell
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UIImageView *titleImageV;
@property (nonatomic, strong) UIImageView *subImageV;
@property (nonatomic, strong) UILabel *subMainL;
@property (nonatomic, assign) BOOL needImage;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, strong) NSMutableArray *photosUrlArr;
@end

NS_ASSUME_NONNULL_END
