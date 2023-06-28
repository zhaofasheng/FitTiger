//
//  NoticeTeamMemberView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamMemberView.h"
#import "UIView+CLSetRect.h"
#import "NoticeHMemberTeamCell.h"
@implementation NoticeTeamMemberView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        [self setAllCorner:12];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 100, 22)];
        label.font = XGSIXBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:label];
        label.text = @"社团成员";
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-15-20-60, 18, 60, 18)];
        self.numL.font = THRETEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.numL];
        self.numL.textAlignment = NSTextAlignmentRight;
        self.numL.userInteractionEnabled = YES;
        
        self.numView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numL.frame), 17, 20, 20)];
        self.numView.image = UIImageNamed(@"cellnextbutton");
        [self addSubview:self.numView];
        self.numView.userInteractionEnabled = YES;
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(16,54,self.frame.size.width-32, 61);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeHMemberTeamCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 60;
        [self addSubview:self.movieTableView];
        
        self.showArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHMemberTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.person = self.showArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArr.count;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    for (YYPersonItem *persons in dataArr) {
        if(self.showArr.count < 5){
            for (YYPersonItem *person in persons.personArr) {
                [self.showArr addObject:person];
            }
        }
    }
    [self.movieTableView reloadData];
}

@end
