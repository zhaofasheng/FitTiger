//
//  NoticeNewChatVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChatsCell.h"
#import "NoticeStaySys.h"
#import "NoticeSendView.h"
#import "NoticeScroEmtionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewChatVoiceView : UIView<UITableViewDelegate,UITableViewDataSource,NoticeLongTapDeledate,NoticeReceveMessageSendMessageDelegate,LCActionSheetDelegate,NoticeSendDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeSendView *sendView;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *identType;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) NSString *voiceUserId;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) BOOL isFirst;  //YES  下拉
@property (nonatomic, assign) BOOL isBack;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL moveToBottom;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, strong) NoticeChats *currentModel;
@property (nonatomic, strong) NoticeChats *choiceModel;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, assign) CGFloat draFlot;
@property (nonatomic, assign) CGFloat progross;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL isClickChonbo;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic,copy) void (^hsBlock)(BOOL hs);
@property (nonatomic,copy) void (^textBlock)(BOOL hs);
@property (nonatomic, copy) void (^emtionBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic,copy) void (^hideBlock)(BOOL ish);
@property (nonatomic,copy) void (^reSendBlock)(NoticeChats *reChat);
@property (nonatomic,copy) void (^photoBlock)(NSMutableArray *photoArr);
@property (nonatomic, strong) UIButton *colseBtn;
@property (nonatomic, strong) UIButton *rulBtn;
@property (nonatomic, strong) LCActionSheet *juSheet;
@property (nonatomic, strong) LCActionSheet *selfSheet;
@property (nonatomic, strong) NoticeStaySys *stayChat;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, strong) NoticeChats * __nullable reSendChat;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, strong) LCActionSheet *failSheet;
@property (nonatomic, strong) UIButton *recoBtn;
@property (nonatomic, strong) UIImageView *backImageViews;
- (void)deleteSave:(NoticeChats *)chat;
- (void)show;
- (void)hsClick;
- (void)scroToBottom;
- (void)close;

@end

NS_ASSUME_NONNULL_END
