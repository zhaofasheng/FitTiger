//
//  NoticeVoiceComDetailCell.h
//  NoticeXi
//
//  Created by li lei on 2022/2/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceComModel.h"
#import "NoticeManager.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceComDetailCell : BaseCell<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeVoiceComModel *comModel;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UILabel *replyTimeL;
@property (nonatomic, strong) UIImageView *replyIconView;
@property (nonatomic, strong) UIImageView *replyIconMarkView;
@property (nonatomic, strong) UILabel *replyNameL;
@property (nonatomic, strong) UIImageView *replyZanImgView;
@property (nonatomic, strong) UILabel *replyLikeNumL;
@property (nonatomic,copy) void (^dissMissBlock)(BOOL diss);
@property (nonatomic, assign) BOOL hadClickLike;
@property (nonatomic, strong) UIView *topfgView;
@property (nonatomic, strong) UIView *bottomfgView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic,copy) void (^likeBlock)(NoticeVoiceComModel *comM);
@property (nonatomic,copy) void (^deleteComBlock)(NSString *comId);
@property (nonatomic,copy) void (^manageDeleteComBlock)(NSString *comId);
@property (nonatomic, assign) NSString *jubaoContent;//举报的内容
@end

NS_ASSUME_NONNULL_END
