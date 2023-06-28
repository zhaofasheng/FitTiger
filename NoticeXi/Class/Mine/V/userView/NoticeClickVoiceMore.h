//
//  NoticeClickVoiceMore.h
//  NoticeXi
//
//  Created by li lei on 2019/6/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "NoticeRecoderView.h"
#import "NoticeZjListView.h"
#import "NoticeShareToWorld.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeVoiceClickMoreSuccess <NSObject>

@optional
- (void)moreClickChangeAreaSucess;
- (void)moreClickAddToZjSucess;
- (void)moreClickDeleteSucess;
- (void)moreClickSetPriSucess;
- (void)needStopBecauseLy;
- (void)moreClickPnlySelfSeeSucess;
- (void)moreClickEditSusscee:(NoticeVoiceListModel *)editModel;
- (void)clickShareVoice:(NoticeVoiceListModel *)editModel;
@end
@interface NoticeClickVoiceMore : UIView<LCActionSheetDelegate,NoticeRecordDelegate,NoticeShareToWorldSuccess>
@property (nonatomic, weak) id<NoticeVoiceClickMoreSuccess>delegate;
@property (nonatomic, strong) NoticeZjListView *listView;
@property (nonatomic, strong) LCActionSheet *priSheet;
@property (nonatomic, strong) NoticeShareToWorld *shareWorld;
@property (nonatomic, strong) LCActionSheet *priTextSheet;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
- (void)voiceClickMoreWith:(NoticeVoiceListModel *)model;
@end

NS_ASSUME_NONNULL_END
