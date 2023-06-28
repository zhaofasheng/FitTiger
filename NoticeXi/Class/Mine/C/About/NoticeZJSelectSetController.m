//
//  NoticeZJSelectSetController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZJSelectSetController.h"

@interface NoticeZJSelectSetController ()
@property (nonatomic, strong) NSArray *titArr;
@end

@implementation NoticeZJSelectSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"谁可以看":@"誰可以看";
    self.titArr = [NoticeTools isSimpleLau]? @[[NoticeTools getLocalStrWith:@"zj.simizj"],[NoticeTools getLocalStrWith:@"mineme.xueyoukejian"],[NoticeTools getLocalStrWith:@"mineme.alllkan"]]:@[@"私密專輯",@"学友可見",@"所有人可見"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock([NSString stringWithFormat:@"%ld",(long)indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    cell.subImageV.image = [UIImage imageNamed:@"setGou"];
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-10-15,(65 - 15*33/43)/2, 15, 15*33/43);
    cell.subImageV.hidden = [self.selectName isEqualToString:self.titArr[indexPath.row]]?NO:YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    view.backgroundColor = GetColorWithName(VlistColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,DR_SCREEN_WIDTH-15, 40)];
    label.text = [NoticeTools isSimpleLau]?@"谁可以在你的「心情簿-专辑」看到这张心情专辑?":@"誰可以在妳的「心情簿-專輯」看到這張心情專輯?";
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

@end
