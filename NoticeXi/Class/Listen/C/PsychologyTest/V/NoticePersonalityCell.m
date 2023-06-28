//
//  NoticePersonalityCell.m
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePersonalityCell.h"
#import "NoticePerCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeXi-Swift.h"
@implementation NoticePersonalityCell
{
    UIView *_view2;
    UILabel *_headL;
    UIButton *_lookBtn;
    UIView *_radView;
    BOOL _hasRelod;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, 206+280)];
        _view2.backgroundColor = GetColorWithName(VBackColor);
        _view2.userInteractionEnabled = YES;
        [self.contentView addSubview:_view2];
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(20,10,_view2.frame.size.width-40,260)];
        self.webView.scrollView.bounces = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.backgroundColor = GetColorWithName(VBackColor);
        self.webView.backgroundColor = GetColorWithName(VBackColor);
        NSString *str = [NoticeTools isWhiteTheme]?[NSString stringWithFormat:@"document.body.style.backgroundColor=\"#FFFFFF\""]:[NSString stringWithFormat:@"document.body.style.backgroundColor=\"#181828\""];
        [self.webView evaluateJavaScript:str completionHandler:nil];
        self.webView.navigationDelegate = self;
        [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.dataArr = [NSMutableArray new];
        [_view2 addSubview:self.webView];
        self.webView.hidden = YES;
        
        _lookBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.webView.frame),_view2.frame.size.width ,53)];
        [_lookBtn setTitle:GETTEXTWITE(@"tt.more") forState:UIControlStateNormal];
        [_lookBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        _lookBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [_lookBtn addTarget:self action:@selector(lookAllClick) forControlEvents:UIControlEventTouchUpInside];
        [_view2 addSubview:_lookBtn];
        
        _headL = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_lookBtn.frame), _view2.frame.size.width-50,13)];
        _headL.font = FOURTHTEENTEXTFONTSIZE;
        _headL.textColor = GetColorWithName(VMainTextColor);
        [_view2 addSubview:_headL];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,CGRectGetMaxY(_headL.frame)+15,_view2.frame.size.width-40, 150-28);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticePerCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 60+10;
        [_view2 addSubview:self.movieTableView];

    }
    
    return self;
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//网页和tabbleView滑动协调处理
    [self.webView setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"scrollView.contentSize"]) {
        UIScrollView *scrollView = self.webView.scrollView;
        _personality.webHeight = scrollView.contentSize.height;
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.movieTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticePerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.person = _dataArr[indexPath.row];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAllPersonlity  *person = _dataArr[indexPath.row];
    NoticePerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
    NoticeTestShow *showView = [[NoticeTestShow alloc] init];
    showView.icomImageView.image = cell.iconImageView.image;
    [showView refreshTestDataWithModel:person];
    [showView showView];

}

- (void)lookAllClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookAllPersonlityDescDelegate)]) {
        [self.delegate lookAllPersonlityDescDelegate];
    }
}

- (void)setPersonality:(NoticePersonality *)personality{

    _personality = personality;
    if (!_hasRelod) {
        _hasRelod = YES;
       [self.webView loadHTMLString:personality.personality_desc_long baseURL:nil];
    }
    
    _view2.frame = CGRectMake(0, 0,DR_SCREEN_WIDTH, 206+(personality.isAll ? personality.webHeight : 280));
    self.webView.frame = CGRectMake(20,10,_view2.frame.size.width-40,personality.isAll ? personality.webHeight : 260);
    [_lookBtn setTitle:personality.isAll ? [NoticeTools getLocalStrWith:@"movie.clo"] :  GETTEXTWITE(@"tt.more") forState:UIControlStateNormal];
    _lookBtn.frame = CGRectMake(0,CGRectGetMaxY(self.webView.frame),_view2.frame.size.width ,53);
    _headL.text = [NSString stringWithFormat:@"%@代表角色（点击图片查看角色简介）",personality.personality_title];
    _headL.frame = CGRectMake(20,CGRectGetMaxY(_lookBtn.frame), _view2.frame.size.width-50,13);
    self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.movieTableView.frame = CGRectMake(20,CGRectGetMaxY(_headL.frame)+15,_view2.frame.size.width-40, 150-28);
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.webView.hidden = YES;
    //修改字体大小 300%
    NSString *str = [NoticeTools isWhiteTheme]?[NSString stringWithFormat:@"document.body.style.backgroundColor=\"#FFFFFF\""]:[NSString stringWithFormat:@"document.body.style.backgroundColor=\"#181828\""];
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"completionHandler:nil];
    [webView evaluateJavaScript:str completionHandler:nil];
    [ webView evaluateJavaScript:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 1000.0;" // WKWebView中显示的图片宽度
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

        CGFloat ratio =  CGRectGetWidth(self.webView.frame) /[result floatValue];
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);

        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){

            //NSLog(@"scrollHeight高度：%.2f",[result floatValue]*ratio);
            self->_personality.webHeight = [result floatValue]*ratio;
        }];

    }];
    
    /// 延时0.2s 显示网页
    [self performSelector:@selector(showWebView) withObject:self afterDelay:0.2];
}

- (void)showWebView{
    self.webView.hidden = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
