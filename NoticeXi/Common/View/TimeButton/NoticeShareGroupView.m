//
//  NoticeShareGroupView.m
//  NoticeXi
//
//  Created by li lei on 2020/10/21.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareGroupView.h"
#import "NoticeShanreGroupCell.h"
#import "NoticeSharePersonCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeShareGroupView

- (instancetype)initWithSendVoiceWith{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,208+BOTTOM_HEIGHT+20)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
        for (int i = 0; i < 2; i ++) {
            UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/3+(80+(DR_SCREEN_WIDTH-160)/3)*i, 35, 80, 48+14+20)];
            tapV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            tapV.userInteractionEnabled = YES;
            UITapGestureRecognizer *choiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceVoiceTap:)];
            [tapV addGestureRecognizer:choiceTap];
            [self.keyView addSubview:tapV];
            tapV.tag = i+1;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(32/2, 0, 48, 48)];
            imageView.userInteractionEnabled = YES;
            if (i == 0) {
                imageView.image = UIImageNamed(@"Image_sendVoiceImgd");
            }else{
                imageView.image = UIImageNamed(@"Img_voicetypetext");
            }
            [tapV addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+14, 80, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = i==0?[NoticeTools getLocalStrWith:@"group.senvoice"]:[NoticeTools getLocalStrWith:@"group.sendtext"];
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            [tapV addSubview:label];
        }
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,151, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,159, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
        
        self.keyView.userInteractionEnabled = YES;
        
    }
    return self;
}

- (instancetype)initWithRecodeWith{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,208+BOTTOM_HEIGHT+20)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
        for (int i = 0; i < 2; i ++) {
            UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/3+(80+(DR_SCREEN_WIDTH-160)/3)*i, 35, 80, 48+14+20)];
            tapV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            tapV.userInteractionEnabled = YES;
            UITapGestureRecognizer *choiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceVoiceTap:)];
            [tapV addGestureRecognizer:choiceTap];
            [self.keyView addSubview:tapV];
            tapV.tag = i;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(32/2, 0, 48, 48)];
            imageView.userInteractionEnabled = YES;
            if (i == 0) {
                imageView.image = UIImageNamed(@"Image_paycenter");
            }else{
                imageView.image = UIImageNamed(@"Image_duihuanjilu");
            }
            [tapV addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+14, 80, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = i==0?[NoticeTools getLocalStrWith:@"zb.chjilu"]:[NoticeTools getLocalStrWith:@"zb.dhcenter"];
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            [tapV addSubview:label];
        }
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,151, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,159, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
        
        self.keyView.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithShareVoiceToGroup{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,246+BOTTOM_HEIGHT+20)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.text = [NoticeTools getLocalStrWith:@"group.shareto"];
        label.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:label];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,65,DR_SCREEN_WIDTH-20, 96);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = self.keyView.backgroundColor;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeShanreGroupCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 160;
        [self.keyView addSubview:self.movieTableView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,186, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,196, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
        
        self.keyView.userInteractionEnabled = YES;
        
        self.dataArr = [NSMutableArray new];
        
    }
    return self;
}

- (instancetype)initWithShareOtherDrawToGroup{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 393)];
        self.keyView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 10;
        self.keyView.layer.masksToBounds = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 17)];
        label.font = SEVENTEENTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainTextColor);
        label.text = [NoticeTools getLocalStrWith:@"group.shareto"];
        [self.keyView addSubview:label];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,65,DR_SCREEN_WIDTH-20, 155);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = GetColorWithName(VBackColor);
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeShanreGroupCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 155;
        [self.keyView addSubview:self.movieTableView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.keyView.frame.size.height-50-8-10-90, DR_SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line2];
        
        UIView *collectionV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), 70, 89)];
        [self.keyView addSubview:collectionV];
        collectionV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collTap)];
        [collectionV addGestureRecognizer:tap];
        
        self.collecImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
        [collectionV addSubview:self.collecImageView];
        
        self.collL = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.collecImageView.frame)+9, 70, 13)];
        self.collL.textColor = GetColorWithName(VMainTextColor);
        self.collL.font = TWOTEXTFONTSIZE;
        self.collL.textAlignment = NSTextAlignmentCenter;
        [collectionV addSubview:self.collL];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.keyView.frame.size.height-50-8-10, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-50-10, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
        
        self.keyView.userInteractionEnabled = YES;
        
        self.dataArr = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithShareSelfDrawToGroup{
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 393+15)];
        self.keyView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 10;
        self.keyView.layer.masksToBounds = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line];
        
        self.personTableView = [[UITableView alloc] init];
        self.personTableView.delegate = self;
        self.personTableView.dataSource = self;
        self.personTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.personTableView.frame = CGRectMake(10,CGRectGetMaxY(line.frame),DR_SCREEN_WIDTH-20,90);
        _personTableView.showsVerticalScrollIndicator = NO;
        self.personTableView.backgroundColor = GetColorWithName(VBackColor);
        self.personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.personTableView registerClass:[NoticeSharePersonCell class] forCellReuseIdentifier:@"cell1"];
        self.personTableView.rowHeight = 90;
        [self.keyView addSubview:self.personTableView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 17)];
        label.font = SEVENTEENTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainTextColor);
        label.text = [NoticeTools getLocalStrWith:@"group.shareto"];
        [self.keyView addSubview:label];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,65+90, DR_SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line2];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,65+91+15,DR_SCREEN_WIDTH-20, 155);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = GetColorWithName(VBackColor);
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeShanreGroupCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 155;
        [self.keyView addSubview:self.movieTableView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.keyView.frame.size.height-50-8-10, DR_SCREEN_WIDTH, 8)];
        line1.backgroundColor = GetColorWithName(VlineColor);
        [self.keyView addSubview:line1];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-50-10, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.keyView.frame.size.height)];
        cancelView.userInteractionEnabled = YES;
        [self addSubview:cancelView];
        [cancelView addGestureRecognizer:cancelTap];
        
        self.keyView.userInteractionEnabled = YES;

        
        self.dataArr = [NSMutableArray new];
        [self request];
        
    }
    return self;
}


- (void)collTap{
    if (self.clickCollectBlock) {
        self.clickCollectBlock(YES);
    }
}

- (void)setDrawM:(NoticeDrawList *)drawM{
    _drawM = drawM;
    if (_drawM.collection_id && _drawM.collection_id.length) {
        self.collL.text = [NoticeTools getLocalStrWith:@"emtion.scSus"];
        self.collecImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_newcolldraw_sb":@"Image_newcolldraw_sy");
    }else{
        self.collL.text = [NoticeTools getLocalStrWith:@"group.coltomine"];
        self.collecImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_newcolldraw_nb":@"Image_newcolldraw_ny");
    }
}

- (UILabel *)noGroupL{
    if (!_noGroupL) {
        _noGroupL = [[UILabel alloc] initWithFrame:self.movieTableView.frame];
        _noGroupL.font = SIXTEENTEXTFONTSIZE;
        _noGroupL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _noGroupL.textAlignment = NSTextAlignmentCenter;
        [self.keyView addSubview:_noGroupL];
        //self.keyView.backgroundColor = self.backgroundColor;
        _noGroupL.text = [NoticeTools getLocalStrWith:@"group.nojoingroup"];
        _noGroupL.hidden = YES;
    }
    return _noGroupL;
}

- (UILabel *)noFriendL{
    if (!_noFriendL) {
        _noFriendL = [[UILabel alloc] initWithFrame:self.personTableView.frame];
        _noFriendL.font = SIXTEENTEXTFONTSIZE;
        _noFriendL.textColor = GetColorWithName(VDarkTextColor);
        _noFriendL.textAlignment = NSTextAlignmentCenter;
        _noFriendL.backgroundColor = GetColorWithName(VBackColor);
        [self.keyView addSubview:_noFriendL];
        _noFriendL.text = [NoticeTools getLocalStrWith:@"group.nofriend"];
        _noFriendL.hidden = YES;
    }
    return _noFriendL;
}

- (void)request{
    self.personArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/friends",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyFriends *model = [NoticeMyFriends mj_objectWithKeyValues:dic];
                [self.personArr addObject:model];
            }

            if (!self.personArr.count) {
                self.noFriendL.hidden = NO;
            }else{
                if (self.personArr.count >9) {
                    NoticeMyFriends *moreFriend = [NoticeMyFriends new];
                    moreFriend.isMore = YES;
                    [self.personArr addObject:moreFriend];
                }
            }
            [self.personTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.personTableView) {
        NoticeMyFriends *model = self.personArr[indexPath.row];
        if (model.isMore) {
            [self cancelClick];
            if (self.clickMoreFriendBlock) {
                self.clickMoreFriendBlock(YES);
            }
        }else{
            NoticeUserInfoModel *user = self.personArr[indexPath.row];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:user.user_id forKey:@"toUserId"];
            [parm setObject:self.drawM.drawId forKey:@"artworkId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkGifts" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                
                if (success) {
                    [YZC_AlertView showTopWithText:[NSString stringWithFormat:@"%@{%@}",user.nick_name,[NoticeTools getLocalStrWith:@"group.hassenddraw"]]];
                    [self cancelClick];
                }
                [nav.topViewController hideHUD];
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.personTableView) {
        return self.personArr.count;
    }
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.personTableView) {
        NoticeSharePersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        personCell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        personCell.friendM = self.personArr[indexPath.row];
        return personCell;
    }
    NoticeShanreGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    transform = CATransform3DTranslate(transform, -200, 0, 0);//左边水平移动
    // transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    
    [UIView animateWithDuration:0.6 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}


- (void)showShareView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+10, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)choiceVoiceTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    [self removeFromSuperview];
    if (self.clickvoiceBtnBlock) {
        self.clickvoiceBtnBlock(tapV.tag);
    }
    
}
@end
