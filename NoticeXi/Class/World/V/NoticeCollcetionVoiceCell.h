//
//  NoticeCollcetionVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextSpaceLabel.h"
#import "NoticeVoicePinbi.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NoticeCollectionVoiceListClickDelegate <NSObject>
@optional

- (void)hasClickMoreWith:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)otherPinbSuccess;
- (void)moreMarkSuccess;
@end


@interface NoticeCollcetionVoiceCell : UICollectionViewCell<NoticePinbiClickSuccess>
@property (nonatomic, weak) id<NoticeCollectionVoiceListClickDelegate>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *dataButton;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) NoticeTextSpaceLabel *voiceLenL;
@property (nonatomic, assign) BOOL isGround;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *textNumL;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NSShadow *shadow;
@property (nonatomic, copy) void(^refreshHeight)(NSInteger refreshIndex);
@end

NS_ASSUME_NONNULL_END
