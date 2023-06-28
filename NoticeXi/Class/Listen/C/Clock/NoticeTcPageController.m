//
//  NoticeTcPageController.m
//  NoticeXi
//
//  Created by li lei on 2019/11/8.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeTcPageController.h"
#import "NoticeWhitePyCell.h"
#import "NoticeWhiteTcCell.h"
#import "DDHAttributedMode.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticePyComController.h"
#import "NoticeUserDubbingAndLineController.h"
#import "NoticeShareTostView.h"
#import "NoticeBingGanListView.h"
@interface NoticeTcPageController ()<NoticewhiteClockClickDelegate,NoticeRecordDelegate,NoticeWhiteTcCellDelegate>

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) NSMutableArray *cheaArr;
@property (nonatomic, strong) UIView *shadowV;
@property (nonatomic, strong) UIView *coverV;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *pyButton;
@property (nonatomic, assign) NSInteger selfIndex;
@property (nonatomic, strong) NoticeUserInfoModel *byUserInfo;

@property (nonatomic, strong) UIImageView *scImageV;
@property (nonatomic, strong) UILabel *scL;
@end

@implementation NoticeTcPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"py.tcdetail"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataArr = [NSMutableArray new];
    if (self.mangagerCode.integerValue) {
        [self.tableView registerClass:[NoticeWhiteTcCell class] forCellReuseIdentifier:@"pyCell"];
        self.navBarView.titleL.text = @"被举报的台词";
        [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.tcDic]];
    }else{
        [self.tableView registerClass:[NoticeWhitePyCell class] forCellReuseIdentifier:@"pyCell"];
        if (self.tcId) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"lines/%@",self.tcId] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    self.tcModel = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
                    if (!self.tcModel) {
                        [UIView animateWithDuration:2 animations:^{
                            [self showToastWithText:[NoticeTools getLocalStrWith:@"py.hasdeltc"]];
                        } completion:^(BOOL finished) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                    [self refreshUI];
                }else{
                    [UIView animateWithDuration:2 animations:^{
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"py.hasdeltc"]];
                    } completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }else{
            [self refreshUI];
        }
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    }
}

- (void)refreshUI{
    
    CGFloat strHeight = [NoticeTools getSpaceLabelHeight:self.tcModel.line_content withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-80];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-20, strHeight+120+54)];
    backView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    [self.view addSubview:backView];
    self.backV = backView;
    self.tableView.tableHeaderView = self.backV;
    
    UIView *contentBackV = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, strHeight+30+54)];
    contentBackV.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    contentBackV.layer.cornerRadius = 8;
    contentBackV.layer.masksToBounds = YES;
    [self.backV addSubview:contentBackV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, contentBackV.frame.size.width-40, strHeight)];
    label.numberOfLines = 0;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.attributedText = [NoticeTools setLabelSpacewithValue:self.tcModel.line_content withFont:FOURTHTEENTEXTFONTSIZE];
    [contentBackV addSubview:label];
    self.contentL = label;
    
    self.scImageV = [[UIImageView alloc] initWithFrame:CGRectMake(contentBackV.frame.size.width-42-24,contentBackV.frame.size.height-54+ 15, 24, 24)];
    self.scImageV.image = UIImageNamed(@"Image_pyshoucangw");
    [contentBackV addSubview:self.scImageV];
    
    if(self.tcModel.lineM){
        self.scImageV.image = self.tcModel.lineM.collection_id.intValue?UIImageNamed(@"Image_pyshoucangy"):UIImageNamed(@"Image_pyshoucangw");
    }else{
        self.scImageV.image = self.tcModel.collection_id.intValue?UIImageNamed(@"Image_pyshoucangy"):UIImageNamed(@"Image_pyshoucangw");
    }

    self.scL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scImageV.frame)+3, contentBackV.frame.size.height-54, 15+24, 54)];
    self.scL.font = TWOTEXTFONTSIZE;
    self.scL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.scL.text = [NoticeTools getLocalStrWith:@"emtion.sc"];
    [contentBackV addSubview:self.scL];
    
    UIView *scTapV = [[UIView alloc] initWithFrame:CGRectMake(self.scImageV.frame.origin.x, contentBackV.frame.size.height-54, 24+3+15+24, 54)];
    scTapV.userInteractionEnabled = YES;
    scTapV.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *scTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scLineTap)];
    [scTapV addGestureRecognizer:scTap];
    [contentBackV addSubview:scTapV];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scTapV.frame.origin.x-38-5-24-5,contentBackV.frame.size.height-54+ 15, 24, 24)];
    shareImageView.image = UIImageNamed(@"Image_pyfenxiangw");
    [contentBackV addSubview:shareImageView];
    
    UILabel *shareL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shareImageView.frame)+3, contentBackV.frame.size.height-54,43, 54)];
    shareL.font = TWOTEXTFONTSIZE;
    shareL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    shareL.text = [NoticeTools getLocalStrWith:@"py.share"];
    [contentBackV addSubview:shareL];
    
    UIView *shareTapV = [[UIView alloc] initWithFrame:CGRectMake(shareImageView.frame.origin.x, contentBackV.frame.size.height-54,48+24, 54)];
    shareTapV.userInteractionEnabled = YES;
    shareTapV.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *shareTapVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapVTap)];
    [shareTapV addGestureRecognizer:shareTapVTap];
    [contentBackV addSubview:shareTapV];

    UIButton *pyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT,DR_SCREEN_WIDTH,TAB_BAR_HEIGHT)];
    if (self.tcModel.is_dubbed.boolValue) {
        [pyBtn setTitle:[NoticeTools getLocalStrWith:@"py.movetomyline"] forState:UIControlStateNormal];
        [pyBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    }else{
        [pyBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        [pyBtn setTitle:[NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"py.py"]:@"  我来配音" forState:UIControlStateNormal];
    }
    
    pyBtn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    pyBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [pyBtn setImage:UIImageNamed(@"Image_woyelaipy") forState:UIControlStateNormal];
    [pyBtn addTarget:self action:@selector(peyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pyBtn];
    self.pyButton = pyBtn;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    UIView *rightInfoView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tcOf"], 14, 50)-6-20-20,CGRectGetMaxY(contentBackV.frame), GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tcOf"], 14, 50)+6+20, 50)];
    rightInfoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCenterTap)];
    [rightInfoView addGestureRecognizer:tap];
    UILabel *rigL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"py.tcOf"], 14, 50), 50)];
    rigL.text = [NoticeTools getLocalStrWith:@"py.tcOf"];
    rigL.font = FOURTHTEENTEXTFONTSIZE;
    rigL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [rightInfoView addSubview:rigL];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rigL.frame)+6, 15, 20, 20)];
    iconImageView.layer.cornerRadius = 21/2;
    iconImageView.layer.masksToBounds = YES;
    [rightInfoView addSubview:iconImageView];
    NoticeUserInfoModel *byUserInfo = nil;
    if (self.tcModel.lineM || self.isFromMessageVC) {//代表是配音列表点击台词进来的
        byUserInfo = self.tcModel.toUserInfo?self.tcModel.toUserInfo:[NoticeSaveModel getUserInfo];
    }else{//表示直接点击台词进来的
        byUserInfo = self.tcModel.userInfo;
    }
    self.byUserInfo = byUserInfo;
    NSString *avaterUrl = byUserInfo.avatar_url;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:avaterUrl]
                                     placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                              options:SDWebImageRefreshCached];
    [self.backV addSubview:rightInfoView];
    
    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentBackV.frame), 150, 50)];
    numL.font = EIGHTEENTEXTFONTSIZE;
    numL.textColor = [UIColor colorWithHexString:@"#25262E"];
    numL.text = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"main.py"],self.tcModel.dubbing_num];
    [self.backV addSubview:numL];
}

- (void)shareTapVTap{
    NoticeShareTostView *view = [[NoticeShareTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    view.isPyOrTc = YES;
    view.tcModel = self.tcModel;
    [view showTost];
}

//点击收藏
- (void)scLineTap{

    if ([_tcModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//自己的
    
        if (self.tcModel.collection_num.intValue > 0) {//收到贴贴就弹出贴贴列表
            NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            listView.scTCModel = self.tcModel;
            [listView showTost];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"py.nocol"]];
        }
    }else{

        [self showHUD];
        if (self.tcModel.lineM.collection_id.intValue) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"linesCollection/%@",self.tcModel.lineM.collection_id] Accept:@"application/vnd.shengxi.v5.0.0+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"py.cancelCol"]];
                    self.tcModel.lineM.collection_id = @"0";
                    self.scImageV.image = UIImageNamed(@"Image_pyshoucangw");
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            return;
        }
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.tcModel.line_id?self.tcModel.line_id : self.tcModel.tcId forKey:@"lineId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"linesCollection" Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                [self showToastWithText:[NoticeTools getLocalStrWith:@"emtion.scSus"]];
                self.tcModel.lineM.collection_id = idM.allId;
                self.scImageV.image = UIImageNamed(@"Image_pyshoucangy");
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (void)userCenterTap{
    NSString *userId = self.byUserInfo.piPeiId;
    if ([userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] || !userId) {

        NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
        ctl.isFromLine = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{

        NoticeUserDubbingAndLineController *ctl = [[NoticeUserDubbingAndLineController alloc] init];
        ctl.isFromLine = YES;
        ctl.isOther = YES;
        ctl.userId = userId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}
- (void)reRecoderLocalVoice{
    [self peyClick];
}
- (void)peyClick{
    if (self.tcModel.is_dubbed.boolValue) {
        BOOL hasPy = NO;
        for (int i = 0; i < self.dataArr.count; i++) {
            NoticeClockPyModel *model = self.dataArr[i];
            if ([model.from_user_id isEqualToString:[NoticeTools getuserId]]) {
                self.selfIndex = i;
                hasPy = YES;
                break;
            }
        }
        if (!hasPy) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"py.movetosat"]];
            return;
        }
        if ((self.dataArr.count-1) >= self.selfIndex) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selfIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        return;
    }
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWithPeiYing:_tcModel.line_content];
    recodeView.pyTag = self.tcModel.tag_id.intValue;
    recodeView.delegate = self;
    recodeView.isPy = YES;
    [recodeView show];
}



- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength isNiMing:(BOOL)isNiming{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"22" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [self showHUD];
    NSString *tcId = self.tcModel.line_id?self.tcModel.line_id : self.tcModel.tcId;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:tcId forKey:@"lineId"];
            [parm setObject:Message forKey:@"dubbingUri"];
            [parm setObject:timeLength forKey:@"dubbingLen"];
            [parm setObject:isNiming?@"1":@"0" forKey:@"isAnonymous"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbings" Accept:@"application/vnd.shengxi.v4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.tcModel.is_dubbed = @"1";
                    [self refresh];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECTARTPY" object:nil];
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
        }
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEROOTSELECTARTPY" object:nil];
}

- (void)refresh{
    self.isDown = YES;
    [self request];
}

- (void)request{
    NSString *url = @"";
    NSString *tcId = self.tcModel.line_id?self.tcModel.line_id : self.tcModel.tcId;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"lines/%@/dubbings?pageNo=1",tcId];
    }else{
        url = [NSString stringWithFormat:@"lines/%@/dubbings?pageNo=%ld",tcId,self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                if (self.dataArr.count) {
                    self.isReplay = YES;
                    [self.audioPlayer pause:YES];
                    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                }
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                if (model.tag_id.intValue == 2) {
                    model.line_content = [NSString stringWithFormat:@"#求freestyle#%@",model.line_content];
                }else{
                    model.line_content = [NSString stringWithFormat:@"#求配音#%@",model.line_content];
                }
                if (!self.tcModel.line_content) {
                    self.tcModel = model;
                    CGFloat strHeight = GET_STRHEIGHT(self.tcModel.line_content, 12,DR_SCREEN_WIDTH-86);
                    self.shadowV.frame = CGRectMake(0,10+strHeight+30+10, DR_SCREEN_WIDTH, 5);
                    self.coverV.frame = CGRectMake(0,10+strHeight+30, DR_SCREEN_WIDTH, 15);
                    self.backV.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-20, strHeight+30);
                    self.contentL.frame = CGRectMake(33, 15, self.backV.frame.size.width-66, strHeight);
                    self.contentL.text = self.tcModel.line_content;
                    self.tableView.frame = CGRectMake(0,CGRectGetMaxY(self.backV.frame)+10, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-self.backV.frame.size.height-20-57);
                }
                if ([model.from_user_id isEqualToString:[NoticeTools getuserId]]) {
                    self.tcModel.is_dubbed = @"1";
                }
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            if (self.dataArr.count) {
                if (self.tcModel.is_dubbed.boolValue) {
                    [self.pyButton setTitle:[NoticeTools getLocalStrWith:@"py.movetomyline"] forState:UIControlStateNormal];
                    [self.pyButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
                }else{
                    [self.pyButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
                    [self.pyButton setTitle:[NoticeTools getLocalStrWith:@"py.mecomepy"] forState:UIControlStateNormal];
                }
                if (self.hasSelfPy) {
                    self.hasSelfPy = NO;
                    BOOL hasPy = NO;
                    for (int i = 0; i < self.dataArr.count; i++) {
                        NoticeClockPyModel *model = self.dataArr[i];
                        if ([model.from_user_id isEqualToString:[NoticeTools getuserId]]) {
                            self.selfIndex = i;
                            hasPy = YES;
                            break;
                        }
                    }
                    if (hasPy) {
                        if ((self.dataArr.count-1) >= self.selfIndex) {
                            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selfIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        }
                    }
                }
            }else{
                [self.pyButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
                self.tcModel.is_dubbed = @"0";
                [self.pyButton setTitle:[NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"py.py"]:@"  我来配音" forState:UIControlStateNormal];
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    __weak NoticeTcPageController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.pageNo = 1;
        ctl.isDown = YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeClockPyModel *pyM = self.dataArr[indexPath.row];
    NoticePyComController *ctl = [[NoticePyComController alloc] init];
    ctl.noBecomFirst = YES;
    ctl.pyMOdel = pyM;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mangagerCode.integerValue) {
       return  120+[self.dataArr[indexPath.row] contentHeight]+21+15;
    }
    return 160+15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.mangagerCode.integerValue) {
        NoticeWhiteTcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
        cell.managerCode = self.mangagerCode;
        cell.index = indexPath.row;
        cell.tcModel = self.dataArr[indexPath.row];
        cell.delegate = self;
        return cell;
        
    }else{
        NoticeWhitePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
        cell.isTcPage = YES;
        cell.index = indexPath.row;
        cell.playerView.tag = indexPath.row;

        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        cell.delegate = self;
        cell.pyModel = self.dataArr[indexPath.row];
        return cell;
    }
}

//管理员处理台词
- (void)editManagerWithDelete{
    [self showHUD];
    NoticeClockPyModel *model = self.dataArr[0];
    if ([model.line_status isEqualToString:@"1"]) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/lines/%@",model.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                model.line_status = @"0";
                self.tcDic = model.mj_keyValues;
                [self.dataArr removeAllObjects];
                [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.tcDic]];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManager" object:self userInfo:self.tcDic];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }else{
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setObject:@"1" forKey:@"lineStatus"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/lines/%@",model.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
             [self hideHUD];
            if (success) {
                model.line_status = @"1";
                self.tcDic = model.mj_keyValues;
                [self.dataArr removeAllObjects];
                [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.tcDic]];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManager" object:self userInfo:self.tcDic];
            }
        } fail:^(NSError * _Nullable error) {
             [self hideHUD];
        }];
    }
}

- (void)editManagerWithHide{
    NoticeClockPyModel *model = self.dataArr[0];
    if (model.hide_at.intValue) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setValue:@"0" forKey:@"hideAt"];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/lines/%@",model.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                model.hide_at = @"0";
                self.tcDic = model.mj_keyValues;
                [self.dataArr removeAllObjects];
                [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.tcDic]];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManager" object:self userInfo:self.tcDic];
            }
        } fail:^(NSError * _Nullable error) {
            
        }];

    }else{
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setValue:[NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]] forKey:@"hideAt"];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/lines/%@",model.tcId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                model.hide_at = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
                self.tcDic = model.mj_keyValues;
                [self.dataArr removeAllObjects];
                [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.tcDic]];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManager" object:self userInfo:self.tcDic];
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:NO];
    [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            weakSelf.progross = 0;
        }
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    self.draFlot = dratNum;
}

#pragma Mark - 音频播放模块
- (void)startRePlayer:(NSInteger)tag{//重新播放
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer stopPlaying];
    self.isReplay = YES;
    [appdel.floatView.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}


- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
   
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.dataArr.count && (self.floatView.currentTag <= self.dataArr.count-1) && appdel.floatView.currentTag == self.oldSelectIndex) {
        NoticeClockPyModel *model = self.dataArr[self.floatView.currentTag];
        if (playing) {
            self.isPasue = !pause;
            model.isPlaying = !pause;
            [self.tableView reloadData];
        }
    }
}
//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
        NoticeClockPyModel *oldM = self.oldModel;
        oldM.nowTime = oldM.dubbing_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeClockPyModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.pyArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentPyModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
      
    }else{
        [appdel.floatView playClick];
    }
    
    __weak typeof(self) weakSelf = self;
    appdel.floatView.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            if (self.canReoadData) {
                model.isPlaying = YES;
                [weakSelf.tableView reloadData];
            }
        }
    };
    
    appdel.floatView.playComplete = ^{
        weakSelf.canReoadData = NO;
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.dubbing_len;
        [weakSelf.tableView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        NoticeWhitePyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if (weakSelf.canReoadData) {
            cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
            cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.dubbing_len.floatValue;
            model.nowTime = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
            model.nowPro = currentTime/model.dubbing_len.floatValue;
        }else{
            cell.playerView.timeLen = model.dubbing_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.dubbing_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    };
}

- (void)delegateSuccess:(NSInteger)index{
    if (self.dataArr.count >= index+1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEROOTSELECTARTPY" object:nil];
        [self.dataArr removeObjectAtIndex:index];
        [self.tableView reloadData];
        if (![NoticeTools isManager]) {
            self.tcModel.is_dubbed = @"0";
            [self.pyButton setTitle:[NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"py.py"]:@"  我來配音" forState:UIControlStateNormal];
            [self.pyButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        }
    }
}
@end
