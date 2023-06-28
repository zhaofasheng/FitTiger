//
//  NoticeAlbumView.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAlbumView.h"

@implementation NoticeAlbumView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-70*5-10, DR_SCREEN_WIDTH, 70*5+10) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 60;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[AlbumPhotoCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.tableView];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, 10)];
        header.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.tableView.tableFooterView = header;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceWith:)]) {
        [self.delegate choiceWith:_albumArr[indexPath.row]];
    }
}

- (void)setAlbumArr:(NSMutableArray *)albumArr{
    _albumArr = albumArr;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.albumM = _albumArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumArr.count;
}

- (void)show:(FSCustomButton *)btn{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    //btn.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, 70*5+10);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
       // btn.enabled = YES;
    }];
}

- (void)show:(FSCustomButton *)btn to:(UIView *)view{
    [view addSubview:self];
    //btn.enabled = NO;

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, 70*5+10);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
    } completion:^(BOOL finished) {
       // btn.enabled = YES;
    }];

}

- (void)dissMiss:(FSCustomButton *)btn{
   // btn.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0,-70*5-10, DR_SCREEN_WIDTH, 70*5+10);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
      //  btn.enabled = YES;
    }];
}
@end
