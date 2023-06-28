//
//  NoticeManagerCiTiaoCell.h
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeManagerCiTiaoM.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePointDelegate <NSObject>

@optional
- (void)readPointSetSuccess:(NSInteger)index;

@end

@interface NoticeManagerCiTiaoCell : BaseCell

@property (nonatomic, weak) id<NoticePointDelegate>delegate;
@property (nonatomic, strong) NoticeManagerCiTiaoM *nextCiM;
@property (nonatomic, strong) NoticeManagerCiTiaoM *ciM;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *passCode;

@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong) UILabel *introL;
@property (nonatomic, assign) NSInteger index;


@end

NS_ASSUME_NONNULL_END
