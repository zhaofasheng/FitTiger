//
//  NoticeZJDetailController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZJDetailController.h"
#import "NoticeNewSelfVoiceCell.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeAddVoiceToZjController.h"
#import "NoticeChoiceVoiceTimeController.h"
#import "NoticeAddZjController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
@interface NoticeZJDetailController ()<NoticeNewSelfVoiceListClickDelegate,LCActionSheetDelegate,TZImagePickerControllerDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) UIImageView *zJimageView;
@property (nonatomic, strong) UIImageView *zJLockView;
@property (nonatomic, strong) UILabel *zjNameL;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeZJDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
    
    if (!self.isOther) {
        [self.navBarView.rightButton addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView.rightButton setImage:UIImageNamed(@"morebuttonimg") forState:UIControlStateNormal];
    }

    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    [self.tableView registerClass:[NoticeNewSelfVoiceCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    
    self.tableView.tableHeaderView = self.sectionView;
    [self.tableView.mj_header beginRefreshing];
    
    self.needBackGroundView = YES;
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;

    
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];

    [iamgeView sd_setImageWithURL:[NSURL URLWithString:self.zjModel.album_cover_url] placeholderImage:UIImageNamed(@"Image_addzjdefault")];
    iamgeView.contentMode = UIViewContentModeScaleAspectFill;
    iamgeView.clipsToBounds = YES;

    UIView *fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    fgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [iamgeView addSubview:fgView];
    self.zJimageView = iamgeView;
    [self.view addSubview:iamgeView];
    
    [self.view sendSubviewToBack:self.zJimageView];
    
    
}


- (void)selfChatNumView{
    NewReplyVoiceView *replyView = [[NewReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    replyView.voiceM = self.hsVoiceM;
    [replyView show];
}


- (void)clickHS:(NoticeVoiceListModel *)hsVoiceModel{
    self.hsVoiceM = hsVoiceModel;
    
    [self reSetPlayerData];
    if ([self.hsVoiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]){//自己的
        if (self.hsVoiceM.chat_num.intValue) {
            [self selfChatNumView];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"movie.nohs"]];
        }
        return;
    }

    NoticeNewChatVoiceView *chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.hsVoiceM;
    chatView.userId = self.hsVoiceM.subUserModel.userId;
    chatView.chatId = self.hsVoiceM.chat_id;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId];
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf hs];
    };
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,weakSelf.hsVoiceM.subUserModel.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:weakSelf.hsVoiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.hsVoiceM.voice_id}];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
        [weakSelf.tableView reloadData];
    };
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    [chatView show];
}

- (void)reRecoderLocalVoice{
    [self hs];
}

- (void)hs{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
    recodeView.isHS = YES;
    recodeView.needLongTap = YES;
    recodeView.hideCancel = NO;
    recodeView.delegate = self;
    recodeView.isReply = YES;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.hsVoiceM.subUserModel.nick_name];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    //__weak typeof(self) weakSelf = self;
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }else{
           // [self->_topController hideHUD];
           // [self->_topController showToastWithText:errorMessage];
        }
    }];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [weakSelf hideHUD];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }else{
            [weakSelf showToastWithText:Message];
            [weakSelf hideHUD];
        }
    }];
}

- (void)getAddChat:(NSNotification*)notification{
    
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue+1];
                        [self.tableView reloadData];
                        DRLog(@"执行一次");
                        break;
                    }
                }
            }
        }
    }
}

- (void)getDeleteChat:(NSNotification*)notification{
    
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue-1];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)createRefesh{
    
    __weak NoticeZJDetailController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
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
        url= [NSString stringWithFormat:@"user/%@/voiceAlbum/%@/voice",self.userId,self.zjModel.albumId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum/%@/voice?lastId=%@",self.userId,self.zjModel.albumId,self.lastId];
        }else{
            url= [NSString stringWithFormat:@"user/%@/voiceAlbum/%@/voice",self.userId,self.zjModel.albumId];
        }
    }

    NSMutableArray *arr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
                self.isPushMoreToPlayer = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
     
                BOOL alerady = NO;
                for (NoticeVoiceListModel *olM in self.dataArr) {
                    if ([olM.voice_id isEqualToString:model.voice_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [arr addObject:model];
                    [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                if (self.isLimit) {
                    self.lastId = lastM.dialog_id;
                }else{
                    self.lastId = lastM.voice_id;
                }
            }
            if ([NoticeTools isFirstdeleteZJOnThisDeveice] && self.dataArr.count && !self.isOther) {
                self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+147);
                [self.titleHeadView removeFromSuperview];
                [self.sectionView addSubview:self.titleHeadView];
            }
            if (!self.dataArr.count) {
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    model.album_id = @"5678";
    if (model.resource) {
        if (model.content_type.intValue == 2) {
            NoticeMbsDetailTextController *ctl = [[NoticeMbsDetailTextController alloc] init];
            ctl.voiceM = model;
            
            ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
                model.dialog_num = dilaNum;
            };
            [self.navigationController pushViewController:ctl animated:NO];
        }else{
            NoticeMBSDetailVoiceController *ctl = [[NoticeMBSDetailVoiceController alloc] init];
            ctl.voiceM = model;

            ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
                model.dialog_num = dilaNum;
            };
            [self.navigationController pushViewController:ctl animated:NO];
        }
        return;
    }
    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = model;

        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.is_private.boolValue && !model.statusM  && !model.topicName) {
        return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]]-54+10;
    }
    return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewSelfVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noShowTop = YES;
    cell.needlongTap = self.isOther?NO: YES;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    cell.deleteVoiceFromZj = ^(NoticeVoiceListModel * _Nonnull voiceM) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"zj.suremove"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                //在这里添加点击事件
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"user/%@/albumVoice/%@/%@",weakSelf.userId,weakSelf.zjModel.albumId,voiceM.voice_id] Accept:@"application/vnd.shengxi.v3.8+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.hasmove"]];
                        for (NoticeVoiceListModel *oldM in weakSelf.dataArr) {
                            if ([oldM.voice_id isEqualToString:voiceM.voice_id]) {
                                if (oldM.isPlaying) {
                                    [weakSelf.audioPlayer stopPlaying];
                                    weakSelf.isReplay = YES;
                                }
                                [weakSelf.dataArr removeObject:oldM];
                                break;
                            }
                        }
                        if(weakSelf.zjModel.voice_num.intValue >= 1){
                            weakSelf.zjModel.voice_num = [NSString stringWithFormat:@"%d",weakSelf.zjModel.voice_num.intValue-1];
                        }
                        
                        weakSelf.numL.text= [NSString stringWithFormat:@"%@%@",weakSelf.zjModel.voice_num,[NoticeTools getLocalStrWith:@"zj.num"]];
                        [weakSelf.tableView reloadData];
                    }
                    [weakSelf hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    };
    return cell;
}

#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{
  [self.tableView reloadData];
}

- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
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
        NoticeVoiceListModel *model = self.dataArr[self.floatView.currentTag];
        if (model.content_type.intValue != 1) {
            return;
        }
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
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.voiceArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
        [self addPlayNum:model];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPCUTUSMEMUSICPALY" object:nil];
    };
    
    appdel.floatView.playComplete = ^{
        weakSelf.canReoadData = NO;
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.voice_len;
        [weakSelf.tableView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        NoticeNewSelfVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if (weakSelf.canReoadData) {
            cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
            model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            model.nowPro = currentTime/model.voice_len.floatValue;
        }else{
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    };
}
//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    if (tag > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    [self.clickMore voiceClickMoreWith:model];
}

- (UIView *)sectionView{
    if (!_sectionView) {
  
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+91)];
        _sectionView.userInteractionEnabled = YES;
        _sectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 22+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20-30, 30)];
        self.zjNameL = label;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = XGTwentyTwoBoldFontSize;
        [_sectionView addSubview:label];
        
        self.zjNameL.text = self.zjModel.album_name;
        
        if (self.zjModel.album_type.intValue != 1) {
          
            CGFloat width = GET_STRWIDTH(self.zjNameL.text, 23, 30);
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20+width,27+NAVIGATION_BAR_HEIGHT, 20, 20)];
            imageV.image = UIImageNamed(@"Image_zjsuo");
            [_sectionView addSubview:imageV];
            self.zJLockView = imageV;
        }
        
        UILabel *numlabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(label.frame)+4, DR_SCREEN_WIDTH-20, 20)];
        numlabel.text = [NSString stringWithFormat:@"%@%@",self.zjModel.voice_num,[NoticeTools getLocalStrWith:@"zj.num"]];
        numlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        numlabel.font = FOURTHTEENTEXTFONTSIZE;
        [_sectionView addSubview:numlabel];
        self.numL = numlabel;
    }
    return _sectionView;
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+91, DR_SCREEN_WIDTH-40, 41)];
        _titleHeadView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-50, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"zj.mark"];
        label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        label.numberOfLines = 0;

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 40)];
        [button setImage:UIImageNamed(appdel.backImg?@"Image_sendXXtm": @"Image_sendXX") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
    }
    return _titleHeadView;
}

- (void)clickXX{
    [NoticeTools setMarkFordeleteZJ];

    [self.titleHeadView removeFromSuperview];
    self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+91);
    [self.tableView reloadData];
}

- (NoticeNoDataView *)footView{
    if (!_footView) {
        _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.sectionView.frame.size.height)];

        _footView.titleL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
        _footView.titleL.frame = CGRectMake(0, (_footView.frame.size.height-20)/2-56, DR_SCREEN_WIDTH, 20);
        _footView.titleL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        if (self.isOther) {
            _footView.actionButton.hidden = YES;
        }
        _footView.actionButton.frame = CGRectMake((DR_SCREEN_WIDTH-240)/2,CGRectGetMaxY(_footView.titleL.frame)+20, 240, 56);
        _footView.actionButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [_footView.actionButton setTitle:[NoticeTools getLocalStrWith:@"yl.addmoods"] forState:UIControlStateNormal];
        [_footView.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _footView.actionButton.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [_footView.actionButton addTarget:self action:@selector(addVoiceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

- (void)addVoiceClick{
    NoticeAddVoiceToZjController *ctl = [[NoticeAddVoiceToZjController alloc] init];
    ctl.zjmodelId = self.zjModel.albumId;
    __weak typeof(self) weakSelf = self;
    ctl.joinSuccessBlock = ^(BOOL join) {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)moreBtnClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"zj.editzj"],[NoticeTools getLocalStrWith:@"yl.addmoods"],[NoticeTools getLocalStrWith:@"zj.changeback"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
  
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NoticeAddZjController *ctl = [[NoticeAddZjController alloc] init];
        ctl.isEditAblum = YES;
        ctl.zjmodel = self.zjModel;
        __weak typeof(self) weakSelf = self;
        ctl.editSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            weakSelf.zjModel = zjmodel;
            weakSelf.sectionView = nil;
            [weakSelf.sectionView removeFromSuperview];
            weakSelf.tableView.tableHeaderView = weakSelf.sectionView;
            if (weakSelf.editSuccessBlock) {
                weakSelf.editSuccessBlock(weakSelf.zjModel);
                
            }
            if (zjmodel.image) {
                weakSelf.zJimageView.image = zjmodel.image;
            }
        };
        ctl.deleteSuccessBlock = ^(NoticeZjModel * _Nonnull zjmodel) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.deleteSuccessBlock) {
                weakSelf.deleteSuccessBlock(zjmodel.albumId);
            }
            
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (buttonIndex == 4){
        //在这里添加点击事件
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"zj.delthiszj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"user/%@/voiceAlbum/%@",self.userId,self.zjModel.albumId] Accept:@"application/vnd.shengxi.v3.8+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                 
                        if (weakSelf.deleteSuccessBlock) {
                            weakSelf.deleteSuccessBlock(weakSelf.zjModel.albumId);
                        }
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    [weakSelf hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    }else if (buttonIndex == 2){
        [self addVoiceClick];
    }else if (buttonIndex == 3){
        [self changeBackview];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//开启右滑返回
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView reloadData];
}

- (void)changeBackview{

    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePicker.sortAscendingByModificationDate = false;
            imagePicker.allowPickingOriginalPhoto = false;
            imagePicker.alwaysEnableDoneBtn = true;
            imagePicker.allowPickingVideo = false;
            imagePicker.allowPickingGif = false;
            imagePicker.allowCrop = true;
            imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)/2,DR_SCREEN_WIDTH,DR_SCREEN_WIDTH);
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"zj.changeback"]]];
    [sheet show];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%u",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99098999];
            [self upLoadHeader:choiceImage path:filePath];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }

    [self.tableView reloadData];
    NSString *iamgeP = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"18" forKey:@"resourceType"];
    [parm1 setObject:iamgeP forKey:@"resourceContent"];
    [self showHUD];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"albumCoverUri"];
            NSString *url = nil;
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum/%@",[[NoticeSaveModel getUserInfo] user_id],self.zjModel.albumId];
            [parm setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:@"application/vnd.shengxi.v3.8+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.zJimageView.image = image;
    
                    if (self.editSuccessBlock) {
                        self.editSuccessBlock(self.zjModel);
                        
                    }
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
            [self showToastWithText:Message];
        }
    }];
}
@end
