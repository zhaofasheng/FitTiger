//
//  NoticeEmotionController.m
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeEmotionController.h"
#import "NoticeEmotionView.h"
@interface NoticeEmotionController ()
@property (nonatomic, strong) NoticeEmotionView *emotionView;
@property (nonatomic, strong) UIButton *managerBtn;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *moveBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger num;
@end

@implementation NoticeEmotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"emtion.title"];
    self.emotionView = [[NoticeEmotionView alloc] initWithNoHot];
    self.emotionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.emotionView.collectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.emotionView.isManager = YES;
    __weak typeof(self) weakSelf = self;
    self.emotionView.choiceBlock = ^(NSInteger num) {
        weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",[NoticeTools getLocalStrWith:@"emtion.choice"],num];
        weakSelf.num = num;
        weakSelf.deleteBtn.alpha = num?1:0.5;
        weakSelf.moveBtn.alpha = num?10:5;
        [weakSelf.deleteBtn setTitleColor:[UIColor colorWithHexString:num?@"#EE4B4E": @"#DB6E6E"] forState:UIControlStateNormal];
        [weakSelf.moveBtn setTitleColor:num? [UIColor colorWithHexString:@"#FFFFFF"]:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        [weakSelf.managerBtn setTitleColor:[UIColor colorWithHexString:weakSelf.num? @"#0099E6":@"#A1A7B3"] forState:UIControlStateNormal];
    };
    self.emotionView.backgroundColor = self.view.backgroundColor;
    self.emotionView.collectionView.backgroundColor = self.view.backgroundColor;
    self.emotionView.refashBlock = ^(BOOL reafsh) {
        weakSelf.refashBlock(YES);
    };
    
    self.emotionView.noChoiceBlock = ^(BOOL reafsh) {
        [weakSelf managerClick];
    };
    
    [self.view addSubview:self.emotionView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,0,40,40);
    [btn setTitle:[NoticeTools getLocalType]?@" Edit": @"  管理" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    self.managerBtn = btn;
    [btn addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)managerClick{
    self.isChoice = !self.isChoice;
    [self.managerBtn setTitle:self.isChoice? ([NoticeTools getLocalType]?@"Done":@"  完成"):([NoticeTools getLocalType]?@" Edit": @"  管理") forState:UIControlStateNormal];
    [self.managerBtn setTitleColor:[UIColor colorWithHexString:(self.num && self.isChoice)? @"#0099E6":@"#A1A7B3"] forState:UIControlStateNormal];
    self.emotionView.isBeginChoice = self.isChoice;
    self.navigationItem.title = self.isChoice?[NSString stringWithFormat:@"%@(%ld)",[NoticeTools getLocalStrWith:@"emtion.choice"],self.num]:[NoticeTools getLocalStrWith:@"emtion.title"];
    self.emotionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-(self.isChoice?50:0));
    self.buttonView.hidden = !self.isChoice;
    if (!self.isChoice) {
        [self.emotionView clearChoice];
    }
}

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.emotionView.frame), DR_SCREEN_WIDTH, 50)];
        _buttonView.backgroundColor = self.view.backgroundColor;
        
        UIButton *perBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [NoticeTools getLocalType]?120:80, 50)];
        [perBtn setTitle:[NoticeTools getLocalStrWith:@"emtion.movefont"] forState:UIControlStateNormal];
        perBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        perBtn.alpha = 0.5;
        [perBtn setTitleColor:self.num? [UIColor colorWithHexString:@"#FFFFFF"]:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        [_buttonView addSubview:perBtn];
        [perBtn addTarget:self action:@selector(moveClick) forControlEvents:UIControlEventTouchUpInside];
        self.moveBtn = perBtn;
        
        UIButton *deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [deleBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        deleBtn.alpha = 0.5;
        deleBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [deleBtn setTitleColor:self.num? [UIColor colorWithHexString:@"#DB6E6E"]:[UIColor colorWithHexString:@"#FF6669"] forState:UIControlStateNormal];
        [_buttonView addSubview:deleBtn];
        [deleBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn = deleBtn;
        [self.view addSubview:_buttonView];
    }
    return _buttonView;
}

- (void)moveClick{
    [self.emotionView moveClick];
}

- (void)deleteClick{
    [self.emotionView deleteClick];
}
@end
