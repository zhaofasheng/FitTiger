//
//  NoticeCacheManagerController.m
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCacheManagerController.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeTitleAndImageCell.h"
#import "DDHAttributedMode.h"
@interface NoticeCacheManagerController ()<UITableViewDelegate,UITableViewDataSource,NoticeCacheManagerDelegate>
@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, strong) NSMutableArray *moveArr;
@end

@implementation NoticeCacheManagerController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH-40, 50)];
    label.font = TWOTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    label.numberOfLines = 2;
    label.text = @"缓存是使用声昔过程中产生的临时数据，清理缓存不会影响声昔的正常使用。";
    [self.view addSubview:label];
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2,(DR_SCREEN_HEIGHT-50)/2,240,50)];
    [clearButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [clearButton setTitle:[NoticeTools getLocalStrWith:@"cace.qk"] forState:UIControlStateNormal];
    clearButton.titleLabel.font = XGEightBoldFontSize;
    clearButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    clearButton.layer.cornerRadius = 25;
    clearButton.layer.masksToBounds = YES;
    [clearButton addTarget:self action:@selector(clearAllClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"set.cac"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
}

- (void)clearAllClick{
    [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.celasus"]];
//    [NoticeSaveVoiceTools clearTmpDirectory];
//    [self.dataArr removeAllObjects];
//    [NoticeSaveVoiceTools saveVoiceArr:self.dataArr];
//    [self.tableView reloadData];
}

- (void)backClick{
    if (self.popType == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-15-16, 55);
    cell.backgroundColor = self.view.backgroundColor;
    cell.subImageV.hidden = YES;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.sendButton.hidden = NO;
    cell.line.hidden = YES;
    cell.deleteButton.hidden = NO;
    cell.isSmallHeight = YES;
    NoticeVoiceSaveModel *model = self.dataArr[indexPath.row];
    cell.mainL.text = [NSString stringWithFormat:@"%@的%@", model.sendTime,model.contentType.intValue==5?[NoticeTools getLocalStrWith:@"help.qiuz"]:@"心情"];
    if ([NoticeTools getLocalType]) {
        cell.mainL.text = model.sendTime;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
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
        NoticeVoiceSaveModel *model = self.dataArr[index];
        if (model.voiceFilePath) {
            [NoticeSaveVoiceTools removeItemAtPath:model.voiceFilePath];
        }

        [self.dataArr removeObjectAtIndex:index];

        [NoticeSaveVoiceTools saveVoiceArr:self.dataArr];
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
        }
    } fail:^(NSError *error) {
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
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }

    if (!self.locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }

    if (model.textContent) {
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
            }];
        }
        else{
            [self hideHUD];
            [self showToastWithText:Message];
        }
    }];
}

@end
