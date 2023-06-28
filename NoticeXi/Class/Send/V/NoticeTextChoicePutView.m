//
//  NoticeTextChoicePutView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextChoicePutView.h"
#import "NoticeChoiceTextThumeCell.h"
@implementation NoticeTextChoicePutView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.collectionView];
        
        NSArray *nameArr = @[@"捕捉灵感",
                             @"放松感",
                             @"专注感",
                             @"快乐感",
                             @"自信感",
                             @"战胜拖延",
                             @"方向感",
                             @"自我提升",
                             @"生产力",
                             @"珍惜时间",
                             @"痛苦悔恨",
                             @"战胜无聊",
                             @"选择困难",
                             @"消灭自闭",
                             @"被人讨厌",
                             @"哲学"];
        NSArray *colorArr = @[
                             @"#46BA07",
                             @"#46BA07",
                             @"#339BEA",
                             @"#46BA07",
                             @"#46BA07",
                             @"#339BEA",
                             @"#339BEA",
                             @"#339BEA",
                             @"#339BEA",
                             @"#46BA07",
                             @"#46BA07",
                             @"#46BA07",
                             @"#339BEA",
                             @"#46BA07",
                             @"#46BA07",
                             @"#339BEA"];
        NSArray *contentArr = @[@"一闪而过的灵感",
                                @"接下来1分钟\n做点什么会让我心情变好?",
                                @"怎么才可以让你更专注？",
                                @"你是不是把时间\n花在最让你快乐的事情上?",
                                @"你当前的什么想法\n限制了你的行动?",
                                @"你现在不立刻做这件事\n最坏的结果可能是?",
                                @"今天结束之前\n一定要做的1件事是什么?",
                                @"你怎么才能得到\n你现在所缺乏的？",
                                @"最能给你今天\n带来进展的那件事是什么?",
                                @"接下来要做的\n怎样花最少时间\n达到相同效果?",
                                @"经过这一次\n至少你知道未来\n不会走哪些弯路?",
                                @"接下来1分钟\n你可以去尝试什么新体验?",
                                @"这几个选项\n你没选哪件事会更后悔?",
                                @"10年之后，看此刻的自己\n会不会觉得很搞笑?",
                                @"讨厌你的人多了\n他算老几?",
                                @"你在做什么的时候\n会找到生命的意义?"];
        
        self.dataArr = [NSMutableArray new];
        for (int i = 0; i < contentArr.count; i++) {
            NoticeBackQustionModel *model = [NoticeBackQustionModel new];
            model.name = nameArr[i];
            model.color = colorArr[i];
            model.content = contentArr[i];
            [self.dataArr addObject:model];
        }
        [self.collectionView reloadData];
    }
    return self;
}
- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = GetColorWithName(VBackColor);
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        // 注册cell
        [_collectionView registerClass:[NoticeChoiceTextThumeCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBackQustionModel *model = self.dataArr[indexPath.row];
    if (self.textBlock) {
        self.textBlock(model.name,[model.content stringByReplacingOccurrencesOfString:@"\n" withString:@""]);
    }
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeChoiceTextThumeCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.model = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-35)/2,120);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
