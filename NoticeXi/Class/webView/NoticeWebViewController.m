//
//  NoticeWebViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeWebViewController.h"
#import <WebKit/WebKit.h>
#import "NoticeWeb.h"
#import "NoticeLyTableViewCell.h"
#import "NoticeLyViewController.h"
#import "NoticeTopiceVoicesListViewController.h"
#import "NoticeNavItemButton.h"
#import "NoticeSendBBSController.h"
@interface NoticeWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,NewSendTextDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) UILabel *textView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *stayView;
@end

@implementation NoticeWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.web && self.web.is_open.boolValue && self.web.html_id) {
        [self requestList];
    }
}

- (void)dealloc{
    //[self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//网页和tabbleView滑动协调处理
    [self.webView setNeedsLayout];
}

- (void)tostClick{
    if (self.isFromShare) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url] options:@{} completionHandler:^(BOOL success) {
         
        }];

        return;
    }
    NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewString:[NoticeTools getLocalType]?@"Long press to save the picture":@"长按可以保存文章的图片哦"];
    [pinTostView showTostView];
}

- (void)sendClick{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isFromListen) {

        [self.navBarView.rightButton setImage:UIImageNamed(@"webdownload_img") forState:UIControlStateNormal];
        [self.navBarView.rightButton addTarget:self action:@selector(tostClick) forControlEvents:UIControlEventTouchUpInside];
    }else if (self.isFromShare){

        [self.navBarView.rightButton setImage:UIImageNamed(@"img_scb_y") forState:UIControlStateNormal];
        [self.navBarView.rightButton addTarget:self action:@selector(tostClick) forControlEvents:UIControlEventTouchUpInside];
    }

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.hidden = YES;
    self.tableView.frame = CGRectMake(0,self.isMerechant?0: NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-(self.isMerechant?0: NAVIGATION_BAR_HEIGHT));
    [self.tableView registerClass:[NoticeLyTableViewCell class] forCellReuseIdentifier:@"cells"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"webCell"];
    if (self.web || (!self.url && self.type) || self.specic) {//如果存在web，则不要webView
     
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(15,0,DR_SCREEN_WIDTH-20, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT)];
        
        self.webView.navigationDelegate = self;
        if (![self.type isEqualToString:@"1"]) {
            self.webView.scrollView.bounces = NO;
            self.webView.scrollView.scrollEnabled = NO;
        }
        self.webView.scrollView.delegate = self;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        // 添加kvo监听webview的scrollView.contentSize变化
       // [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.dataArr = [NSMutableArray new];
        self.navBarView.titleL.text = self.web.html_title;
        if (self.web) {
            self.url = @"1";
           [self requestDetail];
        }else if (self.specic){
            [self requestSpec];
        }
        else{
            [self request];
        }
        self.tableView.hidden = NO;
                
        return;
    }
//
    if (self.url || self.allUrl) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        WKUserContentController* userContentController = WKUserContentController.new;
        // 通过JS与webview内容交互
        config.userContentController = userContentController;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT) configuration:config];
        if (self.isMerechant) {
            webView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
        }
        // 设置访问的URL
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        NSURL *url = self.allUrl?self.allUrl: [NSURL URLWithString:self.url];
        // 根据URL创建请求
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        // WKWebView加载请求
        [webView loadRequest:request];
        // 将WKWebView添加到视图
        [self.view addSubview:webView];
        return;
    }

    [self request];
}

- (void)request{
    
    if (!self.url) {
        
        [self showHUD];
        NSString *url = [self.type isEqualToString:@"1"] ? @"h5/type/1" : (self.urlName? self.urlName : [NSString stringWithFormat:@"h5/type?htmlType=%@",self.type]);
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isXieyi? nil : @"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                self.url = @"1";
                
                if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
                    self.web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"][0]];
                }else{
                    self.web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"]];
                }
                
                self.navBarView.titleL.text = self.web.html_title;
                if (!self.isXieyi && ![self.type isEqualToString:@"1"]) {
                     [self requestDetail];
                }else{
                    [self.tableView removeFromSuperview];
                    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                    self.web.html_content = [self.web.html_content stringByReplacingOccurrencesOfString:@"V1.0.0" withString:currentVersion];
                    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT)];
                    self.webView.scrollView.backgroundColor = self.view.backgroundColor;
                    self.webView.scrollView.delegate = self;
                    if (![self.type isEqualToString:@"1"]) {
                       self.webView.scrollView.scrollEnabled = NO;
                    }
                    self.webView.backgroundColor = self.view.backgroundColor;
                  //  [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
                    [self.view addSubview:self.webView];
        
                    [self.webView loadHTMLString:self.web.html_content baseURL:nil];
                    
                }
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (void)requestSpec{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"h5/html/declare/%@",self.specic] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"]];
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            self.web.html_content = [self.web.html_content stringByReplacingOccurrencesOfString:@"V1.0.0" withString:currentVersion];
            [self.webView loadHTMLString:self.web.html_content baseURL:nil];
            
            self.navBarView.titleL.text = self.web.html_title;

            [self.tableView reloadData];
            if (self.web.is_open.boolValue) {
                [self requestList];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}


- (void)requestDetail{
    if (!self.web) {
        return;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"h5/html/%@",self.web.html_id] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.web = [NoticeWeb mj_objectWithKeyValues:dict[@"data"]];
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            self.web.html_content = [self.web.html_content stringByReplacingOccurrencesOfString:@"V1.0.0" withString:currentVersion];
            if (!self.web.html_content) {
                return ;
            }
            [self.webView loadHTMLString:self.web.html_content baseURL:nil];
           
            self.navBarView.titleL.text = self.web.html_title;
            [self.tableView reloadData];
            if (self.web.is_open.boolValue) {
                [self requestList];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestList{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"htmls/%@/dialog",self.web.html_id] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [self.dataArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeLy *model = [NoticeLy mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.web.is_open.boolValue ? 66 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    if (!self.web.is_open.boolValue) {
        return [UIView new];
    }
    return self.stayView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.webView.frame.size.height;
    }
    NoticeLy *model = self.dataArr[indexPath.row];
    return model.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell"];
        [self.webView removeFromSuperview];
        [cell addSubview:self.webView];
        return cell;
    }
    NoticeLyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
    cell.liuyan = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.isFromShare) {
        return;
    }
    [self showHUD];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //self.title = webView.title;
    [self hideHUD];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (self.isFromShare) {
        return;
    }
    self.webView.hidden = YES;

    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width-20, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];

    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 950.0;" // WKWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.heigth = maxwidth;"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();" completionHandler:nil];
    //这个方法也可以计算出webView滚动视图滚动的高度
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        if ([result floatValue] > 0) {
            CGFloat ratio =  CGRectGetWidth(self.webView.frame) / [result floatValue];
            NSLog(@"scrollWidth高度：%.2f",[result floatValue]);

            [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){

                CGRect frame = self.webView.frame;
                frame.size.height = [result floatValue]*ratio;

                self.webView.frame = frame;
                [self.tableView reloadData];
            }];
        }
    }];
    
    /// 延时0.2s 显示网页
    [self performSelector:@selector(showWebView) withObject:self afterDelay:0.2];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    NSArray *arr = [strRequest componentsSeparatedByString:@"https://www.byebyetext.com/topic/"];
    if ([strRequest containsString:@"https://www.byebyetext.com/topic/"]) {
        if (arr.count>1) {
            NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
            ctl.topicName = arr[1];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
    }else if ([strRequest containsString:@"https://www.byebyetext.com/html_id/"]){
        NSArray *htmlArr = [strRequest componentsSeparatedByString:@"https://www.byebyetext.com/html_id/"];
        if (htmlArr.count>1) {
            NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
            NoticeWeb *web = [[NoticeWeb alloc] init];
            web.html_id = htmlArr[1];
            webctl.web = web;
            [self.navigationController pushViewController:webctl animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
    }
    else{
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
    }
}

- (void)showWebView{
    self.webView.hidden = NO;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self showToastWithText:@"网页加载失败"];
}

- (void)liuyanT{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 1000;
    inputView.delegate = self;
    inputView.isReply = NO;
    inputView.saveKey = [NSString stringWithFormat:@"html%@-%@",[NoticeTools getuserId],self.web.html_id];
    inputView.titleL.text = [NoticeTools getLocalStrWith:@"yl.saytozuozhe"];
    inputView.plaStr = [NoticeTools getLocalStrWith:@"yl.inpzuo"];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

//问题反馈的文字
- (void)sendTextDelegate:(NSString *)str{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:str forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"htmls/%@/dialog",self.web.html_id] Accept:@"application/vnd.shengxi.v2.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self requestList];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (UIView *)stayView{
    if (!_stayView) {
        _stayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 66)];
        _stayView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,GET_STRWIDTH([NoticeTools getLocalStrWith:@"yl.saytozuozhe"], 16, 66), 66)];
        label.font = SIXTEENTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"yl.saytozuozhe"];
        label.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [_stayView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+6, 0,GET_STRWIDTH([NoticeTools getLocalStrWith:@"yl.luyanjin"], 12, 66), 66)];
        label1.font = TWOTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        label1.userInteractionEnabled = YES;
        _stayView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liuyanT)];
        [_stayView addGestureRecognizer:tap];
        label1.text = [NoticeTools getLocalStrWith:@"yl.luyanjin"];
        [_stayView addSubview:label1];
    }
    return _stayView;
}
@end
