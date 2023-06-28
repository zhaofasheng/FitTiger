//
//  NoticeCllockTagView.m
//  NoticeXi
//
//  Created by li lei on 2020/4/14.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCllockTagView.h"

@implementation NoticeCllockTagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH-40, frame.size.height)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        
        self.allBtn = [[UIButton alloc] initWithFrame:CGRectMake(2,(backView.frame.size.height-32)/2,56, 32)];
        [self.allBtn setTitle:[NoticeTools getLocalStrWith:@"py.allPy"] forState:UIControlStateNormal];
        self.allBtn.layer.cornerRadius = 32/2;
        self.allBtn.layer.masksToBounds = YES;
        self.allBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.allBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        self.allBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backView addSubview:self.allBtn];
        self.allBtn.tag = 1;
        [self.allBtn addTarget:self action:@selector(choiceTag:) forControlEvents:UIControlEventTouchUpInside];
        
        self.requestBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allBtn.frame)+6, (backView.frame.size.height-32)/2, 84, 32)];
        [self.requestBtn setTitle:[NoticeTools getLocalStrWith:@"py.tag1"] forState:UIControlStateNormal];
        self.requestBtn.layer.cornerRadius = 32/2;
        self.requestBtn.layer.masksToBounds = YES;
        self.requestBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        self.requestBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [backView addSubview:self.requestBtn];
        self.requestBtn.tag = 2;
        [self.requestBtn addTarget:self action:@selector(choiceTag:) forControlEvents:UIControlEventTouchUpInside];
        
        self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.requestBtn.frame)+6, (backView.frame.size.height-32)/2,100, 32)];
        [self.refreshBtn setTitle:[NoticeTools getLocalStrWith:@"py.tag2"] forState:UIControlStateNormal];
        self.refreshBtn.layer.cornerRadius = 32/2;
        self.refreshBtn.layer.masksToBounds = YES;
        self.refreshBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        self.refreshBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [backView addSubview:self.refreshBtn];
        self.refreshBtn.tag = 3;
        [self.refreshBtn addTarget:self action:@selector(choiceTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setCurrentChoice:(NSInteger)currentChoice{
    _currentChoice = currentChoice;

    [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.refreshBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    [self.allBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.allBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.requestBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIButton *btn = nil;
    if (currentChoice == 1) {
        btn = self.allBtn;
    }else if (currentChoice == 2){
        btn = self.requestBtn;
    }else{
        btn = self.refreshBtn;
    }
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}

- (void)choiceTag:(UIButton *)btn{
    if (self.isSendTc && btn == self.allBtn) {
        return;
    }
    _currentChoice = btn.tag;

    [self.refreshBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.refreshBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    [self.allBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.allBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    [self.requestBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    self.requestBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    if (self.setTagBlock) {
        self.setTagBlock(btn.tag);
    }
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}

@end
