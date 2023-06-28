//
//  NoticeDanMuCell.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDanMuListModel.h"
#import "NoticeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeDanMuListModel *model;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic,copy) void (^deleteBlock)(NoticeDanMuListModel *model);
@end

NS_ASSUME_NONNULL_END
