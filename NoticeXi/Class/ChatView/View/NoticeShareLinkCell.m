//
//  NoticeShareLinkCell.m
//  NoticeXi
//
//  Created by li lei on 2020/12/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareLinkCell.h"
#import "NoticeWebViewController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeShareLinkCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goWeb)];
        [self addGestureRecognizer:tap];
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 33, 33)];
        self.titleImageView.layer.cornerRadius = 2;
        self.titleImageView.layer.masksToBounds = YES;
        [self addSubview:self.titleImageView];
        

        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame)+5, 0,frame.size.width-10-5-33, 53)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.titleL];
        
    }
    return self;
}



- (void)goWeb{
    
    if (self.dissMissTapBlock) {
        self.dissMissTapBlock(YES);
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NSString *urlStr = self.shareUrl;
    if (![NoticeTools isWhetherNoUrl:urlStr]) {//存在中文字的话
        NSArray *arr = [NoticeTools getURLFromStr:urlStr];
        if (arr.count) {
             urlStr = arr[0];
        
        }else{
            return;
        }
    }

    NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
    webctl.url = urlStr;
    webctl.isFromShare = YES;
    [nav.topViewController.navigationController pushViewController:webctl animated:YES];
}

- (void)setShareUrl:(NSString *)shareUrl{
    _shareUrl = shareUrl;
    
    NSString *name = @"";
    NSString *url = shareUrl;
    if ([url containsString:@"xiaohongshu"] || [url containsString:@"xhslink"]) {
        self.titleImageView.image = UIImageNamed(@"Image_xiaohongshu");
        name = @"小红书";
        
    } else if ([url containsString:@"zhihu"]) {
        self.titleImageView.image = UIImageNamed(@"Image_zhihu");
        name = @"知乎";
        
    } else if ([url containsString:@"bilibili"]) {
        self.titleImageView.image = UIImageNamed(@"Image_bilibili");
       name = @"哔哩哔哩";
        
    }else if ([url containsString:@"b23"]) {
        self.titleImageView.image = UIImageNamed(@"Image_bilibili");
        name = @"哔哩哔哩";
    }
    else if ([url containsString:@"weibo"]) {
        self.titleImageView.image = UIImageNamed(@"Image_wb");
        name = @"微博";
    } else if ([url containsString:@"douban"]) {
        self.titleImageView.image = UIImageNamed(@"Image_douban");
        name = @"豆瓣";
    } else if ([url containsString:@"douyin"]) {
        self.titleImageView.image = UIImageNamed(@"Image_douyin");
        name = @"抖音";
    } else if ([url containsString:@"kuaishou"]) {
        self.titleImageView.image = UIImageNamed(@"Image_kuaishou");
        name = @"快手";
    }else if ([url containsString:@"y.qq.com"]) {
        self.titleImageView.image = UIImageNamed(@"Image_qqyinyew");
        name = @"qq音乐";
    }else if ([url containsString:@"music.163.com"]) {
        self.titleImageView.image = UIImageNamed(@"Image_wangyiyun");
        name = @"网易云";
    }else if ([url containsString:@"byebyetext.com"]) {
        self.titleImageView.image = UIImageNamed(@"Image_shegnxishanre");
        name = @"声昔";
    }
    else{
        self.titleImageView.image = UIImageNamed(@"Image_wzlink");
        name =[NoticeTools getLocalType]==0? @"未知":([NoticeTools getLocalType]==1?@"Unknown":@"わからない");
    }
    
    if ([NoticeTools getLocalType] == 1) {
        self.titleL.text = [NSString stringWithFormat:@"「shared a link %@」",name];
    }else if ([NoticeTools getLocalType] == 1){
        self.titleL.text = [NSString stringWithFormat:@"「%@ xxリンクを共有しました」",name];
    }else{
        self.titleL.text = [NSString stringWithFormat:@"「分享了%@链接」",name];
    }
}
@end
