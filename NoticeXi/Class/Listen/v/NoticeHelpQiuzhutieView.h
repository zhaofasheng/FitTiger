//
//  NoticeHelpQiuzhutieView.h
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeHelpListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpQiuzhutieView : UICollectionReusableView
@property (nonatomic, strong) UIImageView *hotImg;
@property (nonatomic, strong) UIImageView *helpImg;
@property (nonatomic, strong) UILabel *hotL;
@property (nonatomic, strong) UILabel *helpL;
@property (nonatomic, strong) NoticeHelpListModel *hotModel;
@property (nonatomic, strong) NoticeHelpListModel *recentModel;
@end

NS_ASSUME_NONNULL_END
