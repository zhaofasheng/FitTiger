//
//  NoticeCaogaoVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/16.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeCaogaoVoiceController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeSendViewController.h"
#import "NoticeSaveVoiceCell.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticreSendHelpController.h"
@interface NoticeCaogaoVoiceController ()<UITableViewDelegate,UITableViewDataSource,NoticeNewSaveVoiceListDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat draFlot;
@property (nonatomic, assign) CGFloat progross;
@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoticeVoiceSaveModel *oldModel;
@property (nonatomic, strong) NSMutableArray *sourceArr;
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, strong) UILabel *footLabel;
@end

@implementation NoticeCaogaoVoiceController
- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView = [[UITableView alloc] init];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0,0,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeSaveVoiceCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.tableView];


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceSaveModel *model = self.dataArr[indexPath.row];
    CGFloat imagHeight = 0;
    if (model.img1Path && model.img2Path && model.img3Path) {
        imagHeight = (DR_SCREEN_WIDTH-60-18)/3;
    }else if (model.img1Path && model.img2Path && !model.img3Path){
        imagHeight = (DR_SCREEN_WIDTH-68)/2;
    }else if (model.img1Path && !model.img2Path && !model.img3Path){
        imagHeight = 200;
    }

    if (model.contentType.intValue != 1) {
        return (model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+115+imagHeight + (model.contentType.intValue==5?40:0);
    }else{
        return 104+50+imagHeight+15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSaveVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.saveModel = self.dataArr[indexPath.row];
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    __weak typeof(self) weakSelf = self;
    cell.deleteOrSendBlock = ^(BOOL send, NSInteger index) {
        if (send) {
            [weakSelf sendVoiceWith:index];
        }else{
            [weakSelf deleteVoiceWith:index];
        }
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceSaveModel *model = self.dataArr[indexPath.row];
    if (model.contentType.intValue == 1) {
        NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
        ctl.isSave = YES;
        ctl.saveModel = model;
        ctl.index = indexPath.row;
        __weak typeof(self) weakSelf = self;
        ctl.deleteSaveModelBlock = ^(NSInteger index, BOOL noSend) {
            if (!noSend) {
                [weakSelf showToastWithText:@"已保存到草稿箱"];
            }
            [weakSelf sureDeleWith:index];
        };
     
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (model.contentType.intValue == 5){
        NoticreSendHelpController *ctl = [[NoticreSendHelpController alloc] init];
        ctl.isSave = YES;
        ctl.saveModel = model;
        ctl.index = indexPath.row;
        __weak typeof(self) weakSelf = self;
        ctl.deleteSaveModelBlock = ^(NSInteger index, BOOL noSend) {
            if (!noSend) {
                [weakSelf showToastWithText:@"已保存到草稿箱"];
            }
            [weakSelf sureDeleWith:index];
        };
     
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
        ctl.isSave = YES;
        ctl.saveModel = model;
        ctl.index = indexPath.row;
        __weak typeof(self) weakSelf = self;
        ctl.deleteSaveModelBlock = ^(NSInteger index, BOOL noSend) {
            if (!noSend) {
                [weakSelf showToastWithText:@"已保存到草稿箱"];
            }
            [weakSelf sureDeleWith:index];
        };
     
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

- (void)sendVoiceWith:(NSInteger)index{
    NoticeVoiceSaveModel *model = self.dataArr[index];
    self.locaPath = model.voiceFilePath;
    self.timeLen = model.voiceTimeLen;
    [self updateImage:index];
}

- (void)deleteVoiceWith:(NSInteger)index{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalType]?@"Sure to delete it？":@"确定要删除吗？" message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index1) {
        if (index1 == 1) {

            [weakSelf sureDeleWith:index];
        }
    };
   [alerView showXLAlertView];
}

- (void)sureDeleWith:(NSInteger)index{
    if (self.dataArr.count - 1 >= index) {

        [self.dataArr removeObjectAtIndex:index];
        [self.sourceArr removeObjectAtIndex:index];
        if (self.isVoice) {
            [NoticeSaveVoiceTools saveVoiceArr:self.sourceArr];
        }else{
            [NoticeSaveVoiceTools savehelpArr:self.sourceArr];
        }
        
        [self.tableView reloadData];
    }
}


- (void)updateImage:(NSInteger)index{
    NoticeVoiceSaveModel *model = self.dataArr[index];
    self.moveArr = [NSMutableArray new];

    if (model.img1) {
        [self.moveArr addObject:model.img1Path];
    }
    if (model.img2) {
        [self.moveArr addObject:model.img2Path];
    }
    if (model.img3) {
        [self.moveArr addObject:model.img3Path];
    }
    if (!self.moveArr.count) {
        [self updateVoice:index];
        return;
    }
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];

    for (NSString *pathN in self.moveArr) {
        [arr addObject:pathN];

        NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",pathN]]];
        NSData *data = [fileHandle readDataToEndOfFile];
        [fileHandle closeFile];
        UIImage *image  = [[UIImage alloc] initWithData:data];
        if (!image) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.noimg"]];
            return;
        }
        //UIImage转换为NSData
        NSData *imageData = UIImageJPEGRepresentation(image,0.6);//第二个参数为压缩倍数
        [arr1 addObject:imageData];
    }

    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串

    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.contentType.intValue==5? @"71": @"5" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:NO parm:parm progressHandler:^(CGFloat progress) {

    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        self.imageJsonString = Message;
        [self updateVoice:index];
    }];
}

- (void)sendTextVoice:(NoticeVoiceSaveModel *)model index:(NSInteger)index titleId:(NSString *)titleId{

    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"2" forKey:@"contentType"];
    [parm setObject:[NSString stringWithFormat:@"%ld",model.textContent.length] forKey:@"contentLen"];
    [parm setObject:model.textContent forKey:@"voiceContent"];
    [parm setObject:model.voiceIdentity?model.voiceIdentity:@"1" forKey:@"voiceIdentity"];
    if (model.stateId) {
        [parm setObject:model.stateId forKey:@"stateId"];
    }
    if (self.moveArr.count && self.imageJsonString) {
        [parm setObject:self.imageJsonString forKey:@"voiceImg"];
    }

    if (model.topicId) {
        [parm setObject:model.topicId forKey:@"topicId"];
    }

    [parm setObject: @"2" forKey:@"voiceType"];
    if (titleId) {
       [parm setObject:titleId forKey:@"titleId"];
    }

    [self showHUDWithText:@"发布中"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWSHENGXINOTICETION" object:nil];
            [self sureDeleWith:index];
            [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.hassend"]];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
        }
    } fail:^(NSError *error) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
        [self hideHUD];
    }];
}

- (void)updateVoice:(NSInteger)index{

    if (self.dataArr.count-1 < index) {
        return;
    }
    NoticeVoiceSaveModel *model = self.dataArr[index];

    if (model.contentType.intValue == 5) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:model.titleName forKey:@"title"];
        [parm setObject:model.textContent forKey:@"content"];
        if (self.imageJsonString) {
            [parm setObject:self.imageJsonString forKey:@"invitation_img"];
        }
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"invitation" Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self sureDeleWith:index];

                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"py.sendsus"]];

            }else{
                [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
   
            }
        } fail:^(NSError * _Nullable error) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
            [self hideHUD];
        }];
        return;
    }

    if (!self.locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }

    if (model.contentType.intValue != 1) {
        if (model.voiceType.intValue == 3 && !model.titleName) {
            [self sendTextVoice:model index:index titleId:nil];
        }else{
            if (model.titleName) {
                [self showHUD];
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:model.titleName forKey:@"titleName"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voiceTitles" Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                        [self sendTextVoice:model index:index titleId:idM.allId];
                    }else{
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.fali"]];
                    }
                    [self hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [self hideHUD];
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.fali"]];
                }];
            }else{
                [self sendTextVoice:model index:index titleId:nil];
            }
        }

        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.locaPath]],[self.locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"2" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    DRLog(@"地址%@  md5:%@",self.locaPath,pathMd5);

    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:self.locaPath parm:parm1 progressHandler:^(CGFloat progress) {

    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            if (self.moveArr.count && self.imageJsonString) {
                [parm setObject:self.imageJsonString forKey:@"voiceImg"];
            }

            if (model.topicId) {
                [parm setObject:model.topicId forKey:@"topicId"];
            }

            if ([model.voiceType isEqualToString:@"3"]) {
                [parm setObject: @"3" forKey:@"voiceType"];
                [parm setObject:model.score forKey:@"score"];
                if (model.bookId) {
                    [parm setObject: model.bookId forKey:@"resourceId"];
                }else if (model.songId){
                    [parm setObject: model.songId forKey:@"resourceId"];
                }else{
                    [parm setObject: model.movieId forKey:@"resourceId"];
                }
                [parm setObject:model.resourceType forKey:@"resourceType"];
            }else{
                [parm setObject: @"2" forKey:@"voiceType"];
            }
            [parm setObject:model.voiceIdentity?model.voiceIdentity:@"1" forKey:@"voiceIdentity"];
            [parm setObject:@"1" forKey:@"contentType"];
            [parm setObject:self.timeLen forKey:@"contentLen"];
            [parm setObject:Message forKey:@"voiceContent"];
            [parm setObject:@"0" forKey:@"isPrivate"];
            [self showHUDWithText:@"发布中"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];

                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWSHENGXINOTICETION" object:nil];
                    [self sureDeleWith:index];
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.hassend"]];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
                [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
            }];
        }else{
            [self hideHUD];
            [self showToastWithText:[NoticeTools getLocalStrWith:@"help.sendfail"]];
        }
    
    }];
}


- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];

}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    self.draFlot = dratNum;
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}

//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{

    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图%ld",tag);
        NoticeVoiceSaveModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voiceTimeLen;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    NoticeVoiceSaveModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
    
        [self.audioPlayer startPlayWithUrl:model.voiceFilePath isLocalFile:YES];
        self.isReplay = NO;
        self.isPasue = NO;
        model.isPlaying = YES;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.voiceTimeLen;
        [weakSelf.tableView reloadData];
    };
   

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NoticeSaveVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];

        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voiceTimeLen.integerValue) {
            currentTime = model.voiceTimeLen.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.voiceTimeLen.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.voiceTimeLen.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voiceTimeLen.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.voiceTimeLen;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.voiceTimeLen.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowPro = 0;
            model.nowTime = model.voiceTimeLen;
            
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voiceTimeLen.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.voiceTimeLen.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voiceTimeLen.integerValue-currentTime];
        model.nowPro = currentTime/model.voiceTimeLen.floatValue;
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isReplay = YES;
    self.oldSelectIndex = 9999;
    
    self.dataArr = self.isVoice?[NoticeSaveVoiceTools getVoiceArrary]:[NoticeSaveVoiceTools gethelpArrary];
    self.sourceArr = self.isVoice?[NoticeSaveVoiceTools getVoiceArrary]:[NoticeSaveVoiceTools gethelpArrary];
    for (NoticeVoiceSaveModel *model in self.dataArr) {
        model.nowPro = 0;
        model.isPlaying = NO;
        [model getData];
    }
    if (!self.dataArr.count) {
        self.tableView.tableFooterView = self.footLabel;
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.audioPlayer stopPlaying];
}

- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
        _footLabel.backgroundColor = self.tableView.backgroundColor;
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _footLabel.font = FOURTHTEENTEXTFONTSIZE;
        _footLabel.text = [NoticeTools getLocalStrWith:@"cao.nosavestill"];
    }
    return _footLabel;
}

@end
