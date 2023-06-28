//
//  NoticeVoiceReadFooterView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadFooterView.h"

@implementation NoticeVoiceReadFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.font = XGEightBoldFontSize;
        label.text = [NoticeTools getLocalStrWith:@"luy.heji"];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [moreBtn addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-100, 0, 100, 40)];
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.text = [NoticeTools getLocalStrWith:@"luy.gmore"];
        label1.textColor = [UIColor colorWithHexString:@"#25262E"];
        label1.textAlignment = NSTextAlignmentRight;
        [moreBtn addSubview:label1];
        
        self.dataArr = [NSMutableArray new];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(0,40,DR_SCREEN_WIDTH, 175);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = self.backgroundColor;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeVoiceReadMoreCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 120;
        [self addSubview:self.movieTableView];
        
        [self request];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceReadModel *model = self.dataArr[indexPath.row];
    if (self.moreDetailBlock) {
        self.moreDetailBlock(model);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceReadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.readModel = self.dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)moreClick{
    if (self.moreBlock) {
        self.moreBlock(YES);
    }
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"readAloud/getCollection" Accept:@"application/vnd.shengxi.v5.3.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceReadModel *readM = [NoticeVoiceReadModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:readM];
            }
            [self.movieTableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}
@end
