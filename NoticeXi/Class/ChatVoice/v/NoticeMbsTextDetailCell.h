//
//  NoticeMbsTextDetailCell.h
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMoivceInCell.h"
#import "NoticeCustumBackImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMbsTextDetailCell : BaseCell<UIScrollViewDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *hsButton;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *sendBGBtn;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) NoticeCustumBackImageView *backImageView;
@property (nonatomic, strong) UIView *labelBackView;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic, strong) UIImageView *smallIconImageView;
@property (nonatomic, strong) UILabel *smallNickNameL;
@property (nonatomic,copy) void (^replyClickBlock)(BOOL isReply);
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, assign) BOOL noPushToUserCenter;
@property (nonatomic, strong) UIView *mbsView;
@end

NS_ASSUME_NONNULL_END
