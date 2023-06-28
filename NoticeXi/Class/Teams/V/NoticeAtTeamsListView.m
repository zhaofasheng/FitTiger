//
//  NoticeAtTeamsListView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAtTeamsListView.h"
#import "NoticeAtPersonCell.h"
#import "UIView+CLSetRect.h"
#import "NoticeHeaderView.h"
@implementation NoticeAtTeamsListView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"popdown_btn") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
        
        self.choiceMoreL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-GET_STRWIDTH(@"多选", 14, 50), 0, 40+GET_STRWIDTH(@"多选", 14, 50), 50)];
        self.choiceMoreL.text = @"多选";
        self.choiceMoreL.font = FOURTHTEENTEXTFONTSIZE;
        self.choiceMoreL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.choiceMoreL.textAlignment = NSTextAlignmentCenter;
        self.choiceMoreL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canChoiceMoreTap)];
        [self.choiceMoreL addGestureRecognizer:tap];
        [self.contentView addSubview:self.choiceMoreL];
        
        self.contentL = [[NoticeTextView alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-BOTTOM_HEIGHT-10-60, DR_SCREEN_WIDTH-40,60)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentL.layer.cornerRadius = 8;
        self.contentL.layer.masksToBounds = YES;
        self.contentL.editable = NO;
        [self.contentView addSubview:self.contentL];
        self.contentL.hidden = YES;
        self.contentL.isContent = YES;
        //self.contentL.textContainerInset = UIEdgeInsetsMake(10, -5, 0, -5);
        
        self.tableView.tableHeaderView = [[NoticeTools getuserId] isEqualToString:@"1"]?self.atAllView:nil;
    }
    return self;
}

- (void)canChoiceMoreTap{
    if(self.canChoiceMore){
        if(self.atBlock){
            self.atBlock(self.atArr);
        }
        [self cancelClick];
        return;
    }
    self.canChoiceMore = !self.canChoiceMore;
    [self.tableView reloadData];
}

- (UIView *)atAllView{
    if(!_atAllView){
        _atAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
        [label setAllCorner:15];
        label.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        label.font = EIGHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"@";
        [_atAllView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(62, 0,200, 40)];
        label1.font = FIFTHTEENTEXTFONTSIZE;
        label1.text = @"全部社员";
        label1.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_atAllView addSubview:label1];
        
        _atAllView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(atAllTap)];
        [_atAllView addGestureRecognizer:tap];
    }
    return _atAllView;
}

- (void)atAllTap{
    YYPersonItem *atAll = [[YYPersonItem alloc] init];
    atAll.name = @"全部社员";
    atAll.userId = @"all";
    [self.atArr removeAllObjects];
    [self.atArr addObject:atAll];
    if(self.atBlock){
        self.atBlock(self.atArr);
    }
    [self cancelClick];
}

- (void)remvokUserId:(NSString *)userId{
    BOOL hasFind = NO;
    for (YYPersonItem *item in self.dataArr) {
        if(hasFind){
            break;
        }
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                [item.personArr removeObject:person];
                hasFind = YES;
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.safeLock){
        return;
    }
    YYPersonItem *sectonPerson = self.dataArr[indexPath.section];
    YYPersonItem *person = sectonPerson.personArr[indexPath.row];
    if ([person.userId isEqualToString:[NoticeTools getuserId]]) {//不准艾特自己
        return;
    }
    person.isAt = !person.isAt;
    if(person.isAt){
        [self.atArr addObject:person];
    }else{
        [self.atArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            YYPersonItem *item = obj;
            if([item.userId isEqualToString:person.userId]){
                *stop = YES;
                [self.atArr removeObject:item];
            }
        }];
    }
    if(!self.canChoiceMore){
        if(self.atBlock){
            self.atBlock(self.atArr);
        }
        [self cancelClick];
    }else{
        [self.tableView reloadData];
        NSString *str = @"";
        self.safeLock = YES;
        for (YYPersonItem *person in self.atArr) {
            str = [str stringByAppendingFormat:@"@%@ ",person.name];
        }
        self.contentL.text = str;
        self.safeLock = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeHeaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.backgroundColor = [UIColor whiteColor];
    headV.contentView.backgroundColor = [UIColor whiteColor];
    headV.mainTitleLabel.frame = CGRectMake(20, 0, 120,30);
    headV.mainTitleLabel.font = FOURTHTEENTEXTFONTSIZE;
    headV.mainTitleLabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    YYPersonItem *personItem = self.dataArr[section];
    headV.mainTitleLabel.text = personItem.title;
    return headV;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAtPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.canChoiceMore = self.canChoiceMore;
    YYPersonItem *personItem = self.dataArr[indexPath.section];
    cell.person = personItem.personArr[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYPersonItem *sectionItem = self.dataArr[section];
    return sectionItem.personArr.count;
}

- (void)setCanChoiceMore:(BOOL)canChoiceMore{
    _canChoiceMore = canChoiceMore;
    self.choiceMoreL.text = _canChoiceMore?@"完成":@"多选";
    self.contentL.hidden = canChoiceMore?NO:YES;
    if(canChoiceMore){
        self.tableView.frame = CGRectMake(0, 50, DR_SCREEN_WIDTH, self.contentView.frame.size.height-60-BOTTOM_HEIGHT-10-50);
    }else{
        self.tableView.frame = CGRectMake(0, 50, DR_SCREEN_WIDTH, self.contentView.frame.size.height-50);
    }
}

- (void)showATView{
    self.canChoiceMore = NO;
    [self.atArr removeAllObjects];
    [self.tableView reloadData];
    self.tableView.sc_indexViewDataSource = self.syArr;
    self.tableView.sc_startSection = 0;
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{
    self.canChoiceMore = NO;
    [self.atArr removeAllObjects];
    for (YYPersonItem *titlePerson in self.dataArr) {
        for (YYPersonItem *person in titlePerson.personArr) {
            person.isAt = NO;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Getter and Setter

- (NSMutableArray *)atArr{
    if(!_atArr){
        _atArr = [[NSMutableArray alloc] init];
    }
    return _atArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.contentView.frame.size.height-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:NoticeAtPersonCell.class forCellReuseIdentifier:@"cell"];
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
        configuration.indicatorHeight = 30;
        configuration.indicatorTextColor = [UIColor colorWithHexString:@"#0099E6"];
        configuration.indexItemTextColor =  [UIColor colorWithHexString:@"#A1A7B3"];
        configuration.indexItemSelectedBackgroundColor = [UIColor whiteColor];
        configuration.indexItemsSpace = 3;
        configuration.indexItemSelectedTextFont = THRETEENTEXTFONTSIZE;
        configuration.indexItemTextFont = ELEVENTEXTFONTSIZE;
        configuration.indicatorTextFont = XGSIXBoldFontSize;
        configuration.indexItemSelectedTextColor = [UIColor colorWithHexString:@"#0099E6"];
        _tableView.sc_indexViewConfiguration = configuration;
        
        [self.contentView addSubview:self.tableView];
        
    }
    return _tableView;
}



@end
