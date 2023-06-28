//
//  NoticeDefaultMessageView.m
//  NoticeXi
//
//  Created by li lei on 2020/8/7.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeDefaultMessageView.h"

@implementation NoticeDefaultMessageView
{
    BOOL _isShowImg;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44)];
        _contentView.backgroundColor = GetColorWithName(VBackColor);
        _contentView.layer.cornerRadius = 5;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _contentView.frame.size.height-44, DR_SCREEN_WIDTH, 44)];
        button.backgroundColor = _contentView.backgroundColor;
        [button setTitle:[NoticeTools getLocalStrWith:@"chat.close"] forState:UIControlStateNormal];
        [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.frame.size.height-44-8, DR_SCREEN_WIDTH, 8)];
        line.backgroundColor = GetColorWithName(VBigLineColor);
        [_contentView addSubview:line];
        
        
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2*i, 0, DR_SCREEN_WIDTH/2, 18+38)];
            [btn setTitle:i==0?[NoticeTools getLocalStrWith:@"group.imgs"]:[NoticeTools getLocalStrWith:@"search.voice"] forState:UIControlStateNormal];
            [btn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            btn.backgroundColor = GetColorWithName(VBackColor);
            btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            if ( i == 1) {
                self.voiceBtn = btn;
                [btn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
                btn.backgroundColor = GetColorWithName(VMainThumeColor);
            }else{
                self.imgBtn = btn;
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
        
        UIView *smLine = [[UIView alloc] initWithFrame:CGRectMake(0,18+38,DR_SCREEN_WIDTH, 0.5)];
        smLine.backgroundColor = GetColorWithName(VlineColor);
        [_contentView addSubview:smLine];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(smLine.frame), DR_SCREEN_WIDTH, _contentView.frame.size.height-CGRectGetMaxY(smLine.frame)-8-44)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = GetColorWithName(VBackColor);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];

        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-_contentView.frame.size.height)];
        tapView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissTap)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
  
    }
    return self;
}

- (void)choiceClick:(UIButton *)btn{
    _isShowImg = btn.tag == 0?YES:NO;
    [self.tableView reloadData];
    if (btn.tag == 0) {
        [self.voiceBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        self.voiceBtn.backgroundColor = GetColorWithName(VBackColor);
        [self.imgBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        self.imgBtn.backgroundColor = GetColorWithName(VMainThumeColor);
    }else{
        [self.imgBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        self.imgBtn.backgroundColor = GetColorWithName(VBackColor);
        [self.voiceBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        self.voiceBtn.backgroundColor = GetColorWithName(VMainThumeColor);
    }
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(263+44+44), DR_SCREEN_WIDTH, 263+44+44);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{

    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _isShowImg?self.imgArr.count: self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = FOURTHTEENTEXTFONTSIZE;
    cell.textLabel.textColor = GetColorWithName(VMainTextColor);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,40);
    NoticeYuSetModel *model = _isShowImg?self.imgArr[indexPath.row]:self.dataArr[indexPath.row];
    cell.textLabel.text = model.reply_remark;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeYuSetModel *model = _isShowImg?self.imgArr[indexPath.row]:self.dataArr[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageWithDefault:)]) {
        [self.delegate sendMessageWithDefault:model];
    }
    [self dissMissTap];
}
@end
