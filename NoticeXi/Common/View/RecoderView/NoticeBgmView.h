//
//  NoticeBgmView.h
//  NoticeXi
//
//  Created by li lei on 2021/3/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeRecoderMusicCell.h"
#import "NoticeAddCustumeMusicView.h"
#import "NoticePlayCustumePlay.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBgmView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *line;
@property (nonatomic,copy) void (^musicTapBlock)(NSString *url);
@property (nonatomic,copy) void (^stopRecoderIngBlock)(BOOL stop);
@property (nonatomic,copy) void (^choiceZdyBlock)(NoticeTextZJMusicModel *currentM);
@property (nonatomic,copy) void (^musicCurrentIDBlock)(NoticeTextZJMusicModel *musicM);
@property (nonatomic,copy) void (^stopMusicTapBlock)(BOOL stop);
@property (nonatomic,copy) void (^refreshOringYBlock)(CGFloat oringY);
@property (nonatomic,copy) void (^useMusicBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic,copy) void (^useMusicPauseBlock)(NoticeCustumMusiceModel *model);
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, assign) BOOL needAutoRecoder;
@property (nonatomic, strong) UIView *noMusicView;
@property (nonatomic,copy) void (^pauseMusicTapBlock)(BOOL pause);
@property (nonatomic, strong) NoticeAddCustumeMusicView *custumeMusicView;
@property (nonatomic, strong) NoticePlayCustumePlay *playCustumeView;
@property (nonatomic, strong) UIView *headerV;
- (void)surecloseclick;
- (void)noBgmChoice;
- (void)refresStop:(NoticeTextZJMusicModel *)currentM;
@end

NS_ASSUME_NONNULL_END
