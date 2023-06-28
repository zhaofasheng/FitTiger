//
//  NoticeTextVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMovie.h"
#import "NoticeBook.h"
#import "NoticeSong.h"
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextVoiceController : UIViewController
@property (nonatomic, assign) BOOL backRoot;
@property (nonatomic, assign) BOOL isReEdit;

@property (nonatomic, assign) BOOL isFromActivity;
@property (nonatomic, assign) BOOL isFromGround;//从文字广场页跳转过来
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NoticeMovie *movice;
@property (nonatomic, strong) NoticeBook *book;
@property (nonatomic, strong) NoticeSong *song;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,copy) void (^reEditBlock)(NoticeVoiceListModel *voiceM);
@property (nonatomic,copy) void (^refreshBlock)(BOOL refresh);
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^deleteSaveModelBlock)(NSInteger index, BOOL noSend);
@property (nonatomic, assign) BOOL isSave;
@end

NS_ASSUME_NONNULL_END
