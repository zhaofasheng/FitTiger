//
//  NoticeEmotionView.m
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeEmotionView.h"
#import "NoticeEmotionController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"


@implementation NoticeEmotionView

- (instancetype)initWithCu{
    if (self = [super init]) {
        
        self.isCu = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.collectionView.backgroundColor = self.backgroundColor;
        [self addSubview:self.collectionView];
        
        self.dataArr = [[NSMutableArray alloc] init];

        self.isDown = YES;
        [self requestEmotion];
    }
    return self;
}

- (instancetype)initWithHot{
    if (self = [super init]) {
        
        self.isHot = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.collectionView.backgroundColor = self.backgroundColor;
        [self addSubview:self.collectionView];
        
        self.dataArr = [[NSMutableArray alloc] init];

        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.isDown = YES;
            [weakSelf requestEmotion];
        }];
        
        self.collectionView.mj_header = header;
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.isDown = NO;
            [weakSelf requestEmotion];
        }];
        
        self.isDown = YES;
        [self requestEmotion];
    }
    return self;
}

- (instancetype)initWithNoHot{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.collectionView.backgroundColor = self.backgroundColor;
        [self addSubview:self.collectionView];
        
        self.dataArr = [[NSMutableArray alloc] init];
        
        NoticeEmotionModel *localM = [NoticeEmotionModel new];
        localM.isLocal = YES;
        [self.dataArr addObject:localM];
        
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.isDown = YES;
            [weakSelf requestEmotion];
        }];
        self.collectionView.mj_header = header;
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.isDown = NO;
            [weakSelf requestEmotion];
            
        }];
        
        self.isDown = YES;
        [self requestEmotion];
    }
    return self;
}

- (void)setIsHot:(BOOL)isHot{
    _isHot = isHot;
    if (isHot && self.dataArr.count) {
        NoticeEmotionModel *localM = self.dataArr[0];
        if (localM.isLocal) {
            [self.dataArr removeObject:localM];
            [self.collectionView reloadData];
        }
    }
}

- (void)setIsBeginChoice:(BOOL)isBeginChoice{
    _isBeginChoice = isBeginChoice;
    if (_isBeginChoice) {
        [self.dataArr removeObjectAtIndex:0];
    }else{
        if (self.dataArr.count) {
            if (![self.dataArr[0] isLocal]) {//不存在才加进去
                NoticeEmotionModel *localM = [NoticeEmotionModel new];
                localM.isLocal = YES;
                [self.dataArr insertObject:localM atIndex:0];
            }
        }
    }
    [self.collectionView reloadData];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeEmtionCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.isManager = self.isManager;
    merchentCell.isHot = self.isHot;
    merchentCell.isCu = self.isCu;
    __weak typeof(self) weakSelf = self;
    merchentCell.refashBlock = ^(BOOL reafsh) {
        [weakSelf.collectionView.mj_header beginRefreshing];
    };
    merchentCell.collectBlock = ^(BOOL collect) {
        if (weakSelf.collectBlock) {
            weakSelf.collectBlock(YES);
        }
    };
    merchentCell.row = indexPath.row;
    
    if ((indexPath.row <= self.dataArr.count-1) && self.dataArr.count) {
        merchentCell.isManager = self.isManager;
        if (self.isManager) {
            merchentCell.isBeginChoice = self.isBeginChoice;
        }
        merchentCell.emotionModel = self.dataArr[indexPath.row];
    }
    
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-80)/5,(DR_SCREEN_WIDTH-80)/5);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3,20,3,20);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isHot || self.isCu) {
        NoticeEmotionModel *model = self.dataArr[indexPath.row];
         if (self.sendBlock) {
             self.sendBlock(model.picture_uri,model.bucket_id,model.pictureId,YES);
         }
        return;
    }
    
    if (!self.isManager && indexPath.row == 0) {//跳转到表情管理
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        NoticeEmotionController *ctl = [[NoticeEmotionController alloc] init];
        __weak typeof(self) weakSelf = self;
        ctl.refashBlock = ^(BOOL reafsh) {
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        if (self.addMoreBlock) {
            self.addMoreBlock(YES);
        }
        ctl.isManager = YES;
        if (self.dataArr.count > 1) {
            ctl.dataArr = self.dataArr;
        }
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }else if (!self.isManager && indexPath.row != 0){//发送图片
        if (self.dataArr.count-1 >= indexPath.row ) {
            NoticeEmotionModel *model = self.dataArr[indexPath.row];
            if (self.sendBlock) {
                self.sendBlock(model.picture_uri,model.bucket_id,model.pictureId,NO);
            }
        }

    }else if (self.isManager && !self.isBeginChoice && indexPath.row!= 0) {
        NoticeEmotionModel *model = self.dataArr[indexPath.row];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        NoticeEmtionCell *cell = (NoticeEmtionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        item.thumbView         = cell.sendImageView;
        item.largeImageURL = [NSURL URLWithString:model.picture_url];
        YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
        UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [view presentFromImageView:cell.sendImageView
                       toContainer:toView
                          animated:YES completion:nil];
    }
    else if (self.isManager && self.isBeginChoice){
        if (self.choiceArr.count >= 9) {
            return;
        }
        NoticeEmotionModel *model = self.dataArr[indexPath.row];
        model.isChoice = !model.isChoice;
        [self.collectionView reloadData];
        
        [self.choiceArr removeAllObjects];
        
        for (NoticeEmotionModel *choiceM in self.dataArr) {
            if (choiceM.isChoice) {
                [self.choiceArr addObject:choiceM];
            }
        }
        if (self.choiceBlock) {
            self.choiceBlock(self.choiceArr.count);
        }
    }
    else if (self.isManager && !self.isBeginChoice && indexPath.row == 0){
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
        imagePicker.sortAscendingByModificationDate = NO;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = YES;
        imagePicker.allowPickingMultipleVideo = YES;
        imagePicker.showPhotoCannotSelectLayer = YES;
        imagePicker.allowCrop = NO;
        imagePicker.showSelectBtn = YES;
        [nav.topViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    self.photoArr = [NSMutableArray arrayWithArray:assets];
    self.imgArr = [NSMutableArray arrayWithArray:photos];
    [self sendImagePhoto];
}

- (void)sendImagePhoto{
    if (!self.photoArr.count) {
        return;
    }
    PHAsset *asset = self.photoArr[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999999996];
            [self upLoadHeader:imageData path:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]]];
        }];
    }else{
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!self.imgArr.count) {
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation(self.imgArr[0], 0.7) path:pathMd5];
        }];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"30" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    
    [nav.topViewController showHUD];
    
    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *postParm = [NSMutableDictionary new];
            if (bucketId) {
                [postParm setObject:bucketId forKey:@"bucketId"];
            }
            [postParm setObject:errorMessage forKey:@"pictureUri"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/picture",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.7+json" isPost:YES parmaer:postParm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    
                    self.isDown = YES;
                    [self requestEmotion];
                    if (self.refashBlock) {
                        self.refashBlock(YES);
                    }
                    if (self.photoArr.count) {
                        [self.photoArr removeObjectAtIndex:0];
                        if (self.imgArr.count) {
                            [self.imgArr removeObjectAtIndex:0];
                        }
                        if (self.photoArr.count) {
                            [self sendImagePhoto];
                        }
                    }
                }else{
                    [nav.topViewController hideHUD];
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            [nav.topViewController showToastWithText:errorMessage];
        }
    }];
}

- (void)requestEmotion{
    NSString *url = nil;

    if (self.isCu) {//官方表情包
        url = @"getCatePicture/1";
    }else{
        if (self.isDown) {
            url = [NSString stringWithFormat:@"user/%@/pictureList",[NoticeTools getuserId]];
            if (self.isHot) {
                url = [NSString stringWithFormat:@"user/%@/pictureRank",[NoticeTools getuserId]];
            }
        }else{
            url = [NSString stringWithFormat:@"user/%@/pictureList?lastId=%@",[NoticeTools getuserId],self.lastId];
            if (self.isHot) {
                url = [NSString stringWithFormat:@"user/%@/pictureRank?lastId=%@",[NoticeTools getuserId],self.lastId];
            }
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isCu?@"application/vnd.shengxi.v5.3.2+json": @"application/vnd.shengxi.v4.7.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
                
                if (!self.isHot && !self.isCu) {//热门表情不需要添加按钮
                    NoticeEmotionModel *localM = [NoticeEmotionModel new];
                    localM.isLocal = YES;
                    [self.dataArr addObject:localM];
                }

                if (self.isManager && self.isBeginChoice) {
                    [self.choiceArr removeAllObjects];
                    if (self.choiceBlock) {
                        self.choiceBlock(self.choiceArr.count);
                    }
                }
                if (self.isBeginChoice && self.noChoiceBlock) {
                    self.isBeginChoice = NO;
                    self.noChoiceBlock(YES);
                }
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeEmotionModel *model = [NoticeEmotionModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeEmotionModel *lastM = self.dataArr[self.dataArr.count-1];
                if (!lastM.isLocal) {
                   self.lastId = lastM.picture_sort;
                }
            }
            [self.collectionView reloadData];
            if (self.dataArr.count <30 && !self.isCu) {//小于三十，自动加载
                [self getMoreEmotion];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)getMoreEmotion{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/pictureList",[NoticeTools getuserId]];
        if (self.isHot) {
            url = [NSString stringWithFormat:@"user/%@/pictureRank",[NoticeTools getuserId]];
        }
    }else{
        url = [NSString stringWithFormat:@"user/%@/pictureList?lastId=%@",[NoticeTools getuserId],self.lastId];
        if (self.isHot) {
            url = [NSString stringWithFormat:@"user/%@/pictureRank?lastId=%@",[NoticeTools getuserId],self.lastId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.7.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {

            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeEmotionModel *model = [NoticeEmotionModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                hasData = YES;
            }
            if (self.dataArr.count > 1) {
                NoticeEmotionModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.picture_sort;
            }
            [self.collectionView reloadData];
            if (hasData && self.dataArr.count < 30) {//小于三十并且有数据，自动加载
                [self getMoreEmotion];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)clearChoice{
    [self.choiceArr removeAllObjects];
}

- (void)deleteClick{
    if (self.choiceArr.count) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"group.deleemmark"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger indexs) {
            if (indexs == 1) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                [nav.topViewController showHUD];
                NSMutableArray *arr = [NSMutableArray new];
                for (NoticeEmotionModel *model in weakSelf.choiceArr) {
                    [arr addObject:model.pictureId];
                }
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"pictureId"];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"user/%@/pictureDel",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.7+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        weakSelf.isDown = YES;
                        [weakSelf requestEmotion];
                        if (weakSelf.refashBlock) {
                            weakSelf.refashBlock(YES);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
        
    }
}

- (void)moveClick{
    if (self.choiceArr.count) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showHUD];
        NSMutableArray *arr = [NSMutableArray new];
        for (NoticeEmotionModel *model in self.choiceArr) {
            [arr addObject:model.pictureId];
        }
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"pictureId"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"%@/picture",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.7+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                  self.isDown = YES;
                  [self requestEmotion];
                  if (self.refashBlock) {
                      self.refashBlock(YES);
                  }
              }
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"group.moveemosus"]];
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    }
}

- (NSMutableArray *)choiceArr{
    if (!_choiceArr) {
        _choiceArr = [NSMutableArray new];
    }
    return _choiceArr;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,0, DR_SCREEN_WIDTH,self.frame.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册cell
        [_collectionView registerClass:[NoticeEmtionCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}
@end
