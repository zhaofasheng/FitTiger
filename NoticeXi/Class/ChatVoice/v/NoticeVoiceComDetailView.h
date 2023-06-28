//
//  NoticeVoiceComDetailView.h
//  NoticeXi
//
//  Created by li lei on 2022/2/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSComentInputView.h"
#import "NoticeVoiceCommentCell.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceComDetailView : UIView<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UIGestureRecognizerDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, strong) NoticeVoiceComModel *comModel;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, assign) BOOL fromBokeMsg;
@property (nonatomic, strong) NSString *comId;
@property (nonatomic, strong) NSString *voiceId;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDown; //YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, assign) BOOL noRequest;
@property (nonatomic, assign) BOOL noInputView;//不需要输入框
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) NSString *jubaoContent;//举报的内容
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic,copy) void (^dissMissBlock)(BOOL diss);
@property (nonatomic,copy) void (^deleteComBlock)(NSString *comId);
@property (nonatomic,copy) void (^likeBlock)(NoticeVoiceComModel *comM);
- (void)sendCommentWithText:(NSString *)text voiceId:(NSString *)voiceid subId:(NSString *)subId;
- (void)show;

@end

NS_ASSUME_NONNULL_END
