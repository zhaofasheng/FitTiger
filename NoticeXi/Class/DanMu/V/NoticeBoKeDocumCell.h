//
//  NoticeBoKeDocumCell.h
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeDocumCell : BaseCell
@property (nonatomic, strong) NoticeDanMuModel *model;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *eidtButton;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^deleteBlock)(NSInteger index);
@property (nonatomic, copy) void(^deleteNetBlock)(NoticeDanMuModel *bokM);
@property (nonatomic, copy) void(^suredeleteBlock)(NSInteger index);

@property (nonatomic, strong) NSString *filepath;
@property (nonatomic, strong) UIImage *cutsumeImg;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *bucketId;
@end

NS_ASSUME_NONNULL_END
