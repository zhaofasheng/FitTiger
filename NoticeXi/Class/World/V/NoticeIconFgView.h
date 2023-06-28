//
//  NoticeIconFgView.h
//  NoticeXi
//
//  Created by li lei on 2023/2/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeIconFgView : UIView
@property (nonatomic, strong) NSMutableArray *iconSongArr;
@property (nonatomic, strong) NSArray *iconArr;

@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UIImageView *imageV4;
@property (nonatomic, strong) UIImageView *imageV5;

@property (nonatomic, strong) NSMutableArray *viewArr;
@end

NS_ASSUME_NONNULL_END
