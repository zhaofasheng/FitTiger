//
//  NoticeReadLyCell.h
//  NoticeXi
//
//  Created by li lei on 2021/6/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeLy.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeReadLyCell : BaseCell
@property (nonatomic, strong) NoticeLy *liuyan;
@property (nonatomic, strong) UIImageView *subiconImageView;
@property (nonatomic, strong) UILabel *subcontentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *numL;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *cirView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) void(^longTapBlock)(NoticeLy *lyM);
@end

NS_ASSUME_NONNULL_END
