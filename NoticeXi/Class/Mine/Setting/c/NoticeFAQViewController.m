//
//  NoticeFAQViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFAQViewController.h"
#import "NoticeWebViewController.h"
#import "AFHTTPSessionManager.h"
@interface NoticeFAQViewController ()

@end

@implementation NoticeFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 56;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"aboutsx.title"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
        NoticeWeb *web = [[NoticeWeb alloc] init];
        web.html_id = @"28";
        webctl.web = web;
        [self.navigationController pushViewController:webctl animated:YES];
        return;
    }
    if (indexPath.row == 1) {
        NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
        webctl.type = @"1";
        webctl.isAboutSX = YES;
        [self.navigationController pushViewController:webctl animated:YES];
        return;
    }
    if (indexPath.row == 2) {
        NSString *url = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1358222995&pageNumber=0&sortOrdering=2&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.line.hidden = indexPath.row == 2?YES:NO;
    if (indexPath.row == 0) {
        cell.mainL.text = [NoticeTools getLocalStrWith:@"aboutsx.fax"];
    }
    else if(indexPath.row == 1){
        cell.mainL.text = [NoticeTools getLocalType]?@"Privacy":@"隐私政策";
    }else{
        cell.mainL.text = [NoticeTools getLocalStrWith:@"aboutsx.go"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

@end
