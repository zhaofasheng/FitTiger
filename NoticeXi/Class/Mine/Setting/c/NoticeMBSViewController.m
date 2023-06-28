//
//  NoticeMBSViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMBSViewController.h"
#import "NoticeNoticenterModel.h"
@interface NoticeMBSViewController ()
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@end

@implementation NoticeMBSViewController
{
    NSArray *_titArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localized(@"privacy.title");
    
    if (self.type <= 2) {
        NSArray *itemArr = @[[NoticeTools getTextWithSim:@"我的电影隐私设置" fantText:@"我的電影隱私設置"],[NoticeTools getTextWithSim:@"我的书籍隐私设置" fantText:@"我的書籍隱私設置"],[NoticeTools isSimpleLau]?@"我的音乐隐私设置":@"我的音乐隱私設置"];
        self.navigationItem.title = itemArr[self.type];
    }
    
    if (!self.isAch && !self.isLike && !self.isTab) {//如果不是成就和点亮
        NSArray *arr = [NoticeTools isSimpleLau]?@[@"「仅限学友」将禁止还不是好友的用户浏览「电影」",@"「仅限学友」将禁止还不是好友的用户浏览「书籍」",@"「仅限学友」将禁止还不是学友的用户浏览「音乐」",@"「仅限学友」将对还不是室友的用户隐藏话题"]:@[@"「僅限学友」將禁止還不是学友的用戶瀏覽「電影」",@"「僅限学友」將禁止還不是学友的用戶瀏覽「書籍」",@"「僅限学友」將禁止還不是学友的用戶瀏覽「音乐」",@"「僅限学友」將對還不是学友的用戶隱藏話題"];
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 65)];
        self.tableView.tableFooterView = footView;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,25, DR_SCREEN_WIDTH, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = TWOTEXTFONTSIZE;
        label.textColor = GetColorWithName(VDarkTextColor);
        label.text = arr[self.type];
        if (self.isPy) {
            label.text = [NoticeTools getTextWithSim:@"设为「仅自己可见」将禁止他人浏览你的「心情簿-配音」" fantText:@"設為「僅自己可見」將禁止他人瀏覽妳的「心情簿-配音」"];
        }
        if (self.isDraw) {
            label.text = [NoticeTools getTextWithSim:@"设为「仅自己可见」将禁止他人浏览你的「心情簿-画」" fantText:@"設為「僅自己可見」將禁止他人瀏覽妳的「心情簿-画」"];
        }
        [footView addSubview:label];
    }
    
    _titArr = @[Localized(@"privacy.all"),Localized(@"privacy.limit")];

    if (self.isTopic) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"话题可见性设置" fantText:@"話題可見性設置"];
    }
    if (self.isAch) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"成就设置" fantText:@"成就設置"];
        _titArr = @[@"展示",@"不展示"];
    }
    
    if (self.isPy) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"我的配音隐私设置" fantText:@"我的配音隱私設置"];
        _titArr = [NoticeTools isSimpleLau]? @[@"所有人",@"仅限学友",[NoticeTools getLocalStrWith:@"n.onlyself"]]:@[@"所有人",@"僅限学友",@"僅自己可見"];
    }
    
    if (self.isDraw) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"我的画隐私设置" fantText:@"我的画隱私設置"];
        _titArr = [NoticeTools isSimpleLau]? @[@"所有人",@"仅限学友",[NoticeTools getLocalStrWith:@"n.onlyself"]]:@[@"所有人",@"僅限学友",@"僅自己可見"];
    }
    
    if (self.isLike) {
        self.navigationItem.title = @"点亮";
        _titArr = @[@"展示",@"不展示"];
        CGFloat imgHeight = 308;
        CGFloat imgWidth = 178;
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-65*2-40-BOTTOM_HEIGHT)];
        self.tableView.tableFooterView = footView;
        UIImageView *showImgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-imgWidth)/2,20, imgWidth, imgHeight)];
        showImgView.image = UIImageNamed(@"Image_dianldefaut_b");
        [footView addSubview:showImgView];
    }
    if (self.isTab) {
        self.navigationItem.title = [NoticeTools getTextWithSim:@"首页优先展示" fantText:@"首頁優先展示"];
        _titArr = [NoticeTools isSimpleLau]? @[@"操场、社团、寝室",@"操场、寝室、社团",@"寝室、操场、社团",@"寝室、社团、操场",@"社团、操场、寝室",@"社团、寝室、操场"]:@[@"操場、社團、寢室",@"操場、寢室、社團",@"寢室、操場、社團",@"寢室、社團、操場",@"社團、操場、寢室",@"社團、寢室、操場"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isTab) {
        if ([NoticeTools isFirstShowRoom] != indexPath.row) {
            [NoticeTools setFirstShowRoom:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETHEMCOLORNOTICATION" object:nil];
        }
        return;
    }
    
    if (self.isPy || self.isDraw) {//配音和画隐私设置
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"moodbook" forKey:@"settingTag"];
        [parm setValue:self.setName forKey:@"settingName"];
        [parm setValue:[NSString stringWithFormat:@"%ld",indexPath.row+1] forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.pyBlock) {
                    self.pyBlock(indexPath.row +1);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    
    if (self.isAch) {//如果是展示成就设置
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"other" forKey:@"settingTag"];
        [parm setValue:self.setName forKey:@"settingName"];
        [parm setValue:indexPath.row == 0?@"1":@"2" forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.openBlock) {
                    self.openBlock(indexPath.row == 0 ? YES:NO);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    if (self.isLike) {//如果是展示成就设置
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"other" forKey:@"settingTag"];
        [parm setValue:self.setName forKey:@"settingName"];
        [parm setValue:indexPath.row == 0?@"1":@"0" forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.openBlock) {
                    self.openBlock(indexPath.row == 0 ? YES:NO);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    if ((self.isAll && indexPath.row == 0) || (!self.isAll && indexPath.row == 1)) {
        return;
    }
    if (self.type < 3) {
        [self showHUD];
    
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setValue:@"moodbook" forKey:@"settingTag"];
        [parm setValue:self.setName forKey:@"settingName"];
        [parm setValue:indexPath.row == 0?@"1":@"2" forKey:@"settingValue"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.openBlock) {
                    self.openBlock(indexPath.row == 0 ? YES:NO);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else{
        if (self.openBlock) {
            self.openBlock(indexPath.row == 0 ? YES:NO);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = _titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == ((self.isPy || self.isDraw) ? 2:1)) ? YES:NO;
    cell.subImageV.image = [UIImage imageNamed:@"setGou"];
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-10-15,(65 - 15*33/43)/2, 15, 15*33/43);

    if (self.isAll) {
        cell.subImageV.hidden = indexPath.row ? YES:NO;
    }else if (self.isAch){
        
        if (indexPath.row == 0) {
            cell.subImageV.hidden = self.isShowAch ? NO:YES;
        }else{
            cell.subImageV.hidden = !self.isShowAch ? NO:YES;
        }
    }else if (self.isLike){
        
        if (indexPath.row == 0) {
            cell.subImageV.hidden = self.isLiked ? NO:YES;
        }else{
            cell.subImageV.hidden = !self.isLiked ? NO:YES;
        }
    }
    else if(self.isPy || self.isDraw){
        cell.subImageV.hidden = YES;
        if ((self.pyType - 1) == indexPath.row) {
            cell.subImageV.hidden = NO;
        }
    }else if (self.isTab){
        if ([NoticeTools isFirstShowRoom] == indexPath.row) {
            cell.subImageV.hidden = NO;
        }else{
            cell.subImageV.hidden = YES;
        }
        cell.line.hidden = indexPath.row == 5 ? YES:NO;
    }
    else{
         cell.subImageV.hidden = indexPath.row ? NO:YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isTab) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    view.backgroundColor = GetColorWithName(VlistColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,DR_SCREEN_WIDTH-25, 40)];
    if (self.isTopic) {
        label.text = [NoticeTools isSimpleLau]?@"谁可以在『心情簿-关于』浏览我最喜欢的话题":@"誰可以在『心情簿-關於』瀏覽我最喜歡的話題";
    }else if (self.isAch) {
        label.text = @"展示我的成就";
    }else if (self.isPy) {
        label.text = [NoticeTools getTextWithSim:@"谁可以在心情簿看我的配音" fantText:@"誰可以在心情簿看我的配音"];
    }else if (self.isLike){
        label.text = [NoticeTools getTextWithSim:@"点亮非学友心情时展示自己的信息" fantText:@"點亮非学友心情時展示自己的信息"];
    }else if (self.isDraw) {
        label.text = [NoticeTools getTextWithSim:@"谁可以在心情簿看我的作品" fantText:@"誰可以在心情簿看我的作品"];
    }
    else{
        NSArray *arr =  [NoticeTools isSimpleLau]?@[@"谁可以看我的电影心情、看过、想看",@"谁可以看我的书籍心情、读过、想读",@"谁可以看我的音乐心情、听过、想听",@"谁可以看我到设置的话题"]:@[@"誰可以看我的電影心情、看過、想看",@"誰可以看我的書籍心情、讀過、想讀",@"誰可以看我的音乐心情、聽過、想聽",@"誰可以看我到設置的話題"];
        label.text = arr[self.type];
    }
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isTab) {
        return 0;
    }
    return 40;
}

@end
