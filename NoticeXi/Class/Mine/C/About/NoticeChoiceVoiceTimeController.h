//
//  NoticeChoiceVoiceTimeController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceChoiceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceVoiceTimeController : BaseTableViewController
@property (nonatomic,copy) void (^typeBlock)(NSInteger timeType,NSString *yaer,NSString *mon,NSString *fromDay,NSString *toDay,NSInteger voiceType,NSInteger shareType,NSString *status);
@property (nonatomic,copy) void (^newViewBlock)(NoticeVoiceChoiceView *ChoiceView);
@property (nonatomic, strong) NoticeVoiceChoiceView *typeChoiceView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, strong) NSString * __nullable year;
@property (nonatomic, strong) NSString * __nullable status;
@property (nonatomic, strong) NSString * __nullable mon;
@property (nonatomic, strong) NSString * __nullable fromDay;
@property (nonatomic, strong) NSString * __nullable toDay;
@property (nonatomic, assign) NSInteger voiceType;
@end

NS_ASSUME_NONNULL_END
