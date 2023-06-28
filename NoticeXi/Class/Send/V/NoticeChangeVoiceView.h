//
//  NoticeChangeVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NoticeVoiceTypeCell.h"
#import "SoundTouchOperation.h"
#import "NoticeActShowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeVoiceView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) NSString *locaPath;
@property (nonatomic, strong) UILabel *upLeveL;
@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, strong) NSString *timeLen;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) NoticeVoiceTypeModel *currentModel;
@property (nonatomic,copy) void (^typeModelBlock)(NoticeVoiceTypeModel *model);
@property (nonatomic,copy) void (^newVoiceBlock)(NSString *path,NSString *timeLen);
- (void)show;

@end

NS_ASSUME_NONNULL_END
