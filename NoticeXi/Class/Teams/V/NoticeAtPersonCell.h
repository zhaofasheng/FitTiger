//
//  NoticeAtPersonCell.h
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "YYPersonItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAtPersonCell : BaseCell
@property (nonatomic, strong) YYPersonItem *person;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) BOOL canChoiceMore;
@property (nonatomic, assign) BOOL listView;
@property (nonatomic, strong) UIImageView *chocieImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) NSString *identity;
@end

NS_ASSUME_NONNULL_END
