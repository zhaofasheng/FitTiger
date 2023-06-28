//
//  NoticeChoiceBgmTypeView.h
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBgmTypeCell.h"
#import "NoticeCustumMusiceModel.h"
#import "NoticeActShowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceBgmTypeView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *tuiArr;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isFromRecodering;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) UIView *tuijianHeadereView;
@property (nonatomic, strong) UIView *addHeaderView;
@property (nonatomic, strong) UIView *howHeaderView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *howButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) NSInteger currentStatus;//当前步骤
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, strong) NoticeTextZJMusicModel *currentMusicModel;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic,copy) void (^useMusicBlock)(NSString *url,NSString *bgmId,NSInteger bgmType,NSString *bgmName);

@property (nonatomic, strong) NoticeUserInfoModel *userM;

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UILabel *erroL;

- (void)show;
@end

NS_ASSUME_NONNULL_END
