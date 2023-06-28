//
//  NoticeBoKeListView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeListView.h"

@implementation NoticeBoKeListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
   
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-134+20)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalType]==1?@"Playlist": ([NoticeTools getLocalType]==2?@"リスト": @"播放列表");
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_contentView addSubview:label];
        self.titleL = label;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-50-BOTTOM_HEIGHT-20,DR_SCREEN_WIDTH, 50)];
        [button setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, DR_SCREEN_WIDTH, _contentView.frame.size.height-20-50-50-BOTTOM_HEIGHT-10)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[NoticeBoKeListCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        
        [self createRefesh];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoKeBeDelete:) name:@"DeleteBoKeNotification" object:nil];
    }
    return self;
}


- (void)getBoKeBeDelete:(NSNotification*)notification{
    if (self.dataArr.count) {
        for (NoticeDanMuModel *bokeM in self.dataArr) {
            NSDictionary *nameDictionary = [notification userInfo];
            NSString *num = nameDictionary[@"danmuNumber"];
            if ([bokeM.podcast_no isEqualToString:num]) {
                [self.dataArr removeObject:bokeM];
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.choiceBoKeBlock) {
        self.choiceBoKeBlock(self.dataArr[indexPath.row]);
    }
    [self dissMissTap];
}

- (void)setChoiceModel:(NoticeDanMuModel *)choiceModel{
    _choiceModel = choiceModel;
    if (!self.dataArr.count) {
        [self requestCurrent];
    }else{
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBoKeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    if ([cell.model.podcast_no isEqualToString:self.choiceModel.podcast_no]) {
        cell.isChoice = YES;
    }else{
        cell.isChoice = NO;
    }
    return cell;
}

- (void)requestCurrent{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@/%@",self.choiceModel.podcast_no,self.choiceModel.user_id] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.allModel = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            self.pageNo = self.allModel.pageNo.integerValue;
            self.upPageNo = self.allModel.pageNo.integerValue;
            if (self.pageNo == 1) {
                self.hasLoadFirstNum = YES;
            }
            NSString *begStr = [NoticeTools getLocalType]==1?@"Playlist": ([NoticeTools getLocalType]==2?@"リスト": @"播放列表");
            self.titleL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@(%@)",begStr,self.allModel.allNum] setSize:14 setLengthString:[NSString stringWithFormat:@"(%@)",self.allModel.allNum] beginSize:begStr.length];
            for (NSDictionary *dic in self.allModel.list) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                if ([model.podcast_no isEqualToString:self.choiceModel.podcast_no]) {
                    model.isChoice = YES;
                }
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestList{
    if (!self.dataArr.count) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    if (self.isDown) {
        if (self.pageNo == 1 && self.hasLoadFirstNum) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        if (self.pageNo < 1) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@?pageNo=%ld",self.choiceModel.user_id,self.isDown?self.pageNo:self.upPageNo] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                if (self.pageNo == 1) {
                    self.hasLoadFirstNum = YES;
                }
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                    [arr insertObject:model atIndex:0];
                }
                for (NoticeDanMuModel *model in arr) {
                    [self.dataArr insertObject:model atIndex:0];
                }
            }else{
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak NoticeBoKeListView *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo--;
        [ctl requestList];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.upPageNo++;
        [ctl requestList];
    }];
}


- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{

    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
