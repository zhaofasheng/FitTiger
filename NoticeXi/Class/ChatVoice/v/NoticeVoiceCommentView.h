//
//  NoticeVoiceCommentView.h
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBBSComentInputView.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceCommentView : UIView<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,UIGestureRecognizerDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, assign) BOOL noRequest;
@property (nonatomic, assign) BOOL isVoiceDetail;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, copy) void(^numBlock)(NSString *num);
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
- (void)closeClick;
- (void)sendCommentWithText:(NSString *)text voiceId:(NSString *)voiceid subId:(NSString *)subId;
- (void)show;
@end

NS_ASSUME_NONNULL_END
