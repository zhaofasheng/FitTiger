//
//  NewReplyVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeReplyVoiceCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReplyVoiceView : UIView<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate,NoticeReplyDeleteAndPoliceDeleage,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSInteger oldtag;
@property (nonatomic, strong) NoticeVoiceChat *oldChat;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong) NoticeVoiceChat *choiceChat;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, assign) BOOL isRequesting;  //加载中
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)show;
@end

NS_ASSUME_NONNULL_END
