//
//  NoticeJieYouShopHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJieYouShopHeaderView : UIView<NoticeRecordDelegate>
@property (nonatomic, strong) NoticeMyShopModel *myShopModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) FSCustomButton *noVoiceL;

@property (nonatomic, strong) UILabel *orderNumL;
@property (nonatomic, strong) UILabel *jingbNumL;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);

@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *timeL;
- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END
