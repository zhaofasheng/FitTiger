//
//  NoticeTopicBaseController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTopicBaseController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "SPMultipleSwitch.h"
@interface NoticeTopicBaseController ()
@property (nonatomic, strong) NoticerTopicSearchResultNewController *voiceVC;
@property (nonatomic, strong) NoticerTopicSearchResultNewController *textVC;
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@end

@implementation NoticeTopicBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.menuView.backgroundColor = self.view.backgroundColor;
    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"search.voice"],[NoticeTools getLocalStrWith:@"search.text"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,12, 68*2, 32);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];

    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#FFFFFF"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    switch1.trackerColor = [UIColor colorWithHexString:@"#0099E6"];
    _switchButton = switch1;
    [self.menuView addSubview:_switchButton];
}

- (void)setTopicName:(NSString *)topicName{
    _topicName = topicName;
    self.voiceVC.topicName = topicName;
    self.textVC.topicName = topicName;
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.selectIndex = (int)swithbtn.selectedSegmentIndex;
}

- (void)getCurrentScrollSet:(CGFloat)contentXset{

    CGFloat bilX = (115 /2) / DR_SCREEN_WIDTH;
    _switchButton.tracker.frame = CGRectMake(bilX*contentXset, 0,_switchButton.frame.size.width/2, _switchButton.frame.size.height);
}

- (void)getCurrentIndex:(NSInteger)currentIndex{
    _switchButton.selectedSegmentIndex = currentIndex;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,0, DR_SCREEN_WIDTH,44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,44, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44-48);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.voiceVC;
    }else{
        return self.textVC;
    }
}

- (NoticerTopicSearchResultNewController *)voiceVC{
    if (!_voiceVC) {
        _voiceVC = [[NoticerTopicSearchResultNewController alloc] init];
        _voiceVC.topicName = self.topicName;
        _voiceVC.topicId = self.topicId;
        _voiceVC.useSystemeNav = YES;
        _voiceVC.isTextVoice = NO;
        _voiceVC.fromSearch = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _voiceVC.view.backgroundColor = self.view.backgroundColor;
            _voiceVC.tableView.backgroundColor = self.view.backgroundColor;
        }
    }
    return _voiceVC;
}

- (NoticerTopicSearchResultNewController *)textVC{
    if (!_textVC) {
        _textVC = [[NoticerTopicSearchResultNewController alloc] init];
        _textVC.topicName = self.topicName;
        _textVC.topicId = self.topicId;
        _textVC.fromSearch = YES;
        _textVC.useSystemeNav = YES;
        _textVC.isTextVoice = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _textVC.view.backgroundColor = self.view.backgroundColor;
            _textVC.tableView.backgroundColor = self.view.backgroundColor;
        }
    }
    return _textVC;
}
@end
