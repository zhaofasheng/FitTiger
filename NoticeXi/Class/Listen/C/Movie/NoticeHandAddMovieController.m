//
//  NoticeHandAddMovieController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHandAddMovieController.h"
#import "NoticeTitleAndImageCell.h"
#import "NoticeAddMovieNameController.h"
#import "NoticeAddMovieTypeController.h"
#import "YZC_PickerView.h"
#import "NoticeMovieBaseController.h"
#import "NoticeVoiceListModel.h"
#import "NoticeMovieDetailViewController.h"
@interface NoticeHandAddMovieController ()<TZImagePickerControllerDelegate,pickerDelegate>
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *movieNameUp;//具体电影名称
@property (nonatomic, strong) NSString *movieTime;
@property (nonatomic, strong) NSString *movieType;
@property (nonatomic, strong) UIImage *movieImage;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) NSArray *addArr;
@property (nonatomic, strong) NSArray *mainArr;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *movieIntro;
@property (nonatomic, strong) NSString *movieIntroUp;

@end

@implementation NoticeHandAddMovieController

- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 45, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn1 setTitle:[NoticeTools getLocalType]?@"Cancel":@"取消    " forState:UIControlStateNormal];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    btn1.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0,45, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
    [btn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn = btn;
    _sendBtn.enabled = NO;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.tableView.frame = CGRectMake(0,20, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-20);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    self.navigationItem.title = self.isEdit?@"管理员编辑词条" : [NoticeTools getLocalStrWith:@"movie.tzdiancit"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    _mainArr = @[[NoticeTools getLocalStrWith:@"movie.nameym"],[NoticeTools getLocalStrWith:@"movie.fm"],[NoticeTools getLocalStrWith:@"movie.time"],[NoticeTools getLocalStrWith:@"movie.type"]];
    if (self.isEdit) {
        _mainArr = @[[NoticeTools getLocalStrWith:@"movie.nameym"],[NoticeTools getLocalStrWith:@"movie.fm"],@"上映时间 *",@"类别 *"];
    }
    self.movieName = self.movieTime = self.movieType = self.movieIntro = @"";
    if (self.isEdit) {
        self.movieNameUp = self.movie.movie_title;
        self.movieName = [NoticeTools getLocalStrWith:@"movie.aladd"];
        self.movieType = self.movie.movietype;
        self.movieTime = self.movie.released_at;
        self.movieIntroUp = self.movie.movie_intro;
        if (self.movieIntroUp.length && ![self.movieIntroUp isEqualToString:@"(null)"]) {
            self.movieIntro = [NoticeTools getLocalStrWith:@"movie.aladd"];
        }
        _addArr = @[self.movieName,self.movieTime?self.movieTime:@"",self.movieType?self.movieType:@"",self.movieIntro?self.movieIntro:@""];
        _infoArr = @[[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"]];
    }else{
        _addArr = @[self.movieName,self.movieTime,self.movieType];
        _infoArr = @[[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"]];
    }
    
    if ([NoticeTools isManager]) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-40-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 40)];
        [button setTitle:@"删除词条" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = GetColorWithName(VMainThumeColor);
        [self.view addSubview:button];
    }
}

- (void)deleClick{
    if (!self.movie.movie_id) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定删除词条吗？" sureBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/resource/1/%@",self.isFromMangerM?self.movie.movieListId : self.movie.movie_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    };
    
    [alerView showXLAlertView];
}
- (void)sendClick{
    if (self.isEdit) {
        [self editCito];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.checktosta"]:@"確定發布詞條嗎?\n(發布後就不能再次編輯啦)" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.rechecke"]:@"再檢查下" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"15" forKey:@"resourceType"];
            [parm setObject:weakSelf.imgPath forKey:@"resourceContent"];
            [weakSelf showHUD];
            weakSelf.sendBtn.enabled = NO;
            [[XGUploadDateManager sharedManager] uploadImageWithImage:self.movieImage parm:parm progressHandler:^(CGFloat progress) {
                
            } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
                [self hideHUD];
                if (sussess) {
                    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                    [parm setObject:Message forKey:@"movieCoverUri"];
                    [parm setObject:weakSelf.movieNameUp forKey:@"movieName"];
                    if (weakSelf.movieTime) {
                        [parm setObject:weakSelf.movieTime forKey:@"releasedDate"];
                    }
                    if (weakSelf.movieType) {
                        [parm setObject:weakSelf.movieType forKey:@"movieType"];
                    }
                    
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/entries/1",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                        if (success) {
                            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                            NoticeMovieDetailViewController *ctl = [[NoticeMovieDetailViewController alloc] init];
                            
                            ctl.isFromAdd = YES;
                            ctl.movieId = model.resource_id;
                            [self.navigationController pushViewController:ctl animated:YES];
              
                        }else{
                            weakSelf.sendBtn.enabled = YES;
                        }
                    } fail:^(NSError *error) {
                        weakSelf.sendBtn.enabled = YES;
                    }];
                }else{
                    weakSelf.sendBtn.enabled = YES;
                    [weakSelf showToastWithText:Message];
                }
            }];
        }
    };
    
    [alerView showXLAlertView];
}

- (void)editCito{
    NSString *url = nil;
    if (self.isFromMangerM) {//判断是否是编辑用户添加的词条
        url = [NSString stringWithFormat:@"admin/entries/%@",self.movie.movieListId];
    }else{
        url = [NSString stringWithFormat:@"admin/resource/1/%@",self.movie.movie_id];
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.passCode forKey:@"confirmPasswd"];
    _sendBtn.enabled = NO;
    if (![self.movieNameUp isEqualToString:self.movie.movie_title]) {
       [parm setObject:self.movieNameUp forKey:@"movieName"];
    }
    if (![self.movieTime isEqualToString:self.movie.released_at]) {
        [parm setObject:self.movieTime forKey:@"releasedDate"];
    }
    if (![self.movieType isEqualToString:self.movie.movietype]) {
        [parm setObject:self.movieType forKey:@"movieType"];
    }
    if (![self.movieIntroUp isEqualToString:self.movie.movie_intro]) {
        [parm setObject:self.movieIntroUp forKey:@"movieIntro"];
    }
    [self showHUD];
    if (!self.movieImage) {
        [self editWithUrl:url parm:parm];
        return;
    }
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"15" forKey:@"resourceType"];
    [parm1 setObject:self.imgPath forKey:@"resourceContent"];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.movieImage parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        [self hideHUD];
        if (sussess) {
            [parm setObject:Message forKey:@"movieCoverUri"];
            [weakSelf editWithUrl:url parm:parm];
        }else{
            weakSelf.sendBtn.enabled = YES;
            [weakSelf showToastWithText:Message];
        }
    }];
}

- (void)editWithUrl:(NSString *)url parm:(NSMutableDictionary *)parm{
    [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            self->_sendBtn.enabled = YES;
        }
    } fail:^(NSError *error) {
        self->_sendBtn.enabled = YES;
        [self hideHUD];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 1) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-3);
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if (indexPath.row == 0){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.movieNameUp;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.movieNameUp = name;
                weakSelf.movieName = name;
            }else{
                weakSelf.movieNameUp = @"";
                weakSelf.movieName = @"";
            }
            if (weakSelf.isEdit) {
                weakSelf.addArr = @[self.movieName,self.movieTime,self.movieType,self.movieIntro];
            }else{
                weakSelf.addArr = @[self.movieName,self.movieTime,self.movieType];
            }
            [weakSelf.tableView reloadData];
        };
         [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 2){
        YZC_PickerView * picker = [YZC_PickerView shared];//实例化选择框
        
        picker.delegate = self;//设置代理
        picker.pickerViewStyleType = YZCPickerViewStyleDateThree;
        //弹出
        [picker show];
    }
    else if (indexPath.row == 3){
        NoticeAddMovieTypeController *ctl = [[NoticeAddMovieTypeController alloc] init];
        ctl.movieType = self.movieType;
        ctl.movieTypeBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.movieType = name;
            }else{
                weakSelf.movieType = @"";
            }
            if (weakSelf.isEdit) {
                weakSelf.addArr = @[self.movieName,self.movieTime,self.movieType,self.movieIntro];
            }else{
                weakSelf.addArr = @[self.movieName,self.movieTime,self.movieType];
            }
            
            [weakSelf.tableView reloadData];
        };
         [self.navigationController pushViewController:ctl animated:YES];
    }
    else if (indexPath.row == 4){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.movieIntroUp;
        ctl.type = 9;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.movieIntroUp = name;
                weakSelf.movieIntro = name;
            }else{
                weakSelf.movieIntroUp = @"";
                weakSelf.movieIntro = @"";
            }
            weakSelf.addArr = @[self.movieName,self.movieTime,self.movieType,self.movieIntro];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)backWeakPickerView:(UIPickerView *)picker year:(NSInteger)nowyear style:(YZCPickerViewStyleType)pickerStyle{
    NSInteger year = [picker selectedRowInComponent:0]+ BEGINYEAR;
    NSInteger month = [picker selectedRowInComponent:1]+1;
    NSInteger day = [picker selectedRowInComponent:2]+1;
    
    NSString *date = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)year,(long)month,(long)day];
    self.movieTime = date;
    if (self.isEdit) {
        self.addArr = @[self.movieName,self.movieTime,self.movieType,self.movieIntro];
    }else{
        self.addArr = @[self.movieName,self.movieTime,self.movieType];
    }
    
    [self.tableView reloadData];
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
            [self upLoadHeader:choiceImage path:filePath];
        }else{
            [self upLoadHeader:choiceImage path:filePath];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    self.movieImage = image;
    
    [self.tableView reloadData];
    self.imgPath =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = _mainArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    cell.mainL.frame = CGRectMake(20, 0, GET_STRWIDTH(cell.mainL.text, 15, 64)+10, 65);
    cell.line.frame = CGRectMake(20, 64, DR_SCREEN_WIDTH-20, 1);
    cell.subImageV.image = UIImageNamed(@"Image_subinto");
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-20-24, 41/2, 24, 24);
    cell.subL.frame = CGRectMake(CGRectGetMaxX(cell.mainL.frame)+10, 0,200, 65);
    cell.subL.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row != 1) {
        if (indexPath.row == 0) {
            cell.subL.text = [_addArr[0] length]?_addArr[0]: _infoArr[0];
        }else if (indexPath.row == 2){
            cell.subL.text = [_addArr[1] length]?_addArr[1]: _infoArr[1];
        }else{
            cell.subL.text = [_addArr[2] length]?_addArr[2]: _infoArr[2];
        }
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }else if (indexPath.row == 1){
        cell.leftImageV.frame = CGRectMake(CGRectGetMaxX(cell.mainL.frame)+10, 23/2, 30, 42);
        cell.leftImageV.layer.cornerRadius = 5;
        cell.leftImageV.layer.masksToBounds = YES;
        if (self.movieImage) {
            cell.leftImageV.image = self.movieImage;
            cell.subL.text = @"";
        }else{
            if (self.isEdit) {
                [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.movie.movie_poster]
                                  placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                           options:SDWebImageRefreshCached];
                cell.subL.text = @"";
            }else{
              cell.subL.text = [NoticeTools getLocalStrWith:@"movie.noadd"];
            }
        }
    }
    
    if (self.isEdit) {
        if (self.movieNameUp.length && self.movieTime.length && self.movieType.length && self.movieIntroUp.length) {
            if ([self.movieIntroUp isEqualToString:self.movie.movie_intro] && [self.movieNameUp isEqualToString:self.movie.movie_title] && [self.movieTime isEqualToString:self.movie.released_at] && [self.movieType isEqualToString:self.movie.movietype] && !self.imgPath) {//判断是否更改过
                [_sendBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
                _sendBtn.enabled = NO;
            }else{
                [_sendBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
                _sendBtn.enabled = YES;
            }
        }else{
            [_sendBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
            _sendBtn.enabled = NO;
        }
    }else{
        if (self.movieImage && self.movieNameUp.length) {
            [_sendBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
            _sendBtn.enabled = YES;
        }else{
            [_sendBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
            _sendBtn.enabled = NO;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _mainArr.count;
}

@end
