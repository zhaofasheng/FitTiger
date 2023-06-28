//
//  NoticeUserCenterVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserCenterVoiceController.h"
#import "SPMultipleSwitch.h"

@interface NoticeUserCenterVoiceController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) SPMultipleSwitch *switchButton;

@end

@implementation NoticeUserCenterVoiceController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];

    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"search.voice"],[NoticeTools getLocalStrWith:@"search.text"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,10, 62*2, 24);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
    switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
    _switchButton = switch1;
    [self.menuView addSubview:_switchButton];
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

- (NoticeVoiceGroundController *)voiceVC{
    if (!_voiceVC) {
        _voiceVC = [[NoticeVoiceGroundController alloc] init];
        _voiceVC.type = 1;
        _voiceVC.userId = self.userId;
        _voiceVC.isOther = self.isOther;
        _voiceVC.isUserCenter = YES;
        __weak typeof(self) weakSelf = self;
        _voiceVC.playVoice = ^(BOOL play) {
            if (weakSelf.playVoice) {
                weakSelf.playVoice(YES);
            }
        };
    }
    return _voiceVC;
}

- (NoticeVoiceGroundController *)textVC{
    if (!_textVC) {
        _textVC = [[NoticeVoiceGroundController alloc] init];
        _textVC.type = 2;
        _textVC.userId = self.userId;
        _textVC.isOther = self.isOther;
        _textVC.isUserCenter = YES;
        __weak typeof(self) weakSelf = self;
        _textVC.playVoice = ^(BOOL play) {
            if (weakSelf.playVoice) {
                weakSelf.playVoice(YES);
            }
        };
    }
    return _textVC;
}
@end
