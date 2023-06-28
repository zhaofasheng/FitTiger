//
//  NoticeLookImageCell.h
//  NoticeXi
//
//  Created by li lei on 2020/12/28.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "YYKit.h"
#import "NoticeBackQustionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLookImageCell : BaseCell
@property (nonatomic, strong) YYAnimatedImageView *looKImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *name1L;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NoticeBackQustionModel *questionM;
@property (nonatomic, strong) UIButton *lookImageBtn;
@property (nonatomic, copy) void (^gotImageBlock)(BOOL goImage);
@property (nonatomic, strong) UIButton *goFirstBtn;
@property (nonatomic, copy) void (^goFirstBlock)(BOOL goFirst);
@end

NS_ASSUME_NONNULL_END
