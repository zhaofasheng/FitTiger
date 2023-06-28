//
//  NoticeEditViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditViewController.h"
#import "NoticeTitleAndImageCell.h"
#import "NoticeChangeIconViewController.h"
#import "NoticeChangeNameViewController.h"
#import "NoticeChangeIntroduceViewController.h"
#import "AppDelegate.h"
#import "NoticeManagerController.h"
#import "NoticeManager.h"
@interface NoticeEditViewController ()<NoticeRecordDelegate,TZImagePickerControllerDelegate,NoticePlayerNumbersDelegate,NoticeManagerUserDelegate>

@property (nonatomic, strong) NSArray *cellTitleArr;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NoticeRecoderView *recodeView;
@property (nonatomic, strong) NoiticePlayerView *palyerView;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation NoticeEditViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.recodeView.delegate = nil;
    self.recodeView = nil;
}


//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"waveUri"];
            [parm setObject:timeLength forKey:@"waveLen"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                
                if (success1) {
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                        [self hideHUD];
                        if (success2) {
                            [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.resus"]];
                            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                            [NoticeSaveModel saveUserInfo:userIn];
                            self.userInfo = userIn;
                            self.palyerView.timeLen = self.userInfo.wave_len;
                            self.palyerView.voiceUrl = self.userInfo.wave_url;
                            [self.tableView reloadData];
                        }
                    } fail:^(NSError *error) {
                        [self hideHUD];
                    }];
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
- (void)viewDidLoad {
    [super viewDidLoad];

    self.noNeedAssestPlay = YES;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"set.cell1"];
    
    self.cellTitleArr = @[[NoticeTools getLocalStrWith:@"intro.username"],[NoticeTools getLocalStrWith:@"intro.xueh"],[NoticeTools chinese:@"语音简介" english:@"Voice intro" japan:@"音声紹介"],[NoticeTools getLocalStrWith:@"intro.textintro"],[NoticeTools chinese:@"昔龄" english:@"Been here" japan:@"ユーザー"],[NoticeTools chinese:@"记录心情" english:@"Record" japan:@"SNS"]];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 56;
    
    self.palyerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-13-125-24,16,125, 24)];
    self.palyerView.delegate = self;
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

    
    if ([NoticeTools isManager]) {
     
        [self.navBarView.rightButton setTitle:@"管理" forState:UIControlStateNormal];
        [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        self.navBarView.rightButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [self.navBarView.rightButton addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
      
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 240)];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = headerView;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 95, DR_SCREEN_WIDTH, 240-95)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [headerView addSubview:backView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88)/2, backView.frame.origin.y-44, 88, 88)];
    self.iconImageView.layer.cornerRadius = 44;
    self.iconImageView.layer.masksToBounds = YES;
    [headerView addSubview:self.iconImageView];
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [self.iconImageView addGestureRecognizer:taps];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+15, DR_SCREEN_WIDTH, 18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = THRETEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = [NoticeTools getLocalStrWith:@"intro.clickchange"];
    [headerView addSubview:label];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-240-56*4)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tableView.tableFooterView = footView;
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopVoiceChat) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

- (void)shopVoiceChat{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
}

- (void)managerClick{
    
    self.magager.type = @"管理员登陆";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeManagerController *ctl = [[NoticeManagerController alloc] init];
            ctl.mangagerCode = code;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)playReplay{
    self.isReplay = YES;
    [self playNoReplay];
}

- (void)playNoReplay{
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:[[NoticeSaveModel getUserInfo] wave_url] isLocalFile:NO];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPCUTUSMEMUSICPALY" object:nil];
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.palyerView.slieView.progress = 0;
        weakSelf.palyerView.timeLen = [[NoticeSaveModel getUserInfo] wave_len];
        weakSelf.isReplay = YES;
        [weakSelf.palyerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] >[[NoticeSaveModel getUserInfo] wave_len].integerValue) {
            currentTime = [[NoticeSaveModel getUserInfo] wave_len].integerValue;
        }

        if ([[NSString stringWithFormat:@"%.f",[[NoticeSaveModel getUserInfo] wave_len].integerValue-currentTime] isEqualToString:@"0"] ||  (([[NoticeSaveModel getUserInfo] wave_len].integerValue-currentTime)<1) || [[NSString stringWithFormat:@"%.f",[[NoticeSaveModel getUserInfo] wave_len].integerValue-currentTime] isEqualToString:@"-0"]) {
            weakSelf.isReplay = YES;
            weakSelf.palyerView.slieView.progress = 0;
            weakSelf.palyerView.timeLen = [[NoticeSaveModel getUserInfo] wave_len];
            if (([[NoticeSaveModel getUserInfo] wave_len].integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
            [weakSelf.tableView reloadData];
        }
        weakSelf.palyerView.timeLen = [NSString stringWithFormat:@"%.f",[[NoticeSaveModel getUserInfo] wave_len].integerValue-currentTime];
        weakSelf.palyerView.slieView.progress = currentTime/[[NoticeSaveModel getUserInfo] wave_len].floatValue;
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

//重新录制音频
- (void)reRecondClick{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
    _recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    _recodeView.needCancel = YES;
    _recodeView.delegate = self;
    _recodeView.isDb = YES;
    [self.recodeView show];
}

- (void)iconTap{
    NoticeChangeIconViewController *ctl = [[NoticeChangeIconViewController alloc] init];

    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeChangeNameViewController *ctl = [[NoticeChangeNameViewController alloc] init];
        ctl.name = self.userInfo.nick_name;
        [self.navigationController pushViewController:ctl animated:YES];

    }else if (indexPath.row == 1){
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        [pastboard setString:self.userInfo.frequency_no];
        [self showToastWithText:[NoticeTools getLocalType]?@"Vox ID copied":@"学号已复制"];
    }else if (indexPath.row == 2){
        [self reRecondClick];

    }else if (indexPath.row == 3){
        NoticeChangeIntroduceViewController *ctl = [[NoticeChangeIntroduceViewController alloc] init];
        ctl.induce = self.userInfo.self_intro;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.cellTitleArr[indexPath.row];
    cell.line.hidden = NO;
    cell.subImageV.image = UIImageNamed(@"cellnextbutton");
    cell.subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    cell.subImageV.hidden = NO;
    if (indexPath.row == 0) {
        cell.subL.text = self.userInfo.nick_name;
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-150, 0,150, 55);
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }
    
    if (indexPath.row == 1) {
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-150, 0,150, 55);
        cell.subImageV.image = UIImageNamed(@"Image_fuxuehao");
        cell.subL.text = self.userInfo.frequency_no;
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }
    
    if (indexPath.row == 2) {
        [self.palyerView removeFromSuperview];
        [cell.contentView addSubview:self.palyerView];
        if (!self.userInfo.wave_url) {
            self.palyerView.hidden = YES;
            cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-150, 0,150, 55);
            cell.subL.text = [NoticeTools getLocalType]?@"Start": @"点击录制";
            if ([NoticeTools getLocalType] == 2) {
                cell.subL.text = @"録音";
            }
            cell.subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        }else{
            self.palyerView.hidden = NO;
            cell.subL.text = @"";
        }
    }
    
    if (indexPath.row == 3) {
        if (!self.userInfo.self_intro.length) {
            cell.subL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        }else{
            cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        }
        cell.subL.text = self.userInfo.self_intro.length?self.userInfo.self_intro:[NoticeTools getLocalStrWith:@"intro.inp"];
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-15-9-10-GET_STRWIDTH(@"深圳刘德华深圳刘德华", 14,14)-10-13, 0,GET_STRWIDTH(@"深圳刘德华深圳刘德华", 14, 14)+24, 55);
        cell.subL.textAlignment = NSTextAlignmentRight;
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-9-GET_STRWIDTH(@"深圳刘德华深圳刘德华", 14,14)-24-24, 0,GET_STRWIDTH(@"深圳刘德华深圳刘德华", 14, 14)+24, 55);
        cell.subL.numberOfLines = 2;
    }
 
    if (indexPath.row == 4) {
        cell.subImageV.hidden = YES;
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-180, 0,180, 55);
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        if ([NoticeTools getLocalType] == 1) {
            cell.subL.text = [NSString stringWithFormat:@"%@days",self.userInfo.comeHereDays];
        }else if ([NoticeTools getLocalType] == 2){
            cell.subL.text = [NSString stringWithFormat:@"%@日",self.userInfo.comeHereDays];
        }else{
            cell.subL.text = [NSString stringWithFormat:@"%@天(%@入驻)",self.userInfo.comeHereDays,self.userInfo.regTime];
        }
        
    }
    
    if (indexPath.row == 5) {
        cell.subImageV.hidden = YES;
        cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-13-24-180, 0,180, 55);
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        cell.subL.text = [NSString stringWithFormat:@"%@%@",self.userInfo.allVoiceTime,self.userInfo.isMoreFiveMin?[NoticeTools chinese:@"分钟" english:@"mins" japan:@"分"]:[NoticeTools chinese:@"秒" english:@"s" japan:@"秒"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleArr.count;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfo = [NoticeSaveModel getUserInfo];
    self.palyerView.timeLen = self.userInfo.wave_len;
    self.palyerView.voiceUrl = self.userInfo.wave_url;
    [self.tableView reloadData];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userInfo = userIn;
            [NoticeSaveModel saveUserInfo:userIn];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
