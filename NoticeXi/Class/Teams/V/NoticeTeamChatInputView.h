//
//  NoticeTeamChatInputView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/2.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeScroEmtionView.h"
#import "NoticeChocieImgListView.h"
#import "NoticeTeamTextView.h"
#import "NoticeAtTeamsListView.h"
#import "NoticeTeamChatModel.h"
#import "NoticeTeamRpelyView.h"
#import "NoticeGroupListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamChatInputView : UIView<UITextViewDelegate,NoticeRecordDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NoticeTeamTextView *contentView;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, copy) void (^imgBlock)(NSMutableArray *  _Nonnull imagArr);
@property (nonatomic, copy) void (^sendTextBlock)(NSString *sendText,NoticeTeamChatModel *replyMsgModel,NSString * __nullable atPersons);
@property (nonatomic, copy) void (^emtionBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *recoderBtn;
@property (nonatomic, strong) UIButton *pzBtn;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, copy) void (^uploadVoiceBlock)(NSString *localPath,NSString *timeLength,NSString *upSuccessPath,BOOL upSuccess,NSString *bucketId);
@property (nonatomic, copy) void (^uploadimgBlock)(NSData *imgData,NSString *upSuccessPath,BOOL upSuccess,NSString *bucketId);
@property (nonatomic, copy) void (^startRecoderOrPzStopPlayBlock)(BOOL stopPlay);//开始录音或者拍照，停止播放音频回调
@property (nonatomic, assign) BOOL isresiger;
@property (nonatomic, copy) void (^orignYBlock)(CGFloat y);
@property (nonatomic, strong) NoticeTeamChatModel * __nullable replyMsgModel;

@property (nonatomic, strong) NoticeTeamRpelyView *replayView;
- (void)remvokUserId:(NSString *)userId;
- (void)refreshManageUserId:(NSString *)userId;
- (void)sendTime:(NSString *)time path:(NSString *)path;
- (void)regFirst;
- (void)replyMsg;
- (void)requestPerson;
- (void)upLoadHeader:(NSData *)image path:(NSString * __nullable)path;
@property (nonatomic, strong) NoticeGroupListModel *teamModel;
@property (nonatomic, assign) BOOL needBack;
@property (nonatomic, strong) NSMutableArray * currentSelectedPersonItems;

@property (nonatomic, strong) NoticeAtTeamsListView *atPersonView;
@property (nonatomic, strong) NSMutableArray *personArr;
@end

NS_ASSUME_NONNULL_END
