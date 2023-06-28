//
//  NoticeSetYuReplyController.m
//  NoticeXi
//
//  Created by li lei on 2019/9/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetYuReplyController.h"
#import "NoticeYuSetCell.h"
#import "DDHAttributedMode.h"
#import "LHEditTextView.h"
#import "RTDragCellTableView.h"
@interface NoticeSetYuReplyController ()<NoticeYuSetClickDelegate,NoticeRecordDelegate,TZImagePickerControllerDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>
@property (nonatomic, strong) NoticeYuSetModel *oldModel;
@property (nonatomic, assign) NSInteger choiceIndex;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSString *markStr;
@property (nonatomic, strong) NSString *moveId;
@property (nonatomic, assign) NSInteger perRow;
@property (nonatomic, strong) NSString *oldName;
@end

@implementation NoticeSetYuReplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = @"设置预设回复语";
    self.dataArr = [NSMutableArray new];
    [self.tableView removeFromSuperview];
    
    self.tableView = [[RTDragCellTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    [self.tableView registerClass:[NoticeYuSetCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    [self.view addSubview:self.tableView];
    
    [self request];
    [self.modelArr removeAllObjects];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0,40, 25);
    [btn setImage:UIImageNamed(@"Image_addys") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)addClick{
    [LHEditTextView showWithController:self isAddandRequestDataBlock:^(NSString *text, NSString *textImage) {
        self.markStr = text?text:textImage;
        if (text) {
            self.isEdit = NO;
            NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
            recodeView.needCancel = YES;
            recodeView.delegate = self;
            recodeView.isDb = YES;
            [recodeView show];
        }else if (textImage){
            self.isEdit = NO;
            [self sendImageView];
        }
    }];
}



//发送图片
- (void)sendImageView{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"19" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"resourceType"];
            [parm setObject:Message forKey:@"resourceUri"];
            [parm setObject:@"567" forKey:@"resourceLen"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            
            if (self.isEdit) {
                NoticeYuSetModel *sys = self.dataArr[self.choiceIndex];
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/%@/defaultReply/%@",[[NoticeSaveModel getUserInfo] user_id],sys.yuseId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [self hideHUD];
                    if (success) {
                        [self request];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                    }
                } fail:^(NSError *error) {
                    [self hideHUD];
                }];
                return ;
            }
            [parm setObject:self.markStr forKey:@"replyRemark"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    [self request];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeYuSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return self.dataArr;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    self.dataArr = [NSMutableArray arrayWithArray: newArray];
}

- (void)cellMoveFrom:(NSIndexPath *)oldIndexPath toNewIndexPath:(NSIndexPath *)newNndexPath{
    NoticeYuSetModel *new = self.dataArr[newNndexPath.row];
    self.moveId = new.yuseId;
    self.perRow = newNndexPath.row;
    self.oldName = new.reply_remark;
}

- (void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (!self.perRow) {
        [parm setObject:@"0" forKey:@"preReplyId"];
    }else{
        [parm setObject:[self.dataArr[self.perRow-1] yuseId] forKey:@"preReplyId"];
    }
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/%@/defaultReply/%@",[[NoticeSaveModel getUserInfo] user_id],self.moveId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}


#pragma Mark - 音频播放模块
- (void)startPlayAndStop:(NSInteger)tag{
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeYuSetModel *oldM = self.oldModel;
            oldM.nowTime = oldM.resource_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeYuSetModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            
            [weakSelf.tableView reloadData];
        }
    };
    
    
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        DRLog(@"播放结束");
        [weakSelf.tableView reloadData];
    };
    
    //-0.045715
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeYuSetCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            
            if ((model.resource_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                model.nowPro = 0;
                cell.playerView.timeLen = model.resource_len;
                [weakSelf.tableView reloadData];
            };
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross>0? weakSelf.progross : currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)request{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                [self.dataArr addObject:model];
                hasData = YES;
            }
            
            if (self.dataArr.count) {
                NoticeYuSetModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)getMore{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply?lastSort=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                [self.dataArr addObject:model];
                hasData = YES;
            }
            
            if (self.dataArr.count) {
                NoticeYuSetModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)reRecord:(NSInteger)index{
    NoticeYuSetModel *model = self.dataArr[index];
    self.isEdit = YES;
    if (model.reply_remark.length > 3) {
        if ([[model.reply_remark substringToIndex:3] isEqualToString:@"回复语"]) {
            [self showToastWithText:@"请输入正确回复语，回复语不可以有回复语三个字"];
            return;
        }
    }
    self.choiceIndex = index;
    if (model.resource_type.intValue == 2) {
        [self sendImageView];
        return;
    }
    NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.needCancel = YES;
    recodeView.delegate = self;
    recodeView.isDb = YES;
    [recodeView show];
}

- (void)reInput:(NSInteger)index{
    [LHEditTextView showWithController:self andRequestDataBlock:^(NSString *message) {
        NoticeYuSetModel *model = self.dataArr[index];
        model.reply_remark = message;
        model.isTrueStr = YES;
        [self.tableView reloadData];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:model.resource_type forKey:@"resourceType"];
        [parm setObject:model.resource_uri forKey:@"resourceUri"];
        [parm setObject:model.resource_len forKey:@"resourceLen"];
        [parm setObject:model.reply_remark forKey:@"replyRemark"];
        [parm setObject:model.bucket_id forKey:@"bucketId"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/%@/defaultReply/%@",[[NoticeSaveModel getUserInfo] user_id],model.yuseId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }];
}

//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"19" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    [self showHUD];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NoticeYuSetModel *model = !self.isEdit?[NoticeYuSetModel new]: self.dataArr[self.choiceIndex];
            if (!self.isEdit) {
                model.reply_remark = self.markStr;
            }
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"1" forKey:@"resourceType"];
            [parm setObject:Message forKey:@"resourceUri"];
            [parm setObject:timeLength forKey:@"resourceLen"];
            [parm setObject:model.reply_remark forKey:@"replyRemark"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            if (!self.isEdit) {
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [self hideHUD];
                    if (success) {
                        [self request];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                    }
                } fail:^(NSError *error) {
                    [self hideHUD];
                }];
                return ;
            }
    
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/%@/defaultReply/%@",[[NoticeSaveModel getUserInfo] user_id],model.yuseId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    [self request];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEYUSEREPLAY" object:nil];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
      
        }else{
            [self showToastWithText:Message];
            [self hideHUD];
        }
    }];
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NoticeYuSetModel *sys = self.dataArr[indexPath.row];
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[NoticeTools getLocalStrWith:@"groupManager.del"]handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        //在这里添加点击事件
        [self showHUD];
       
        [[DRNetWorking shareInstance]requestWithDeletePath:[NSString stringWithFormat:@"admin/%@/defaultReply/%@",[NoticeTools getuserId],sys.yuseId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.dataArr.count-1 >= indexPath.row) {
                    [self.dataArr removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                    return ;
                }
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];

    }];

    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}
@end
