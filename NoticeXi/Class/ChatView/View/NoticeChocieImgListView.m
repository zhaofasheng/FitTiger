//
//  NoticeChocieImgListView.m
//  NoticeXi
//
//  Created by li lei on 2022/5/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChocieImgListView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticePreViewPhoto.h"
static CGFloat itemMargin = 5;

@interface NoticeChocieImgListView()

@property (nonatomic, strong) NoticePreViewPhoto *photoPreView;

@property (nonatomic, strong) NSMutableArray *choiceModels;

@end

@implementation NoticeChocieImgListView

- (NSMutableArray *)choiceModels{
    if (!_choiceModels) {
        _choiceModels = [[NSMutableArray alloc] init];
    }
    return _choiceModels;
}

- (NoticePreViewPhoto *)photoPreView{
    if (!_photoPreView) {
        _photoPreView = [[NoticePreViewPhoto alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _photoPreView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWH = (DR_SCREEN_WIDTH - 4 * itemMargin) / 4;
        _layout.itemSize = CGSizeMake(itemWH, itemWH);
        _layout.minimumInteritemSpacing = itemMargin;
        _layout.minimumLineSpacing = itemMargin;
        CGRect frame = self.bounds;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-44-BOTTOM_HEIGHT) collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = NO;
  
        [self addSubview:_collectionView];
        [_collectionView registerClass:[TZAssetCell class] forCellWithReuseIdentifier:@"TZAssetCell"];
        
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-66, CGRectGetMaxY(_collectionView.frame)+8, 66, 28)];
        [self.sendButton setTitle:[NoticeTools getLocalStrWith:@"read.send"] forState:UIControlStateNormal];
        
        
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = TWOTEXTFONTSIZE;
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.sendButton.layer.cornerRadius = 4;
        self.sendButton.layer.masksToBounds = YES;
        [self addSubview:self.sendButton];
        [self.sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.albumView = [[NoticeAlbumView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-44-BOTTOM_HEIGHT)];
        self.albumView.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-44-BOTTOM_HEIGHT);
        self.albumView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-44);
        self.albumView.delegate = self;
        [self addSubview:self.albumView];
        self.albumView.hidden = YES;
        
        [self addSubview:self.titleButton];
    }
    return self;
}

- (void)sendClick{
    if (self.choiceArr.count) {
        for (TZAssetModel *assetM in self.choiceArr) {
            if (assetM.asset) {
                [self.assetArr addObject:assetM.asset];
            }
        }
        if (self.assetArr.count) {
            if (self.didSelectPhotosMBlock) {
                self.didSelectPhotosMBlock(self.assetArr);
                self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            }
        }
    }
}

- (void)choiceWith:(TZAlbumModel *)albumM{
   
    self.model = albumM;
    self.models = [NSMutableArray arrayWithArray:self.model.models];
    [self closeClick];
    [self.titleButton setTitle:[NSString stringWithFormat:@"%@ ",_model.name] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}


//切换相册
- (void)closeClick{
    if (!self.isDrop) {
        self.albumView.hidden = NO;
        self.collectionView.hidden = YES;
        _titleButton.imageView.transform =  CGAffineTransformMakeRotation(-M_PI);
        
    }else{
        self.albumView.hidden = YES;
        self.collectionView.hidden = NO;
        _titleButton.imageView.transform =  CGAffineTransformMakeRotation(0);
    }
    CATransition *test1 = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.collectionView];
    [self.collectionView.layer addAnimation:test1 forKey:@"pushanimation"];
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.albumView];
    [self.albumView.layer addAnimation:test forKey:@"pushanimation"];
    self.isDrop = !self.isDrop;
}

- (FSCustomButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [FSCustomButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(20, CGRectGetMaxY(self.collectionView.frame)+8, 100, 28);
        [_titleButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_titleButton setImage:[UIImage imageNamed:@"phoneupd"] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        _titleButton.buttonImagePosition = FSCustomButtonImagePositionRight;
        _titleButton.imageView.transform =  CGAffineTransformMakeRotation(0);
    }
    return _titleButton;
}



#pragma mark - UICollectionViewDataSource && Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TZAssetModel *model;
    model = _models[indexPath.item];
    [self.choiceModels removeAllObjects];
    [self.choiceModels addObject:model];
    self.photoPreView.models = self.choiceModels;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TZAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZAssetCell" forIndexPath:indexPath];
    cell.photoDefImage = [UIImage imageNamedFromMyBundle:@"photo_def_photoPickerVc"];//
    cell.photoSelImage = [UIImage imageNamedFromMyBundle:@"selectorImage"];
    cell.useCachedImage = YES;
    cell.isCustume = YES;
    cell.allowPreview = YES;
    cell.allowPickingMultipleVideo = YES;
    TZAssetModel *model;
    model = _models[indexPath.item];
    cell.allowPickingGif = YES;
    cell.model = model;
    
    //如果大于限制数量
    if (self.choiceArr.count >= (self.limitNum?self.limitNum: 3)) {
        cell.cannotSelectLayerButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        cell.cannotSelectLayerButton.hidden = NO;
    }else{
        cell.cannotSelectLayerButton.hidden = YES;
    }
  
    
    cell.showSelectBtn = YES;
    
    __weak typeof(self) weakSelf = self;
    cell.didSelectPhotoModelBlock = ^(TZAssetModel *choiceModel) {
        if (!choiceModel.isSelected) {
            if (weakSelf.choiceArr.count >= (self.limitNum?self.limitNum: 3)) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showToastWithText:self.limitNum?[NSString stringWithFormat:@"一次最多只能选择%ld张图哦~",self.limitNum]: @"一次最多选择三张图片哦~"];
                return;
            }
        }
   
        choiceModel.isSelected = !choiceModel.isSelected;
        if (choiceModel.isSelected) {
            [weakSelf.choiceArr addObject:choiceModel];
            
        }else{
            for (TZAssetModel *model_item in weakSelf.choiceArr) {
                if ([choiceModel.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [weakSelf.choiceArr removeObject:model_item];
                    break;
                }
            }
        }
        if (weakSelf.choiceArr.count) {
            weakSelf.sendButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        }else{
            self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        }
        [weakSelf.collectionView reloadData];
    };
    return cell;
}

- (void)refreshImage{
    [_assetArr removeAllObjects];
    [_choiceArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [TZImagePickerConfig sharedInstance].allowPickingImage = YES;
        [TZImagePickerConfig sharedInstance].allowPickingVideo = NO;
        __weak typeof(self) weakSelf = self;
        if ([[TZImageManager manager] authorizationStatusAuthorized]){
 
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TZImageManager manager] getAllAlbums:NO allowPickingImage:YES needFetchAssets:YES completion:^(NSArray<TZAlbumModel *> *models) {
                    weakSelf.abumArrary = [NSMutableArray arrayWithArray:models];
                    self.albumView.albumArr = self.abumArrary;
                    weakSelf.model = self.abumArrary[0];
                    weakSelf.models = [NSMutableArray arrayWithArray:weakSelf.model.models];
                    [weakSelf.titleButton setTitle:[NSString stringWithFormat:@"%@ ",weakSelf.model.name] forState:UIControlStateNormal];
                    [self->_collectionView reloadData];
                }];
            });
        }
    });
}

- (NSMutableArray *)choiceArr{
    if (!_choiceArr) {
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
}

- (NSMutableArray *)assetArr{
    if (!_assetArr) {
        _assetArr = [[NSMutableArray alloc] init];
    }
    return _assetArr;
}

@end
