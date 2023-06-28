//
//  NoticeLookImageViewView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeLookImageViewView.h"

@implementation NoticeLookImageViewView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 创建collectionView
        CGRect frame = CGRectMake(0,self.frame.size.height-48,self.frame.size.width,48);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFAF7"];
        // 注册cell
        [_collectionView registerClass:[NoticeLookPhotoRecCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFAF7"];
        [self addSubview:self.collectionView];
                
        self.imageShowView = [[NoticeCustomView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-10-self.collectionView.frame.size.height)];
        [self addSubview:self.imageShowView];
        self.imageShowView.hidden = YES;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-30)/2, 52, 30)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#F7F8FC"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        cancelBtn.layer.cornerRadius = 3;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    NoticeVoiceTypeModel *model = self.photoArr[indexPath.row];
    if (model.isChoice) {
        return;
    }else{
        if (self.currentModel) {
            self.currentModel.isChoice = NO;
        }
        model.isChoice = YES;
        self.currentModel = model;
        self.imageShowView.image = model.currentImg;
        [self.collectionView reloadData];
    }
    [CoreAnimationEffect animationEaseIn:self.imageShowView];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeLookPhotoRecCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.currentChoiceM = self.photoArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(58,48);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,10,0,10);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [[NSMutableArray alloc] init];
    }
    return _photoArr;
}

- (void)cancelClick{
    [CoreAnimationEffect animationEaseOut:self];
    if (self.cancelBlock) {
        self.cancelBlock(YES);
    }
}
@end
