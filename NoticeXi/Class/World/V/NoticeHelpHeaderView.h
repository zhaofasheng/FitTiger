//
//  NoticeHelpHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2022/8/5.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeHelpListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpHeaderView : UIView
@property (nonatomic, strong) NoticeHelpListModel *helpModel;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UILabel *nickNameL;
@end

NS_ASSUME_NONNULL_END
