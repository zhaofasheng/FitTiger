//
//  NoticeVoiceCommentCell.h
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceComModel.h"
#import "NoticeLelveImageView.h"
#import "NoticeDanMuModel.h"
#import "NoticeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceCommentCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeVoiceComModel *comModel;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *redNumL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, assign) NSString *jubaoContent;//举报的内容
@property (nonatomic,copy) void (^dissMissBlock)(BOOL diss);
@property (nonatomic,copy) void (^deleteComBlock)(NSString *comId);
@property (nonatomic,copy) void (^manageDeleteComBlock)(NSString *comId);
@property (nonatomic, assign) BOOL hadClickLike;
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UILabel *replyTimeL;
@property (nonatomic, strong) UIImageView *replyIconView;
@property (nonatomic, strong) UIImageView *replyIconMarkView;
@property (nonatomic, strong) UILabel *replyNameL;
@property (nonatomic, strong) UIImageView *replyZanImgView;
@property (nonatomic, strong) UILabel *replyLikeNumL;
@property (nonatomic,copy) void (^likeBlock)(NoticeVoiceComModel *comM);
@property (nonatomic, strong) UIView *moreView;


@end

NS_ASSUME_NONNULL_END
