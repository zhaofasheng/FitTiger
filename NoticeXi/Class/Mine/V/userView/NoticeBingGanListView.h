//
//  NoticeBingGanListView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeClockPyModel.h"
#import "NoticeDrawList.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBingGanListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *keyView;
- (void)showTost;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) NoticeDrawList *scDrawM;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *titleImageV;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NoticeClockPyModel *scModel;
@property (nonatomic, strong) NoticeClockPyModel *scTCModel;
@property (nonatomic, strong) UILabel *titleL;
@end

NS_ASSUME_NONNULL_END
