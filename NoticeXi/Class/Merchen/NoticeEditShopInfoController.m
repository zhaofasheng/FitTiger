//
//  NoticeEditShopInfoController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditShopInfoController.h"
#import "NoticeChangeRoleIconView.h"
#import "NoticeXi-Swift.h"
@interface NoticeEditShopInfoController ()<NoticeRecordDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoiticePlayerView *palyerView;
@end

@implementation NoticeEditShopInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.text = @"编辑信息";
    
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 56;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 240)];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = headerView;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88)/2, 52, 88, 88)];
    self.iconImageView.layer.cornerRadius = 44;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image = UIImageNamed(@"noiconimgshop");
    [headerView addSubview:self.iconImageView];
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [self.iconImageView addGestureRecognizer:taps];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+15, DR_SCREEN_WIDTH, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = THRETEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = @"点击设置角色";
    [headerView addSubview:label];
    
    if(_myShopModel.myShopM.role.integerValue > 0){
        for (int i = 0; i < _myShopModel.role_listArr.count; i++) {
            NoticeMyShopModel *roleM = _myShopModel.role_listArr[i];
            if([roleM.role isEqualToString:_myShopModel.myShopM.role]){
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:roleM.role_img_url]];
                break;
            }
        }
    }
    
    self.palyerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-13-125-24,16,125, 24)];
    self.palyerView.isThird = YES;
    self.palyerView.playButton.frame = CGRectMake(5, 3, 18, 18);
    [self.palyerView refreWithFrame];
    UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_palyerView.frame.size.width, _palyerView.frame.size.height)];
    playView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
    [playView addGestureRecognizer:tap];
    [self.palyerView addSubview:playView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.12;
    [self.palyerView addGestureRecognizer:longPress];
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    self.palyerView.timeLen = self.myShopModel.myShopM.introduce_len;
    self.palyerView.voiceUrl = self.myShopModel.myShopM.introduce_url;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        __weak typeof(self) weakSelf = self;
        NoticeChangeShopNameView *nameVieww = [[NoticeChangeShopNameView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        nameVieww.nameBlock = ^(NSString * _Nullable name) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            weakSelf.myShopModel.myShopM.shop_name = name;
            [parm setObject:name forKey:@"shop_name"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.myShopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if(success){
                    if(weakSelf.refreshShopModel){
                        weakSelf.refreshShopModel(YES);
                    }
                    [weakSelf.tableView reloadData];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        };
        [nameVieww showView];
    
    }else if (indexPath.row == 1){
        [self recoderClick];
    }
    
}


- (void)playReplay{
    self.isReplay = YES;
    [self playNoReplay];
}

- (void)playNoReplay{
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.myShopModel.myShopM.introduce_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];

        [self.palyerView.playButton setImage:UIImageNamed(self.isPasue ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{//播放
            [weakSelf.tableView reloadData];
            [weakSelf.palyerView.playButton setImage:UIImageNamed(@"newbtnplay") forState:UIControlStateNormal];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.palyerView.slieView.progress = 0;
        weakSelf.palyerView.timeLen = weakSelf.myShopModel.myShopM.introduce_len;
        weakSelf.isReplay = YES;
        [weakSelf.palyerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] >weakSelf.myShopModel.myShopM.introduce_len.integerValue) {
            currentTime = weakSelf.myShopModel.myShopM.introduce_len.integerValue;
        }

        if ([[NSString stringWithFormat:@"%.f",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime)<1) || [[NSString stringWithFormat:@"%.f",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"-0"]) {
            weakSelf.isReplay = YES;
            weakSelf.palyerView.slieView.progress = 0;
            weakSelf.palyerView.timeLen = weakSelf.myShopModel.myShopM.introduce_len;
            if ((weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
            [weakSelf.tableView reloadData];
        }
        weakSelf.palyerView.timeLen = [NSString stringWithFormat:@"%.f",weakSelf.myShopModel.myShopM.introduce_len.integerValue-currentTime];
        weakSelf.palyerView.slieView.progress = currentTime/weakSelf.myShopModel.myShopM.introduce_len.floatValue;
    };
}

- (void)longPressGestureRecognized:(id)sender{
 
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.palyerView];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
       
            self.tableView.scrollEnabled = NO;
            [self.audioPlayer pause:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.palyerView.slieView.progress = p.x/self.palyerView.frame.size.width;
            // 跳转
            [self.audioPlayer.player seekToTime:CMTimeMake(([[NoticeSaveModel getUserInfo] wave_len].floatValue/self.palyerView.frame.size.width)*p.x, 1) completionHandler:^(BOOL finished) {
                if (finished) {
                }
            }];
            break;
        }
        default: {
            self.tableView.scrollEnabled = NO;
            [self.audioPlayer pause:NO];
            break;
        }
    }
}

- (void)recoderClick{
    [self stopPlay];
    NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.needCancel = YES;
    recodeView.delegate = self;
    recodeView.isDb = YES;
    recodeView.titleL.text = @"";
    [recodeView show];
}

- (void)stopPlay{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
}

//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"85" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    

    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"introduce"];
            [parm setObject:timeLength forKey:@"introduce_len"];
            [[NoticeTools getTopViewController] showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.myShopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success1) {
                    if(self.refreshShopModel){
                        self.refreshShopModel(YES);
                    }
                    [self getShopRequest];
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }else{
            [[NoticeTools getTopViewController] showToastWithText:Message];
            [[NoticeTools getTopViewController] hideHUD];
        }
    }];
    
}

- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.myShopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.palyerView.timeLen = self.myShopModel.myShopM.introduce_len;
            self.palyerView.voiceUrl = self.myShopModel.myShopM.introduce_url;
            [self.tableView reloadData];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.line.hidden = NO;
    cell.subImageV.image = UIImageNamed(@"cellnextbutton");
    cell.subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    cell.subImageV.hidden = NO;
    if (indexPath.row == 0) {
        cell.mainL.text = @"店铺名";
        cell.subL.text = self.myShopModel.myShopM.shop_name;
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-150, 0,150, 55);
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }
    
    if (indexPath.row == 1) {
        cell.mainL.text = @"店铺简介";
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-150, 0,150, 55);
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        
        [self.palyerView removeFromSuperview];
        [cell.contentView addSubview:self.palyerView];
        if (!self.myShopModel.myShopM.introduce_len.intValue) {
            self.palyerView.hidden = YES;
            cell.subL.text = @"还没有介绍录制一个吧";
        }else{
            self.palyerView.hidden = NO;
            cell.subL.text = @"";
        }
    }
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)iconTap{
    __weak typeof(self) weakSelf = self;
    NoticeChangeRoleIconView *changeView = [[NoticeChangeRoleIconView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    changeView.myShopModel = self.myShopModel;
    changeView.refreshRoleBlock = ^(NSString * _Nonnull role, NSString * _Nonnull url) {
        [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        weakSelf.myShopModel.myShopM.role = role;
        [parm setObject:role forKey:@"role"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.myShopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                if(weakSelf.refreshShopModel){
                    weakSelf.refreshShopModel(YES);
                }
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    };
    [changeView showChoiceView];
}

@end
