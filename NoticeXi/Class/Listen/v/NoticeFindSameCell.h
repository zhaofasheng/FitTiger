//
//  NoticeFindSameCell.h
//  NoticeXi
//
//  Created by li lei on 2019/4/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeFindSame.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeFindSameCell : BaseCell
@property (nonatomic, strong) NoticeFindSame *sameModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL isBook;
@property (nonatomic, assign) BOOL isSong;
@property (nonatomic, strong) UIImageView *markImage;
@end

NS_ASSUME_NONNULL_END
