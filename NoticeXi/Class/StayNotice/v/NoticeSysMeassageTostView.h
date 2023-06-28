//
//  NoticeSysMeassageTostView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSysMeassageTostView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NoticeMessage *message;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *bottomL;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *logoImageView;
- (void)showActiveView;
@end

NS_ASSUME_NONNULL_END
