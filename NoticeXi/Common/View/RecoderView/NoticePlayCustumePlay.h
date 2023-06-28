//
//  NoticePlayCustumePlay.h
//  NoticeXi
//
//  Created by li lei on 2021/8/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeCustumMusiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePlayCustumePlay : UIView
@property (nonatomic, strong) NoticeCustumMusiceModel *musicModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *songNameL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *musicBtn;
@end

NS_ASSUME_NONNULL_END
