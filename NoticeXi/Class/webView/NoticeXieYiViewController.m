//
//  NoticeXieYiViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/3/18.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeXieYiViewController.h"
#import <WebKit/WebKit.h>
#import "NoticeWeb.h"
@interface NoticeXieYiViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) NoticeWeb *web;
@end

@implementation NoticeXieYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView removeFromSuperview];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH-20, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT)];
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    [self request];
}


- (void)request{
    
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"protocols/user" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            self.web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"]];
            self.navBarView.titleL.text = self.web.html_title;
            //修改背景颜色
            if ([NoticeTools isWhiteTheme]) {
                [self.webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
            }else{
                [self.webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#181828\"" completionHandler:nil];
            }
            [self.webView loadHTMLString:self.web.html_content baseURL:nil];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self showHUD];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //self.title = webView.title;
    [self hideHUD];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
 
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width-20, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    
    //修改背景颜色
    if ([NoticeTools isWhiteTheme]) {
        [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
    }else{
        [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#181828\"" completionHandler:nil];
    }
}

@end
