//
//  NoticeSetVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2019/11/12.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetVoiceController.h"
#import "NoticeClockVoiceCell.h"
@interface NoticeSetVoiceController ()

@property (nonatomic, strong) NSMutableArray *dataChoiceArr;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, assign) NSInteger count;
@end

@implementation NoticeSetVoiceController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.audioPlayer stopPlaying];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?@"闹钟设定":@"鬧鐘設定";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45, 25);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 45, 25);
    [btn1 setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [btn1 setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn1.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    backView.backgroundColor = GetColorWithName(VlistColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(23, 20, DR_SCREEN_WIDTH-23, 12)];
    label.font = TWOTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    label.text = [NoticeTools isSimpleLau]?@"配音铃声（多选后每次随机播放）":@"配音鈴聲（多選後每次隨機播放）";
    [backView addSubview:label];
    [self.view addSubview:backView];
    
    self.tableView.frame = CGRectMake(0, 40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-85);
    self.tableView.rowHeight = 65;
    [self.tableView registerClass:[NoticeClockVoiceCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = [NoticeComTools getColockChaceModel];
    
    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 45+BOTTOM_HEIGHT)];
    self.statusL.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F37335":@"#AA5225"];
    self.statusL.textAlignment = NSTextAlignmentCenter;
    self.statusL.font = FOURTHTEENTEXTFONTSIZE;
    self.statusL.textColor = GetColorWithName(VMainThumeWhiteColor);
    self.statusL.text = @"最多选5个，当前已选1个";
    [self.view addSubview:self.statusL];
    
    self.dataChoiceArr = [NoticeComTools getColockVoiceChaceModel];
    NoticeClockChaceModel *firstM = [[NoticeClockChaceModel alloc] init];
    firstM.voiceNameUrl = @"默认";
    firstM.isChoice = @"0";
    firstM.pyIdAndUserId = @"moren";
    if (!self.dataChoiceArr.count) {
        firstM.isChoice = @"1";
        self.count = 1;
    }else{
        self.count = self.dataChoiceArr.count;
    }
    [self.dataArr insertObject:firstM atIndex:0];
    for (NoticeClockChaceModel *oldM in self.dataChoiceArr) {
        for (NoticeClockChaceModel *savM in self.dataArr) {
            if ([oldM.pyIdAndUserId isEqualToString:savM.pyIdAndUserId]) {
                savM.isChoice = @"1";
            }
        }
    }
    self.statusL.text = [NSString stringWithFormat:@"最多选5个，当前已选%ld个",(long)self.count];
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.playComplete = ^{
        for (NoticeClockChaceModel *model in weakSelf.dataArr) {
            model.isPlaying = NO;
        }
        [weakSelf.tableView reloadData];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NoticeClockChaceModel *model = self.dataArr[indexPath.row];
    model.isPlaying = NO;
    [self.audioPlayer stopPlaying];
    if (model.isChoice.boolValue) {
        model.isChoice = @"0";
        [self.audioPlayer stopPlaying];
    }else{
        if (self.count < 5) {
            model.isChoice = @"1";
        }else{
            [self showToastWithText:@"最多只能选择5个音频"];
        }
        if ([model.pyIdAndUserId isEqualToString:@"moren"]) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"hotM_01" ofType:@"caf"];
            model.isPlaying = YES;
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }else{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *document= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSArray *fileList ;
            fileList =[fileManager contentsOfDirectoryAtPath:document error:NULL];
            for (NSString *file in fileList) {
                NSString *path =[document stringByAppendingPathComponent:file];
                if ([[path lastPathComponent] isEqualToString:model.voiceAllUrl]) {
                    [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
                    model.isPlaying = YES;
                    DRLog(@"得到的路径=%@\n%@",path,[path lastPathComponent]);
                    break;
                }
            }
        }
    }
    NSInteger tag = 0;
    for (NoticeClockChaceModel *olM in self.dataArr) {
        if (olM.isChoice.boolValue) {
            tag++;
        }
    }
    self.count = tag;
    self.statusL.text = [NSString stringWithFormat:@"最多选5个，当前已选%ld个",(long)self.count];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeClockVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.cacheModel = self.dataArr[indexPath.row];
    cell.stopLabel.hidden = ![self.dataArr[indexPath.row] isPlaying];
    return cell;
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeClockChaceModel *saveM = self.dataArr[indexPath.row];
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:indexPath.row == 0 ? @"不可删除" : [NoticeTools getLocalStrWith:@"groupManager.del"]handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (indexPath.row == 0) {
            return ;
        }
        [NoticeComTools cancelCaceClockModel:saveM.pyIdAndUserId];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageCheace" object:nil];
        
    }];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}

- (void)fifinshClick{
    [self.dataChoiceArr removeAllObjects];
    for (NoticeClockChaceModel *olM in self.dataArr) {
        if (olM.isChoice.boolValue) {
            [self.dataChoiceArr addObject:olM];
        }
    }
    [NoticeComTools saveColockVoiceChace:self.dataChoiceArr];
    [self cancelClick];
}

- (void)cancelClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromBottom
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
