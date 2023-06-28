//
//  NoticeTimeList.m
//  NoticeXi
//
//  Created by li lei on 2018/12/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimeList.h"
#import "NoticeTimeListCell.h"
#import <MJRefresh.h>

@implementation NoticeTimeList

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;

        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 354+8+44)];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 18+38)];
        label.text = GETTEXTWITE(@"sgj.jy");
        label.font = EIGHTEENTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainTextColor);
        _titleL = label;
        [_contentView addSubview:label];
        
        UIView *smLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame),DR_SCREEN_WIDTH, 0.5)];
        smLine.backgroundColor = GetColorWithName(VlineColor);
        [_contentView addSubview:smLine];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(smLine.frame), DR_SCREEN_WIDTH, _contentView.frame.size.height-CGRectGetMaxY(smLine.frame)-8-44)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = GetColorWithName(VBackColor);
        [_tableView registerClass:[NoticeTimeListCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-354-8-44)];
        tapView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissTap)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
        _pickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(frame.size.width-15-(frame.size.width-30)/2,0,(frame.size.width-30)/2,18+37)];
        //_pickerView.delegate = self;
        [_pickerView scrollToIndex:12/2];
        
        [_contentView addSubview:_pickerView];
    }
    return self;
}

- (void)setIsZj:(BOOL)isZj{
    _isZj = isZj;
    if (isZj) {
        [_pickerView removeFromSuperview];
        if (_isOther) {
            return;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-120, 0, 120, 18+38)];
        label.text = self.isLimit?@"如何收藏和删除对话?": @"如何添加和移除心情?";
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#46CDCF":@"#318F90"];
        [_contentView addSubview:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(howUserTap)];
        [label addGestureRecognizer:tap];
    
    }
}

- (void)setUserId:(NSString *)userId{
    _userId = userId;
}


- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
    for (NoticeVoiceListModel *model in self.dataArr) {
        if ([model.voice_id isEqualToString:currentModel.voice_id]) {//当前声昔
            model.isPlaying = YES;
        }else{
            model.isPlaying = NO;
        }
    }
    [self.tableView reloadData];
}

- (void)howUserTap{
    if (self.isLimit) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderViewZjLlimiy];
        [pinV showTostView];
        return;
    }
    NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithLeaderView];
    [pinV showTostView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.delegate && self.delegate && [self.delegate respondsToSelector:@selector(choiceModelWithIndex:)]) {
        [self.delegate choiceModelWithIndex:indexPath.row];
    }
    [self dissMissTap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTimeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.voice = self.dataArr[indexPath.row];
    return cell;
}

- (void)show:(UIViewController *)ctl{
    [ctl.navigationController.view addSubview:self];
    if (!_dataArr.count) {
        self.tableView.tableHeaderView = self.footView;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-354-8-44, DR_SCREEN_WIDTH, 354+8+44);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{
    
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 354+8+44);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isZj) {
        return @[];
    }
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:self.isLimit?[NoticeTools getLocalStrWith:@"groupManager.del"]: @"移除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(removeAtIndex:)]) {
            [self.delegate removeAtIndex:indexPath.row];
        }
    }];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}


- (void)setRealisAbout:(NoticeAbout *)realisAbout{
    _realisAbout = realisAbout;
    if (!realisAbout.whitelist && realisAbout.friend_status.intValue != 2) {
        if ([_realisAbout.strange_view isEqualToString:@"7"] || [_realisAbout.strange_view isEqualToString:@"30"]) {
            self.footView.titleL.text = @"ta最近没有心情";
            self.subTitleL.text = [_realisAbout.strange_view isEqualToString:@"7"]? [NoticeTools getTextWithSim:@"ta设置了非学友七天可见" fantText:@"ta設置了非学友七天可見"]:[NoticeTools getTextWithSim:@"ta设置了非学友三十天可见" fantText:@"ta設置了非学友三十天可見"];
            _pickerView.hidden = YES;
        }else{
            self.footView.titleL.text = [NoticeTools isSimpleLau]?@"ta还没有心情":@"ta還沒有心情";
        }
    }else{
        self.footView.titleL.text = [NoticeTools isSimpleLau]?@"ta还没有心情":@"ta還沒有心情";
    }
}

- (void)sendClick{
    [self dissMissTap];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendEmiton)]) {
        [self.delegate sendEmiton];
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if (!_dataArr.count) {
        self.tableView.tableHeaderView = self.footView;
        _pickerView.hidden = YES;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];
}

- (UILabel *)subTitleL{
    if (!_subTitleL) {
        _subTitleL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-300-15, 0,300, 18+38)];
        _subTitleL.textAlignment = NSTextAlignmentRight;
        _subTitleL.font = THRETEENTEXTFONTSIZE;
        _subTitleL.backgroundColor = self.backgroundColor;
        _subTitleL.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"];
        [_contentView addSubview:_subTitleL];
    }
    return _subTitleL;
}
@end
