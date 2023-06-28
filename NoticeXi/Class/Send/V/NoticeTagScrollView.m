//
//  NoticeTagScrollView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTagScrollView.h"
#import "NoticeNewTopicCell.h"
@implementation NoticeTagScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.tableView.frame = CGRectMake(0,0,frame.size.width, frame.size.height);
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeNewTopicCell class] forCellReuseIdentifier:@"cell"];

        [self addSubview:self.tableView];
    
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.topicM = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTopicModel *model = self.dataArr[indexPath.row];
    return GET_STRWIDTH(model.name, 11, 24)+30+6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTopicModel *model = self.dataArr[indexPath.row];
    if (self.topicBlock) {
        self.topicBlock(model.topic_name, model.topic_id);
    }
}

@end
