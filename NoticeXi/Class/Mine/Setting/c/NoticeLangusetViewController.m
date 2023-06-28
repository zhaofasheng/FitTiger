//
//  NoticeLangusetViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLangusetViewController.h"

@interface NoticeLangusetViewController ()
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NSArray *bollArr;
@end

@implementation NoticeLangusetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"set.lan");
    self.titArr = @[Localized(@"lan.simple"),Localized(@"lan.hardTw"),Localized(@"lan.hardHk")];
    self.bollArr = @[@"0",@"1",@"1"];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.bollArr = @[@"0",@"1",@"1"];
        [NoticeTools changeToSimple];
    }else if(indexPath.row == 1){
        self.bollArr = @[@"1",@"0",@"1"];
        [NoticeTools changeToTaiwan];
    }else{
        self.bollArr = @[@"1",@"1",@"0"];
        [NoticeTools changeToTaiwan];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGELANGUENOTICATION" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    cell.subImageV.image = [UIImage imageNamed:@"setGou"];
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-10-15,(65 - 15*33/43)/2, 15, 15*33/43);
    cell.subImageV.hidden = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titArr.count;
}

@end
