//
//  NoticeVoicePinbi.h
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "NoticeManager.h"
#import "NoticeXi-Swift.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePinbiClickSuccess <NSObject>

@optional
- (void)pinbiSucess;
- (void)clickGuanzhu;
- (void)markSucess;
@end

@interface NoticeVoicePinbi : UIView<LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) LCActionSheet *pinbiSheet;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isMark;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, weak) id<NoticePinbiClickSuccess>delegate;
- (void)pinbiWithModel:(NoticeVoiceListModel *)model;
@end

NS_ASSUME_NONNULL_END
