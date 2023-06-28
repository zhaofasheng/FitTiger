//
//  NoticeTodayBestCell.h
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDrawList.h"
#import "NoticeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTodayBestCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) UIImageView *drawImageView;
@property (nonatomic, strong) UIImageView *backDrawImageView;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *tuyaL;
@property (nonatomic, strong) UIImageView *likeImagView;
@property (nonatomic, strong) UIImageView *tuyaImageView;
@property (nonatomic, strong) UIImageView *colliceiontImageView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *byL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, assign) BOOL isTuijian;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) LCActionSheet *isManagerSheet;
@end

NS_ASSUME_NONNULL_END
