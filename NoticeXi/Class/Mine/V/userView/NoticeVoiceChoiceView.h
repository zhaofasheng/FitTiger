//
//  NoticeVoiceChoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceChoiceView : UIView
@property (nonatomic, strong) UIButton *voiceBbn;
@property (nonatomic, strong) UIButton *textBtn;
@property (nonatomic, strong) UIButton *yearBbn;
@property (nonatomic, strong) UIButton *monBtn;
@property (nonatomic, strong) UIButton *dayBtn;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger gsType;
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, assign) NSInteger statusType;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIButton *timeButton2;
@property (nonatomic, strong) UIButton *timeButton3;
@property (nonatomic, strong) UIButton *shareBbn;
@property (nonatomic, strong) UIButton *noshareBbn;
@property (nonatomic, strong) UIButton *noshareBbn1;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) UIButton *kxBbn;
@property (nonatomic, strong) UIButton *sqBbn;
@property (nonatomic, strong) UIButton *pdBbn;
@property (nonatomic, strong) UIButton *ngBbn;
@property (nonatomic, strong) UIView *buttonView1;
@property (nonatomic, strong) UIView *buttonView2;
@property (nonatomic, strong) UIView *tofromView;

@property (nonatomic,copy) void (^choiceTimeBlock)(NSInteger type);
@property (nonatomic,copy) void (^choiceClickBlock)(NSInteger type);
@property (nonatomic,copy) void (^voiceTypeBlock)(NSInteger voiceType);
@property (nonatomic,copy) void (^shareClickBlock)(NSInteger voiceType);
@property (nonatomic,copy) void (^statusClickBlock)(NSString *status);
@property (nonatomic, strong) NoticeVoiceStatusModel *statusM;
@property (nonatomic, strong) NSMutableArray *dataArr;


@end

NS_ASSUME_NONNULL_END
