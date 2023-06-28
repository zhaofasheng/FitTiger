//
//  NoticeSendViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGVoiceRecorder.h"
#import "NoticeVoiceTypeModel.h"
#import "NoticeTopicModel.h"
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendViewController : UIViewController
@property (nonatomic, assign) BOOL isNow;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *readId;
@property (nonatomic, strong) NSString *zjId;
@property (nonatomic, strong) NSString *voiceById;
@property (nonatomic, assign) BOOL isFromOpen;
@property (nonatomic, assign) BOOL isFromMain;
@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) BOOL isFromActivity;
@property (nonatomic, assign) BOOL isFromAddFriend;
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *resourcePath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, assign) BOOL noShow;
@property (nonatomic, assign) BOOL soonRecoder;//立刻录音
@property (nonatomic, assign) BOOL goRecoderAndLook;
@property (nonatomic, assign) BOOL noNeedBanner;
@property (nonatomic, strong) LGVoiceRecorder *recoder;
@property (nonatomic, assign) BOOL isLongTime;//是否是录制长语音
@property (nonatomic,copy) void (^reEditBlock)(NoticeVoiceListModel *voiceM);

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@property (nonatomic, strong) NSMutableArray *moveArr;

@property (nonatomic,copy) void (^reEditVoiceBlock)(NoticeTopicModel *topicM,NSMutableArray *moveArr,NSInteger status);

@property (nonatomic,copy) void (^refreshBlock)(BOOL refresh);
@property (nonatomic,copy) void (^finishOrCancelBlock)(BOOL finish);
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, assign) BOOL isEditVoice;
@property (nonatomic, strong) NSString *musicId;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) NoticeVoiceTypeModel *typeModel;

@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^deleteSaveModelBlock)(NSInteger index, BOOL noSend);
@end

NS_ASSUME_NONNULL_END
