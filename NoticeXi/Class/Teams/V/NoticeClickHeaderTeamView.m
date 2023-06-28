//
//  NoticeClickHeaderTeamView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeClickHeaderTeamView.h"
#import "UIView+CLSetRect.h"
#import "NoticeTeamManageButtonArrCell.h"
@implementation NoticeClickHeaderTeamView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 560)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88)/2,96,88, 88)];
        [_iconImageView setAllCorner:44];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];

        self.markL = [[UILabel alloc] init];
        self.markL.font = ELEVENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.textColor = [UIColor whiteColor];
        self.markL.layer.cornerRadius = 2;
        self.markL.layer.masksToBounds = YES;
        [self.contentView addSubview:self.markL];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+15,DR_SCREEN_WIDTH, 25)];
        _nickNameL.font = EIGHTEENTEXTFONTSIZE;
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        _nickNameL.text = @"小二白菜";
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
                
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-50, 0, 50, 50)];
        [self.closeBtn setImage:UIImageNamed(@"Image_blackX") forState:UIControlStateNormal];
        [self.contentView addSubview:self.closeBtn];
        [self.closeBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:self.tableView];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.tableView.tableHeaderView = self.headerView;
    }
    return self;
}

- (void)setChatModel:(NoticeTeamChatModel *)chatModel{
    _chatModel = chatModel;
    if(![chatModel.fromUserM.userId isEqualToString:[NoticeTools getuserId]]){
        if(chatModel.fromUserM.identity.intValue == 3){//对方是超级管理员
            self.buttonArr = @[@"交流"];
        }else if(self.identity.intValue == 2){//自己是超级管理员
            if(chatModel.fromUserM.identity.intValue == 2){//对方也是管理员
                self.buttonArr = @[@"举报"];
            }
            else{
                self.buttonArr = @[@"举报",@"移出本社团",@"移出并禁止加入本社团"];
            }
        }else{
            self.buttonArr = @[@"举报"];
        }
    }

    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:chatModel.fromUserM.avatar_url]];
    self.nickNameL.text = chatModel.fromUserM.mass_nick_name;
    if(chatModel.fromUserM.identity.intValue > 1){
        self.markL.hidden = NO;
        self.markL.text = chatModel.fromUserM.identity.intValue==2?@"管理员":@"超级管理员";
        CGFloat width = GET_STRWIDTH(self.markL.text, 11, 16)+5;
        self.markL.frame = CGRectMake((DR_SCREEN_WIDTH-width)/2, CGRectGetMaxY(_iconImageView.frame)-16, width, 16);
        self.markL.backgroundColor = [UIColor colorWithHexString:chatModel.fromUserM.identity.intValue==2? @"#45C2EB":@"#F8D30D"];
    }else{
        self.markL.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)setPerson:(YYPersonItem *)person{
    _person = person;
    if(![person.userId isEqualToString:[NoticeTools getuserId]]){
        if(person.identity.intValue == 3){//对方是超级管理员
            self.buttonArr = @[@"交流"];
        }else if(self.identity.intValue == 2){//自己是超级管理员
            if(person.identity.intValue == 2){//对方也是管理员
                self.buttonArr = @[@"举报"];
            }
            else{
                self.buttonArr = @[@"举报",@"移出本社团",@"移出并禁止加入本社团"];
            }
        }else{
            self.buttonArr = @[@"举报"];
        }
    }

    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:person.avatar_url]];
    self.nickNameL.text = person.name;
    if(person.identity.intValue > 1){
        self.markL.hidden = NO;
        self.markL.text = person.identity.intValue==2?@"管理员":@"超级管理员";
        CGFloat width = GET_STRWIDTH(self.markL.text, 11, 16)+5;
        self.markL.frame = CGRectMake((DR_SCREEN_WIDTH-width)/2, CGRectGetMaxY(_iconImageView.frame)-16, width, 16);
        self.markL.backgroundColor = [UIColor colorWithHexString:person.identity.intValue==2? @"#45C2EB":@"#F8D30D"];
    }else{
        self.markL.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(self.clickButtonTagBlock){
        self.clickButtonTagBlock(self.buttonArr[indexPath.row]);
    }
    
    if (self.chatModel.fromUserM.identity.intValue == 3) {
        [self cancelClick];
    }
}

- (void)setButtonArr:(NSArray *)buttonArr{
    _buttonArr = buttonArr;
    CGFloat buttonHeight = 74*buttonArr.count-24;
    self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, (self.tableView.frame.size.height-buttonHeight)/2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTeamManageButtonArrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleL.text = self.buttonArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.buttonArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == (self.buttonArr.count-1)){
        return 50;
    }
    return 74;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225, DR_SCREEN_WIDTH, self.contentView.frame.size.height-225) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:NoticeTeamManageButtonArrCell.class forCellReuseIdentifier:@"cell"];
        _tableView.scrollEnabled = NO;
        [self.contentView addSubview:self.tableView];
        
    }
    return _tableView;
}



- (void)showIconView{

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
