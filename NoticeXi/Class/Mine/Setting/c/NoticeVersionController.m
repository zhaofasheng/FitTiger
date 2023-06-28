//
//  NoticeVersionController.m
//  NoticeXi
//
//  Created by li lei on 2021/7/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVersionController.h"
#import "AFHTTPSessionManager.h"
@interface NoticeVersionController ()
@property (nonatomic, strong) UIView *headerView;
@end

@implementation NoticeVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"version.title"];
 
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-56-74-20)];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.scrollEnabled = NO;
    
    UIImageView *titleImageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-78)/2, 35, 78, 78)];
    titleImageV.image = UIImageNamed(@"Image_bbgx");
    [self.headerView addSubview:titleImageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImageV.frame)+10, DR_SCREEN_WIDTH, 16)];
    label.text = self.versionName;
    label.font = SIXTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:label];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+30, DR_SCREEN_WIDTH-50,DR_SCREEN_HEIGHT-74-20-56-35-78-10-16-20-30-NAVIGATION_BAR_HEIGHT)];
    contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    contentView.layer.cornerRadius = 10;
    contentView.layer.masksToBounds = YES;
    [self.headerView addSubview:contentView];
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, contentView.frame.size.width-40, 0)];
    contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
    contentL.font = TWOTEXTFONTSIZE;
    [contentView addSubview:contentL];
    
    NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"results"];
        if (results && results.count > 0) {
            NSDictionary *response = results.firstObject;
            NSString *newMessage = response[@"releaseNotes"];
            NSString *lastestVersion = response[@"version"];// AppStore 上软件的最新版本
            label.text = [NSString stringWithFormat:@"V%@",lastestVersion];
            
            contentL.attributedText = [NoticeTools getStringWithLineHight:14 string:newMessage];
            contentL.numberOfLines = 0;
            contentL.frame = CGRectMake(20, 20, contentView.frame.size.width-40, [NoticeTools getSpaceLabelHeight:newMessage withFont:TWOTEXTFONTSIZE withWidth:contentL.frame.size.width]);
            contentView.contentSize = CGSizeMake(contentView.frame.size.width, contentL.frame.size.height);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-243)/2,DR_SCREEN_HEIGHT-74-56, 243, 56)];
    if (self.hasNewVersion) {
        [btn setBackgroundImage:UIImageNamed(@"Image_reinstall") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reInstall) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn setTitle:[NoticeTools getLocalStrWith:@"version.mark"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        btn.titleLabel.font = XGEightBoldFontSize;
        btn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        btn.layer.cornerRadius = 28;
        btn.layer.masksToBounds = YES;
    }
    [self.view addSubview:btn];
}

- (void)reInstall{
    NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *results = responseObject[@"results"];
        if (results && results.count > 0) {
            NSDictionary *response = results.firstObject;
            NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
            if (trackViewUrl) {
                NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                    [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

@end
