//
//  NoticeSendAllUsersController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendAllUsersController.h"
#import "NoticeNearSearchPersonCell.h"
#import "NoticeClipImage.h"
#import "NoticeChats.h"

@interface NoticeSendAllUsersController ()<NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger choiceTag;
@end

@implementation NoticeSendAllUsersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NoticeNearSearchPersonCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
    self.dataArr = [[NSMutableArray alloc] init];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-65);
    self.navigationItem.title = @"群发用户消息";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-5-40-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+20+40+5)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    [self.view addSubview:backView];
    
    UIButton *dhBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,5,(DR_SCREEN_WIDTH-55)/3, 40)];
    dhBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    dhBtn.layer.cornerRadius = 8;
    dhBtn.layer.masksToBounds = YES;
    [dhBtn setTitle:[NoticeTools getLocalStrWith:@"search.text"] forState:UIControlStateNormal];
    [dhBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    dhBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [dhBtn addTarget:self action:@selector(textClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:dhBtn];
    
    UIButton *goTbBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+(DR_SCREEN_WIDTH-55)/3+15,5,(DR_SCREEN_WIDTH-55)/3*2, 40)];
    goTbBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    goTbBtn.layer.cornerRadius = 8;
    goTbBtn.layer.masksToBounds = YES;
    [goTbBtn setTitle:@"点击发送语音" forState:UIControlStateNormal];
    [goTbBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    goTbBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [goTbBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:goTbBtn];
    
    self.choiceArr  = [[NSMutableArray alloc] init];

}

- (void)textClick{
    if (!self.choiceArr.count) {
        [self showToastWithText:@"请选择要发送的人"];
        return;
    }
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    self.content = str;
    self.choiceTag = 0;
    if (!self.choiceArr.count) {
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.choiceArr.count; i++) {
     
        NoticeNearPerson *person = self.choiceArr[i];
        [arr addObject:person.blackId];
    }
    NoticeNearPerson *person = self.choiceArr[self.choiceTag];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"849527" forKey:@"confirmPasswd"];
    [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"userIds"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/warm/markReply" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    if (!person.hasSend) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:self.content fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:person.nick_name], 0.6) path:pathMd5 text:str to:[NSString stringWithFormat:@"sx_pro_%@",person.blackId] person:person];
    }
    
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text to:(NSString *)touser person:(NoticeNearPerson *)perM{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    if (!self.choiceArr.count) {
        return;
    }
    [self showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            
            if (!perM.hasSend) {
                weakSelf.sendDic = [NSMutableDictionary new];
                [weakSelf.sendDic setObject:touser forKey:@"to"];
                [weakSelf.sendDic setObject:@"singleChat" forKey:@"flag"];
                NSMutableDictionary *messageDic = [NSMutableDictionary new];
                [messageDic setObject:@"0" forKey:@"voiceId"];
                [messageDic setObject:@"2" forKey:@"dialogContentType"];
                if (bucketId) {
                    [messageDic setObject:bucketId forKey:@"bucketId"];
                }
                [messageDic setObject:text forKey:@"dialogContentText"];
                [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
                [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
                [weakSelf.sendDic setObject:messageDic forKey:@"data"];
                 AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appdel.socketManager sendMessage:weakSelf.sendDic];
                [weakSelf hideHUD];
                perM.hasSend = YES;
            }
   
            
            DRLog(@"哈哈");
            weakSelf.choiceTag++;
            
            if (weakSelf.choiceTag <= weakSelf.choiceArr.count-1) {
                NoticeNearPerson *person = weakSelf.choiceArr[weakSelf.choiceTag];
                if (!person.hasSend) {
                    NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
                    [weakSelf upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:self.content fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:person.nick_name], 0.6) path:pathMd5 text:weakSelf.content to:[NSString stringWithFormat:@"sx_pro_%@",person.blackId] person:person];
                }
            }else{
                [self.choiceArr removeAllObjects];
            }
        }else{
            [weakSelf showToastWithText:errorMessage];
        }
    }];
}


- (void)voiceClick{
    if (!self.choiceArr.count) {
        [self showToastWithText:@"请选择要发送的人"];
        return;
    }
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    __weak typeof(self) weakSelf = self;
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"4" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
        
    [self showHUD];
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm1 progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId,BOOL sussess) {
        if (sussess) {
            weakSelf.sendDic = [NSMutableDictionary new];
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:@"0" forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
     
      
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 0; i < weakSelf.choiceArr.count; i++) {
                NoticeNearPerson *person = weakSelf.choiceArr[i];
                [arr addObject:person.blackId];
                [weakSelf.sendDic setObject:[NSString stringWithFormat:@"sx_pro_%@",person.blackId] forKey:@"to"];
                [weakSelf.sendDic setObject:@"singleChat" forKey:@"flag"];
                [weakSelf.sendDic setObject:messageDic forKey:@"data"];
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appdel.socketManager sendMessage:weakSelf.sendDic];
                
      
            }
            [weakSelf.choiceArr removeAllObjects];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"849527" forKey:@"confirmPasswd"];
            [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"userIds"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/warm/markReply" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
            [weakSelf hideHUD];
        } else{
            [weakSelf hideHUD];
   
            [weakSelf showToastWithText:Message];
        }
    }];
    
}


- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/warm/recording?confirmPasswd=849527&pageNo=1"];
    }else{
        url = [NSString stringWithFormat:@"admin/warm/recording?confirmPasswd=849527&pageNo=%ld",self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.choiceArr removeAllObjects];
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNearPerson *model = [NoticeNearPerson mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak NoticeSendAllUsersController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
        
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNearSearchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.sendAll = YES;
    cell.person = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNearPerson *model = self.dataArr[indexPath.row];
    model.isselect = !model.isselect;
    for (NoticeNearPerson *person in self.choiceArr) {
        if (!person.isselect) {
            [self.choiceArr removeObject:person];
        }
    }
    if (model.isselect) {
        [self.choiceArr addObject:model];
    }
    [self.tableView reloadData];
}

@end
