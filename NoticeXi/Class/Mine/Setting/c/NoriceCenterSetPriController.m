//
//  NoriceCenterSetPriController.m
//  NoticeXi
//
//  Created by li lei on 2019/12/27.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoriceCenterSetPriController.h"
#import "NoticeNewPrivacySetController.h"
#import "NoticeNoticenterModel.h"
#import "NoticePrivacySetViewController.h"
#import "NoticeMBSViewController.h"
#import "NoticeSetLikeTopicController.h"
@interface NoriceCenterSetPriController ()
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@end

@implementation NoriceCenterSetPriController
{
    UIImageView *_imgV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VlistColor);
    self.navigationItem.title = [NoticeTools getTextWithSim:@"心情簿隐私设置" fantText:@"心情簿隱私設置"];
    
    self.titArr = @[[NoticeTools getTextWithSim:@"封面迷你时光机" fantText:@"封面迷妳時光機"],@"不是学友可以看最近多少天的心情",[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"movie.mymoveie"] fantText:@"我的電影"],[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"book.myshuji"] fantText:@"我的書籍"],[NoticeTools isSimpleLau]?@"我的音乐":@"我的音乐",[NoticeTools getLocalStrWith:@"py.mypy"],[NoticeTools getLocalStrWith:@"hh.myhua"],[NoticeTools getTextWithSim:@"对心情簿参观者展示信息流" fantText:@"對心情簿參觀者展示信息流"],[NoticeTools getTextWithSim:@"最喜欢的话题设置" fantText:@"最喜歡的話題設置"]];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(GET_STRWIDTH(@"封面迷你时光机", 14, 14)+20,(65-20)/2, 20, 20)];
    imgV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_fmsgj":@"Image_fmsgjy");
    _imgV = imgV;
    [self requestData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {//迷你时光机设置
        NoticeNewPrivacySetController *ctl = [[NoticeNewPrivacySetController alloc] init];
        ctl.type = 0;
        ctl.isOpen = self.noticeM.minimachine_visibility.integerValue == 2?YES:NO;
        ctl.openBlock = ^(BOOL open) {
              if (open) {
                  weakSelf.noticeM.minimachine_visibility = @"2";
              }else{
                  weakSelf.noticeM.minimachine_visibility = @"1";
              }
              [weakSelf.tableView reloadData];
          };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 1){
        NoticePrivacySetViewController *ctl = [[NoticePrivacySetViewController alloc] init];
        ctl.titArr = @[Localized(@"privacy.no"),Localized(@"privacy.seven"),@"最近三十天",[NoticeTools getLocalStrWith:@"py.allPy"]];
        ctl.boolStr = self.noticeM.strange_view;
        ctl.tag = 2;
        ctl.prisetBlock = ^(NSString * _Nonnull pri) {
            weakSelf.noticeM.strange_view = pri;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row >1 && indexPath.row < 5){
        NoticeMBSViewController *ctl = [[NoticeMBSViewController alloc] init];
        ctl.type = indexPath.row-2;
        if (indexPath.row == 2) {
            ctl.setName = @"movie_voice_visibility";
            ctl.isAll = self.noticeM.movie_voice_visibility.integerValue == 2 ?NO:YES;
            ctl.openBlock = ^(BOOL open) {
                if (open) {
                    weakSelf.noticeM.movie_voice_visibility = @"1";
                }else{
                    weakSelf.noticeM.movie_voice_visibility = @"2";
                }
                [weakSelf.tableView reloadData];
            };
        }else if (indexPath.row == 3){
            ctl.setName = @"book_voice_visibility";
            ctl.isAll = self.noticeM.book_voice_visibility.integerValue == 2 ?NO:YES;
            ctl.openBlock = ^(BOOL open) {
                if (open) {
                    weakSelf.noticeM.book_voice_visibility = @"1";
                }else{
                    weakSelf.noticeM.book_voice_visibility = @"2";
                }
                [weakSelf.tableView reloadData];
            };
        }else if (indexPath.row == 4){
            ctl.setName = @"song_voice_visibility";
            ctl.isAll = self.noticeM.song_voice_visibility.integerValue == 2 ?NO:YES;
            ctl.openBlock = ^(BOOL open) {
                if (open) {
                    weakSelf.noticeM.song_voice_visibility = @"1";
                }else{
                    weakSelf.noticeM.song_voice_visibility = @"2";
                }
                [weakSelf.tableView reloadData];
            };
        }
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 7){
        NoticeNewPrivacySetController *ctl = [[NoticeNewPrivacySetController alloc] init];
        ctl.type = 1;
        ctl.isOpen = self.noticeM.share_voice_visibility.integerValue == 1 ? NO:YES;
        ctl.openBlock = ^(BOOL open) {
            if (open) {
                weakSelf.noticeM.share_voice_visibility = @"2";
            }else{
                weakSelf.noticeM.share_voice_visibility = @"1";
            }
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 8){
        NoticeSetLikeTopicController *ctl = [[NoticeSetLikeTopicController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 5){
        NoticeMBSViewController *ctl = [[NoticeMBSViewController alloc] init];
        ctl.setName = @"dubbing_visibility";
        ctl.pyType = self.noticeM.dubbing_visibility.intValue;
        ctl.isPy = YES;
        ctl.pyBlock = ^(NSInteger pySet) {
            self.noticeM.dubbing_visibility = [NSString stringWithFormat:@"%ld",pySet];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 6){
        NoticeMBSViewController *ctl = [[NoticeMBSViewController alloc] init];
        ctl.setName = @"artwork_visibility";
        ctl.pyType = self.noticeM.artwork_visibility.intValue;
        ctl.isDraw = YES;
        ctl.pyBlock = ^(NSInteger pySet) {
            self.noticeM.artwork_visibility = [NSString stringWithFormat:@"%ld",pySet];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)requestData{

    [self showHUD];
    self.noticeM = [[NoticeNoticenterModel alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=moodbook",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            //设置默认值，防止服务器未有返回
            self.noticeM.minimachine_visibility = @"1";
            self.noticeM.strange_view = @"7";
            self.noticeM.movie_voice_visibility = @"1";
            self.noticeM.book_voice_visibility = @"1";
            self.noticeM.song_voice_visibility = @"1";
            self.noticeM.share_voice_visibility = @"2";
            self.noticeM.dubbing_visibility = @"1";
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                if ([setM.setting_name isEqualToString:@"minimachine_visibility"]) {//封面迷你时光机
                    self.noticeM.minimachine_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"voice_visible_days"]){//谁可见学友
                    self.noticeM.strange_view = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"movie_voice_visibility"]){//电影可见性
                    self.noticeM.movie_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"book_voice_visibility"]){//书籍可见性
                    self.noticeM.book_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"song_voice_visibility"]){//歌曲可见性
                    self.noticeM.song_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"share_voice_visibility"]){//共享心情可见性
                    self.noticeM.share_voice_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"dubbing_visibility"]){//配音可见性
                    self.noticeM.dubbing_visibility = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"artwork_visibility"]){//配音可见性
                    self.noticeM.artwork_visibility = setM.setting_value;
                }
            }
            [NoticeComTools saveSetCacha:self.noticeM.strange_view];
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=other&settingName=achievement_visibility",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.noticeM.achievement_visibility = setM.setting_value;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    cell.subL.text = @"";
    if (indexPath.row == 0) {
        [_imgV removeFromSuperview];
        [cell.contentView addSubview:_imgV];
         cell.subL.text = self.noticeM.minimachine_visibility.integerValue == 2? [NoticeTools getTextWithSim:@"不是学友也能看见" fantText:@"不是室友也能看見"]:[NoticeTools getTextWithSim:@"仅自己和室友可见" fantText:@"僅自己和室友可見"];
    }else if(indexPath.row == 1){
        cell.subL.text = self.noticeM.lookWithName;
    }else if (indexPath.row == 2){
        cell.subL.text = self.noticeM.movie_voice_visibility.integerValue == 2 ? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人";
    }else if (indexPath.row == 3){
        cell.subL.text = self.noticeM.book_voice_visibility.integerValue == 2 ? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人";
    }else if (indexPath.row == 4){
        cell.subL.text = self.noticeM.song_voice_visibility.integerValue == 2 ? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人";
    }else if (indexPath.row == 5){
        cell.subL.text = self.noticeM.dubbing_visibility.integerValue == 3 ? [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"n.onlyself"] fantText:@"僅自己可見"]:(self.noticeM.dubbing_visibility.intValue == 2? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人");
    }else if (indexPath.row == 6){
        cell.subL.text = self.noticeM.artwork_visibility.integerValue == 3 ? [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"n.onlyself"] fantText:@"僅自己可見"]:(self.noticeM.artwork_visibility.intValue == 2? ([NoticeTools isSimpleLau]?@"仅限学友":@"僅限学友"):@"所有人");
    }
    else if (indexPath.row == 7){
        cell.subL.text = self.noticeM.share_voice_visibility.integerValue == 1 ? [NoticeTools getTextWithSim:@"什么都不展示" fantText:@"什麽都不展示"]:[NoticeTools getTextWithSim:@"过往共享心情" fantText:@"過往共享心情"];
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return  self.titArr.count;
}

@end
