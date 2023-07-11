//
//  NoticeHelpDetailController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpDetailController.h"
#import "NoticeHelpHeaderView.h"
#import "NoticeXi-Swift.h"
#import "NoticeHelpCommentCell.h"
#import "SPMultipleSwitch.h"

@interface NoticeHelpDetailController ()<NoticeBBSComentInputDelegate,LCActionSheetDelegate,NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeHelpHeaderView *headerView;
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NoticeHelpCommentModel *choiceModel;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, assign) BOOL isJustSayCom;
@property (nonatomic, strong) UIView *buttonFootView;
@end

@implementation NoticeHelpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    
    [self.navBarView.rightButton setImage:UIImageNamed(@"helpdetailImg") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];

    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-50-10);

    self.headerView = [[NoticeHelpHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
    self.headerView.helpModel = self.helpModel;
    self.tableView.tableHeaderView = self.headerView;
    

    [self.tableView registerClass:[NoticeHelpCommentCell class] forCellReuseIdentifier:@"cell"];
    
    self.inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.inputView.delegate = self;
    self.inputView.limitNum = 1000;
    self.inputView.isHelp = YES;
    self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.inputView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.inputView.plaStr = [NoticeTools getLocalType] >0 ? @"Share your idea" : @"说说你的想法…";
    self.inputView.saveKey = [NSString stringWithFormat:@"helpcom%@%@",[NoticeTools getuserId],self.helpModel.tieId];
    self.isHot = YES;
    self.dataArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    self.inputView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot, NSString * _Nonnull commentId) {
        [weakSelf sendEmtion:buckId content:url commentId:commentId type:@"3"];
    };
    self.inputView.imgBlock = ^(NSMutableArray * _Nonnull imagArr, NSString * _Nonnull commentId) {
    
        [weakSelf sendImageFor:imagArr[0] commentId:commentId];
    };//
    self.isDown = YES;
    self.pageNo = 1;
    if (self.comModel && !self.isJubaoCom) {
        self.comModel.tieUserId = self.helpModel.userM.userId;
        self.isJustSayCom = YES;
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = self.buttonFootView;
        [self.dataArr addObject:self.comModel];
        [self.tableView reloadData];
        //self.inputView.isHelpCom = YES;
        self.inputView.hidden = YES;
        if (self.isFromPush) {
            [self requestHelpDetail:self.comModel.invitation_id];
        }
        if (self.needDetail) {
            [self detailClick];
        }
    }else{
        if(self.isJubaoCom){
            self.comModel.tieUserId = self.helpModel.userM.userId;
            self.comModel.isJubaoCom = YES;
            [self.dataArr addObject:self.comModel];
            [self.tableView reloadData];
            self.inputView.hidden = YES;
        }else{
            [self createRefesh];
            [self request];
        }
    }
}

- (void)requestHelpDetail:(NSString *)invitationId{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/%@",invitationId];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            if (model) {
                self.helpModel = model;
                self.comModel.tieUserId = self.helpModel.userM.userId;
                self.headerView.helpModel = self.helpModel;
                [self.tableView reloadData];
            }else{
                [self showToastWithText:@"帖子已不存在"];
            }
        }else{
            [self showToastWithText:@"帖子已不存在"];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


- (void)detailClick{
    [self createRefesh];
    self.isJustSayCom = NO;
    self.inputView.hidden = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = nil;
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)sendImageFor:(PHAsset *)assest commentId:(NSString *)commentId{
    if (!assest) {
        return;
    }
    PHAsset *asset = assest;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [self showToastWithText:@"获取文件失败"];
                return ;
            }
            [self upLoadHeader:imageData path:nil commentId:commentId];

        }];
    }else{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [self upLoadHeader:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6) path:nil commentId:commentId];
            ;
        }];
    }
}

- (UIView *)buttonFootView{
    if (!_buttonFootView) {
        _buttonFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 200, 50)];
        [button setTitle:[NoticeTools chinese:@"查看求助帖详情>" english:@"Read More >" japan:@"ポストを見る>"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        button.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        [_buttonFootView addSubview:button];
    }
    return _buttonFootView;
}


- (void)upLoadHeader:(NSData *)image path:(NSString *)path commentId:(NSString *)commentId{
    if (!path) {

        path = [NSString stringWithFormat:@"%@_%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
    }
    
    [self showHUD];

    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"72" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            [self hideHUD];
            [self sendEmtion:bucketId content:errorMessage commentId:commentId type:@"2"];
        }else{
            [self hideHUD];
        }
    }];
}


- (void)sendEmtion:(NSString *)bucketid content:(NSString *)content commentId:(NSString *)commentId type:(NSString *)type{
    if (!bucketid) {
        bucketid = @"0";
    }
    if (!content) {
        return;
    }
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/comment/%@/%@",self.helpModel.tieId,commentId?commentId:@"0"];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:content forKey:@"content"];
    [parm setObject:bucketid forKey:@"bucketId"];
    [parm setObject:type forKey:@"contentType"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
       
            NoticeHelpCommentModel *comM = [NoticeHelpCommentModel mj_objectWithKeyValues:dict[@"data"]];
            comM.tieUserId = self.helpModel.userM.userId;
            if (!commentId) {
                [self.dataArr insertObject:comM atIndex:0];
            }else{
                if (!self.choiceModel.replyArr) {
                    self.choiceModel.replyArr = [[NSMutableArray alloc] init];
                }
                [self.choiceModel.replyArr addObject:comM];
            }
            [self.tableView reloadData];
            if ([NoticeTools getLocalType]==0) {
                [self showToastWithText:commentId? @"回复成功":@"评论成功"];
            }
            self.tableView.tableFooterView = nil;
            if (!commentId) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    if (!comment.length) {
        return;
    }
    [self sendEmtion:@"0" content:comment commentId:commentId type:@"1"];
    [self.inputView.contentView resignFirstResponder];
}


- (void)moreClick{
    
    NSArray *arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"]];
    if ([NoticeTools isManager]) {
        arr = @[self.helpModel.isHot?@"取消热门": @"设为热帖",@"删除帖子"];
    }
    else if ([self.helpModel.userM.userId isEqualToString:[NoticeTools getuserId]]) {
        arr = @[[NoticeTools getLocalStrWith:@"help.sctie"]];
    }else{
        arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"],self.helpModel.is_dislike.boolValue?[NoticeTools chinese:@"恢复帖子" english:@"Like again" japan:@"解除"]: [NoticeTools chinese:@"不喜欢此帖子" english:@"Unlike" japan:@"非表示"]];
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:arr];
    sheet.delegate = self;
    [sheet show];
    
}

- (void)deleteTie{
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"invitation/%@",self.helpModel.tieId] Accept:@"application/vnd.shengxi.v5.4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (self.deleteSuccess) {
                self.deleteSuccess(self.helpModel.tieId);
            }
            if ([NoticeTools getLocalType] == 0) {
                [YZC_AlertView showViewWithTitleMessage:@"已删除"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([NoticeTools isManager]) {
            self.magager.type = @"设为热帖";
            [self.magager show];
            return;
        }
        
        if ([self.helpModel.userM.userId isEqualToString:[NoticeTools getuserId]]) {
            __weak typeof(self) weakSelf = self;
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"help.suredelete"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakSelf deleteTie];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
            [sheet show];

        }else{
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.helpModel.tieId;
            juBaoView.reouceType = @"141";
            [juBaoView showView];
        }
    }else if (buttonIndex == 2){
        if ([NoticeTools isManager]) {
            self.magager.type = @"删除帖子";
            [self.magager show];
            return;
        }if (![self.helpModel.userM.userId isEqualToString:[NoticeTools getuserId]]) {
            if(self.noLikeBlock){
                self.noLikeBlock(self.helpModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)sureManagerClick:(NSString *)code{
    if ([self.magager.type isEqualToString:@"设为热帖"]) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:code forKey:@"confirmPasswd"];
        [parm setObject:self.helpModel.isHot?@"0":@"1" forKey:@"isHot"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/invitation/%@",self.helpModel.tieId] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.helpModel.isHot = self.helpModel.isHot?NO:YES;
                [self showToastWithText:self.helpModel.isHot?@"已设置为热门":@"已取消热门"];
                [self.magager removeFromSuperview];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else if ([self.magager.type isEqualToString:@"删除帖子"]){
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:code forKey:@"confirmPasswd"];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/invitation/%@",self.helpModel.tieId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.deleteSuccess) {
                    self.deleteSuccess(self.helpModel.tieId);
                }
                [self.magager removeFromSuperview];
                [YZC_AlertView showViewWithTitleMessage:@"已删除"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (void)request{
    
    if (self.isDown) {
        [self requestDetail];
    }
    
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/comment/%@?pageNo=%ld&sortType=%@",self.helpModel.tieId,self.pageNo,self.isHot?@"1":@"2"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeHelpCommentModel *model = [NoticeHelpCommentModel mj_objectWithKeyValues:dic];
                model.tieUserId = self.helpModel.userM.userId;
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)requestDetail{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"invitation/%@",self.helpModel.tieId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dict[@"data"]];
            self.helpModel.reply_num = model.reply_num;
            self.numL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalType]==1?@"Posted":[NoticeTools getLocalStrWith:@"cao.liiuyan"],self.helpModel.reply_num.intValue?self.helpModel.reply_num:@""];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, 15, 335, 70)];
        imageView.image = UIImageNamed(@"helpfootimg");
        [_footView addSubview:imageView];
    }
    return _footView;
}

- (void)createRefesh{
 
    __weak NoticeHelpDetailController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
        [ctl request];
    }];
    
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpCommentModel *model = self.dataArr[indexPath.row];
    if (!model.replyArr.count) {
        return 55 + (model.content_type.intValue>1?100: model.textHeight);
    }else{
        NoticeHelpCommentModel *subModel = model.replyArr[0];
        return 55+ (model.content_type.intValue>1?100: model.textHeight) + 10 + (subModel.subContentType.intValue>1?100: subModel.subTextHeight) + 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.replyBlock = ^(NoticeHelpCommentModel * _Nonnull model) {
        weakSelf.choiceModel = model;
        weakSelf.inputView.replyToView.replyLabel.text = [NSString stringWithFormat:@"%@:%@",[NoticeTools getLocalStrWith:@"help.reply"],model.content_type.intValue>1? [NoticeTools getLocalStrWith:@"group.imgs"]: model.content];
        weakSelf.inputView.commentId = model.commentId;
        weakSelf.inputView.hidden = NO;
        
        [weakSelf.inputView.contentView becomeFirstResponder];
    };
    cell.deleteSuccess = ^(NSString * _Nonnull tieId) {
        for (NoticeHelpCommentModel *comM in weakSelf.dataArr) {
            if ([comM.commentId isEqualToString:tieId]) {
                [weakSelf.dataArr removeObject:comM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    cell.deletesubSuccess = ^(NSString * _Nonnull tieId) {
        for (NoticeHelpCommentModel *comM in weakSelf.dataArr) {
            if ([comM.commentId isEqualToString:tieId]) {
                comM.replys = nil;
                [comM.replyArr removeAllObjects];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputView showJustComment:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inputView.contentView resignFirstResponder];
    [self.inputView clearView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > NAVIGATION_BAR_HEIGHT) {
        self.navBarView.titleL.text = self.helpModel.title;
    }else{
        self.navBarView.titleL.text = @"";
    }
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
        _sectionView.backgroundColor = self.view.backgroundColor;
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 200, 45)];
        self.numL.font = XGSIXBoldFontSize;
        self.numL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalType]==1?@"Posted":[NoticeTools getLocalStrWith:@"cao.liiuyan"],self.helpModel.reply_num.intValue?self.helpModel.reply_num:@""];
        self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_sectionView addSubview:self.numL];
        
        SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalType]==1?@"Like":@"点赞",[NoticeTools getLocalStrWith:@"mineme.sj"]]];
        switch1.titleFont = TWOTEXTFONTSIZE;
        switch1.frame = CGRectMake(DR_SCREEN_WIDTH-20-64*2,10,64*2,24);
        [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
        switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
        switch1.titleColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
        switch1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
        [_sectionView addSubview:switch1];
    }
    return _sectionView;
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    if(self.isJubaoCom){
        return;
    }
    if (swithbtn.selectedSegmentIndex == 1) {
        self.isHot = NO;
    }else{
        self.isHot = YES;
    }
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

@end
