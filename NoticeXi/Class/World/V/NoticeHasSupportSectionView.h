//
//  NoticeHasSupportSectionView.h
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeHasSupportHelpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasSupportSectionView : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NSString *tieId;
@property (nonatomic, strong) void(^tieBlock)(NSString *tieiD);
@end

NS_ASSUME_NONNULL_END
