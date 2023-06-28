//
//  NoticeHelpCommentCell.h
//  NoticeXi
//
//  Created by li lei on 2022/8/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeHelpCommentModel.h"
#import "NoticeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHelpCommentCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeHelpCommentModel *model;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, copy)  void (^deleteSuccess)(NSString *tieId);
@property (nonatomic, copy)  void (^deletesubSuccess)(NSString *tieId);
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *meL;
@property (nonatomic, strong) UILabel *redNumL;
@property (nonatomic, copy) void (^replyBlock)(NoticeHelpCommentModel *model);
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UILabel *replyTimeL;
@property (nonatomic, strong) UIImageView *replyIconView;
@property (nonatomic, strong) UILabel *replyNameL;
@property (nonatomic, strong) UIImageView *replyZanImgView;
@property (nonatomic, strong) UILabel *replyLikeNumL;
@property (nonatomic, strong) UILabel *replyMeL;
@property (nonatomic, strong) LCActionSheet *subsheet;

@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, strong) YYAnimatedImageView *replySendImageView;
@end

NS_ASSUME_NONNULL_END
