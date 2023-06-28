//
//  NoticeZjListView.m
//  NoticeXi
//
//  Created by li lei on 2019/8/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZjListView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeAddZjController.h"
#import "NoticeZJlistCell.h"
#import "NoticeNewAddZjView.h"
@implementation NoticeZjListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.canLoad = YES;
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 324+BOTTOM_HEIGHT+20)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalStrWith:@"zj.addtozj"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_contentView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,70, DR_SCREEN_WIDTH, _contentView.frame.size.height-70-20)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[NoticeZJlistCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        [self createRefesh];
        
        [self.tableView.mj_header beginRefreshing];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-_contentView.frame.size.height)];
        tapView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissTap)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 80)];
        self.tableView.tableHeaderView = headerView;
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addzjClick)];
        [headerView addGestureRecognizer:addTap];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 70)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [headerView addSubview:backView];
        
        UIImageView *_zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8,54,54)];
        _zjImageView.image = UIImageNamed(@"Image_addzjdefault");
        [backView addSubview:_zjImageView];
        
        UILabel *_nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,0,DR_SCREEN_WIDTH-40-10-8-54-15-24,70)];
        _nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _nameL.font = SIXTEENTEXTFONTSIZE;
        _nameL.text = [NoticeTools getLocalStrWith:@"zj.creatnewzj"];
        [backView addSubview:_nameL];
    }
    return self;
}

- (void)setIsText:(BOOL)isText{
    _isText = isText;
    _titleL.text = isText?[NoticeTools getLocalStrWith:@"zj.addtext"]:[NoticeTools getLocalStrWith:@"zj.addvoice"];
}

- (instancetype)initWithFrame:(CGRect)frame isLimit:(BOOL)isLimit{
    if (self = [super initWithFrame:frame]) {
        self.isLimit = YES;
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 324+BOTTOM_HEIGHT+20)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _contentView.layer.cornerRadius = 20;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalStrWith:@"zj.addtodia"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        _titleL = label;
        [_contentView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,70, DR_SCREEN_WIDTH, _contentView.frame.size.height-70-20)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.contentView.backgroundColor;
        [_tableView registerClass:[NoticeZJlistCell class] forCellReuseIdentifier:@"cell"];
        [_contentView addSubview:_tableView];
        [self createRefesh];
        
        [self.tableView.mj_header beginRefreshing];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height-_contentView.frame.size.height)];
        tapView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissTap)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 80)];
        self.tableView.tableHeaderView = headerView;
        headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addzjClick)];
        [headerView addGestureRecognizer:addTap];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 70)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [headerView addSubview:backView];
        
        UIImageView *_zjImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8,54,54)];
        _zjImageView.image = UIImageNamed(@"Image_addzjdefault");
        [backView addSubview:_zjImageView];
        
        UILabel *_nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zjImageView.frame)+10,0,DR_SCREEN_WIDTH-40-10-8-54-15-24,70)];
        _nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _nameL.font = SIXTEENTEXTFONTSIZE;
        _nameL.text = [NoticeTools getLocalStrWith:@"zj.creatnewzj"];
        [backView addSubview:_nameL];
    }
    return self;
}

- (void)setDialogId:(NSString *)dialogId{
    _dialogId = dialogId;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setIsMove:(BOOL)isMove{
    _isMove = isMove;
    if (isMove) {
        _titleL.text = [NoticeTools getLocalStrWith:@"zj.moveduihuato"];
    }
}

- (void)createRefesh{
    
    __weak NoticeZjListView *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByField=updatedAt",[[NoticeSaveModel getUserInfo] user_id]];
    }else{
        url = [NSString stringWithFormat:@"user/%@/voiceAlbum?orderByValue=%@&orderByField=updatedAt",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
     
    }
    
    
    if (self.isLimit) {
        if (self.isDown) {
            url = @"dialogAlbums?orderByField=updatedAt";
        }else{
            url = [NSString stringWithFormat:@"dialogAlbums?orderByValue=%@&orderByField=updatedAt",self.lastId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isLimit ? @"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeZjModel *model = [NoticeZjModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeZjModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.updated_at;
            }
            [self.tableView reloadData];
            self.canLoad = YES;
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeZjModel *model = self.dataArr[indexPath.row];
    if (self.isMove) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(moveToZjId: diaiD:)]) {
            [self.delegate moveToZjId:model.albumId diaiD:self.dialogId];
        }
        [self dissMissTap];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.isLimit) {
        [parm setValue:self.dialogId forKey:@"dialogId"];
        [parm setObject:self.isGroup?@"2":@"1" forKey:@"sourceType"];
    }else{
        [parm setObject:self.choiceM.voice_id forKey:@"voiceId"];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSString *url = nil;
    if (self.isLimit) {
        url = [NSString stringWithFormat:@"albumDialogs/%@",model.albumId];
    }else{
        url = [NSString stringWithFormat:@"user/%@/albumVoice/%@",[[NoticeSaveModel getUserInfo] user_id],model.albumId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isLimit? @"application/vnd.shengxi.v4.7.6+json" : @"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {                                                                                                                                                                                                               
            if (!self.isLimit) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHZJARR" object:nil];
            }
            self.isAdd = YES;
            self.choiceName = model.album_name;
            if (self.addSuccessBlock) {
                self.addSuccessBlock(model);
            }
            [self dissMissTap];
        }else{
            [self dissMissTap];
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeZJlistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isLimit = self.isLimit;
    cell.zjModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)addzjClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    __weak typeof(self) weakSelf = self;
    NoticeNewAddZjView *inputView = [[NoticeNewAddZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.isDiaZJ = self.isLimit;
    inputView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
        if (name.length > 20) {
            [nav showToastWithText:[NoticeTools getLocalStrWith:@"zj.nozishulimit"]];
            return;
        }
        
        
        NSMutableDictionary *parm = [NSMutableDictionary new];
        if (self.isLimit) {
            [parm setObject:@"0" forKey:@"bucketId"];
            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
            [parm setObject:name forKey:@"albumName"];
            if (self.dialogId) {
                [parm setObject:self.dialogId forKey:@"dialogId"];
                if (self.isGroup) {
                    [parm setObject:self.isGroup?@"2":@"1" forKey:@"sourceType"];
                }
            }
        }else{
            [parm setObject:name forKey:@"albumName"];
            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];
            if (weakSelf.choiceM) {
                [parm setObject:weakSelf.choiceM.voice_id forKey:@"voiceId"];
            }
        }
        if (self.isMove) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(moveAndCreateNewdiaiD:parm:)]) {
                [self.delegate moveAndCreateNewdiaiD:self.dialogId parm:parm];
            }
            [self dissMissTap];
            return;
        }
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLimit?@"dialogAlbums":[NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:self.isLimit?@"application/vnd.shengxi.v4.7.6+json":@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [nav.topViewController showToastWithText:[NSString stringWithFormat:@"%@[%@]",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],name]];
                [weakSelf.tableView.mj_header beginRefreshing];
                NoticeMJIDModel *idmodel = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                NoticeZjModel *model = [[NoticeZjModel alloc] init];
                model.album_name = name;
                model.voice_num = @"1";
                model.albumId = idmodel.allId;
                if (weakSelf.addSuccessBlock) {
                    weakSelf.addSuccessBlock(model);
                }
                [weakSelf dissMissTap];
            }
            [nav.topViewController hideHUD];
        } fail:^(NSError * _Nullable error) {
            [nav.topViewController hideHUD];
        }];
    };
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.nameField becomeFirstResponder];

}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.isAdd) {
            self.isAdd = NO;
            [nav.topViewController showToastWithText:[NSString stringWithFormat:@"%@[%@]%@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],self.choiceName,[NoticeTools getLocalType]==1?@"album":@"专辑"]];
        }
    }];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

@end
