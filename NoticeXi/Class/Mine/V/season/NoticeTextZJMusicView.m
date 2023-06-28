//
//  NoticeTextZJMusicView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJMusicView.h"
#import "NoticeTextMusicZjCell.h"

@implementation NoticeTextZJMusicView

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,40, DR_SCREEN_WIDTH,self.frame.size.height-40);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        // 注册cell
        [_collectionView registerClass:[NoticeTextMusicZjCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        self.musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
        [self.musicBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_musicback_b":@"Image_musicback_y") forState:UIControlStateNormal];
        [self addSubview:self.musicBtn];
        
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.musicBtn.frame), 0, DR_SCREEN_WIDTH-30-44, 40)];
        label.font = XGFourthBoldFontSize;
        label.textColor = GetColorWithName(VMainTextColor);
        label.text = @"音乐";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = GetColorWithName(VBackColor);
        
        NSArray *nameArr = @[[NoticeTools getLocalStrWith:@"system.sx"],@"昔往",@"今夕",@"思吾",@"蒹葭",@"心之",@"涟漪",@"仰止",@"其鸣",@"彼空",@"江汜",@"盼兮",@"桃之",@"谓何",@"关雎",@"言思",@"月恒",@"与子"];
        NSArray *imgNameArr = @[@"shengximusic",@"xiwangzj",@"jinxizj",@"siwuzj",@"jinajiazj",@"xinzhizj",@"lianyizj",@"yangzhizj",@"qimingzj",@"bikongzj",@"jiangsizj",@"panxizj",@"taozhizj",@"weihezj",@"guanjizj",@"yansizj",@"yuehengzj",@"yuzizj"];
        self.dataArr = [NSMutableArray new];
        for (int i = 0; i < nameArr.count; i++) {
            NoticeTextZJMusicModel *model = [[NoticeTextZJMusicModel alloc] init];
            model.name = nameArr[i];
            model.imgName = imgNameArr[i];
            model.isSelect = NO;
            [self.dataArr addObject:model];
        }
        [self.collectionView reloadData];
    }
    return self;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeTextMusicZjCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.musicM = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(55,88);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15,(DR_SCREEN_WIDTH-55*4)/5,10,(DR_SCREEN_WIDTH-55*4)/5);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (DR_SCREEN_WIDTH-55*4)/5;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeTextZJMusicModel *currentM = self.dataArr[indexPath.row];
    if (currentM.isSelect) {//如果点击的是已选择的，则停止播放
        for (NoticeTextZJMusicModel *model in self.dataArr) {
            model.isSelect = NO;
        }
        [self.collectionView reloadData];
        if (self.stopMusicTapBlock) {
            self.stopMusicTapBlock(YES);
        }
        return;
    }
    for (NoticeTextZJMusicModel *model in self.dataArr) {
        model.isSelect = NO;
    }
    NoticeTextZJMusicModel *choiceM = self.dataArr[indexPath.row];
    choiceM.isSelect = YES;
    [self.collectionView reloadData];
    if (self.musicTapBlock) {
        self.musicTapBlock(indexPath.row);
    }
}



@end
