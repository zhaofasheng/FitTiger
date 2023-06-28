//
//  NoticeChatRecordView.h
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NoticeAudioRecordPhase) {
    NAudioRecordPhaseStart,
    NAudioRecordPhaseRecording,
    NAudioRecordPhaseCancelling,
    NAudioRecordPhaseEnd
};
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeSendMessageClickDelegate <NSObject>

@optional
- (void)clickSend;
- (void)clickEnd;

@end

@interface NoticeChatRecordView : UIView
@property (nonatomic, weak) id<NoticeSendMessageClickDelegate>delegate;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *cancelL;
@property (nonatomic, assign) NSTimeInterval recordTime;
@property (nonatomic, assign) NoticeAudioRecordPhase phase;

@end

NS_ASSUME_NONNULL_END
