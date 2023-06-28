//
//  NoticeNewTextVoieceCell.h
//  NoticeXi
//
//  Created by li lei on 2021/4/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMoivceInCell.h"
#import "NoticeCustumBackImageView.h"
#import "NoticeVoiceImageView.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeVoiceCommentView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewTextVoieceCell : BaseCell<UIScrollViewDelegate,UIGestureRecognizerDelegate,NoticeBBSComentInputDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *lyNumL;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *hsButton;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *sendBGBtn;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) UIView *labelBackView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, assign) BOOL isSendLy;//是否是留言
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic,copy) void (^addToZjBlock)(BOOL add);
@property (nonatomic,copy) void (^replyClickBlock)(BOOL isReply);
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, assign) BOOL noPushToUserCenter;
@property (nonatomic, strong) UILabel *likeStatusL;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic, strong) NoticeVoiceImageView *imageViewS;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *redNumL;

@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger pageNo;

@end

NS_ASSUME_NONNULL_END
