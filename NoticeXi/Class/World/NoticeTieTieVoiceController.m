//
//  NoticeTieTieVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2022/11/9.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieVoiceController.h"
#import "SPMultipleSwitch.h"
#import "NoticeTieTieRliDayVoiceController.h"
@interface NoticeTieTieVoiceController ()
@property (nonatomic, strong) NoticeTieTieRliDayVoiceController *smVC;
@property (nonatomic, strong) NoticeTieTieRliDayVoiceController *openVC;
@property (nonatomic, strong) NoticeTieTieRliDayVoiceController *sameVC;
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@end

@implementation NoticeTieTieVoiceController

- (NoticeTieTieRliDayVoiceController *)smVC{
    if(!_smVC){
        _smVC = [[NoticeTieTieRliDayVoiceController alloc] init];
        _smVC.ismonthVoice = YES;
        _smVC.visibility = @"3";
    }
    return _smVC;
}

- (NoticeTieTieRliDayVoiceController *)sameVC{
    if(!_sameVC){
        _sameVC = [[NoticeTieTieRliDayVoiceController alloc] init];
        _sameVC.ismonthVoice = YES;
        _sameVC.visibility = @"2";
    }
    return _sameVC;
}

- (NoticeTieTieRliDayVoiceController *)openVC{
    if(!_openVC){
        _openVC = [[NoticeTieTieRliDayVoiceController alloc] init];
        _openVC.ismonthVoice = YES;
        _openVC.visibility = @"1";
    }
    return _openVC;
}

- (void)setYear:(NSString *)year{
    _year = year;
    self.smVC.year = year;
    self.sameVC.year = year;
    self.openVC.year = year;
}

- (void)setMonth:(NSString *)month{
    _month = month;
    self.smVC.month = month;
    self.sameVC.month = month;
    self.openVC.month = month;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
    self.menuView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];

    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"n.onlyself"],[NoticeTools getLocalStrWith:@"n.tpkjian"],[NoticeTools getLocalStrWith:@"n.open"]]];
    switch1.titleFont = FOURTHTEENTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,20, DR_SCREEN_WIDTH-40, 32);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    _switchButton = switch1;
    [self.menuView addSubview:_switchButton];
}

- (void)refreshData{
    [self.smVC refreshData];
    [self.sameVC refreshData];
    [self.openVC refreshData];
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.selectIndex = (int)swithbtn.selectedSegmentIndex;
}

- (void)getCurrentScrollSet:(CGFloat)contentXset{

    CGFloat bilX = ((DR_SCREEN_WIDTH-40) /3) / DR_SCREEN_WIDTH;
    _switchButton.tracker.frame = CGRectMake(bilX*contentXset, 0,_switchButton.frame.size.width/3, _switchButton.frame.size.height);
}

- (void)getCurrentIndex:(NSInteger)currentIndex{

    _switchButton.selectedSegmentIndex = currentIndex;

}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,0, DR_SCREEN_WIDTH,70);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,70, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-70);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.smVC;
    }else if (index == 1){
        return self.sameVC;
    }
    else{
        return self.openVC;
    }
}
@end
