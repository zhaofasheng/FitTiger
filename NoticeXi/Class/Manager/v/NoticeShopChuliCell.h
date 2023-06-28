//
//  NoticeShopChuliCell.h
//  NoticeXi
//
//  Created by li lei on 2022/7/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeShopChuliModel.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopChuliCell : BaseCell<NoticeBBSComentInputDelegate>
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) NoticeShopChuliModel *chuliM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIButton *agereeBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) NoticeDanMuModel *boKeModel;
@property (nonatomic, strong) NoticeAbout *userM;
@property (nonatomic, strong) UILabel *staltusL;
@property (nonatomic, strong) NoticeBBSComentInputView *inputV;

@property (nonatomic, copy) void(^outWhiteBlock)(NoticeAbout *userM);
@end

NS_ASSUME_NONNULL_END
