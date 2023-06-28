//
//  NoticeWhiteVoiceListCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeWhiteVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWhiteVoiceListCell : UICollectionViewCell
@property (nonatomic, strong) NoticeWhiteVoiceListModel *whiteVoiceM;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, assign) BOOL noLongTap;
@property (nonatomic, assign) BOOL isSendChat;
@property (nonatomic, assign) BOOL isFullMax;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, copy) void(^choiceModelBlock)(NoticeWhiteVoiceListModel *whiteModel);
@end

NS_ASSUME_NONNULL_END
