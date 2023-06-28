//
//  NoticeHandAddSongController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHandAddSongController.h"
#import "NoticeTitleAndImageCell.h"
#import "NoticeAddMovieNameController.h"
#import "NoticeAddMovieTypeController.h"
#import "NoticeMusicBaseController.h"
#import "NoticeSongDetailController.h"
@interface NoticeHandAddSongController ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *songNameUp;//具体电影名称
@property (nonatomic, strong) NSString *artName;
@property (nonatomic, strong) NSString *artNameUp;
@property (nonatomic, strong) UIImage *songImage;
@property (nonatomic, strong) NSString *zjName;
@property (nonatomic, strong) NSString *zjNameUp;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSArray *infoArr;

@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSArray *addArr;
@end

@implementation NoticeHandAddSongController
{
    NSArray *_mainArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-65, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2,70, 25);
    [btn setTitle:[NoticeTools getLocalType]?@"Publish":@"发布词条" forState:UIControlStateNormal];
    [btn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn = btn;
    _sendBtn.enabled = NO;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.tableView.rowHeight = 65;
    self.navigationItem.title =[NoticeTools getLocalType]?@"Add entries": @"添加歌曲";
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    _mainArr = @[[NoticeTools getLocalStrWith:@"movie.fm"],[NoticeTools getLocalStrWith:@"music.songname"],[NoticeTools getLocalStrWith:@"music.songges"],[NoticeTools getLocalStrWith:@"music.zhuanji"]];
    
    self.songName = self.artName = self.zjName = @"";
    if (self.isEdit) {
        self.songNameUp = self.song.song_name;
        self.artNameUp = self.song.song_singer;
        self.zjNameUp = self.song.album_name;
        self.songName = self.artName = self.zjName = [NoticeTools getLocalStrWith:@"movie.aladd"];
    }
    _infoArr = @[[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"]];
    self.addArr = @[self.songName,self.artName,self.zjName];
    
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
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定删除词条吗？" sureBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/resource/2/%@",self.song.albumId] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
        [self editClick];
        return;
    }
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.checktosta"]:@"確定發布詞條嗎?\n(發布後就不能再次編輯啦)" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.rechecke"]:@"再檢查下" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            weakSelf.sendBtn.enabled = YES;
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"17" forKey:@"resourceType"];
            [parm setObject:weakSelf.imgPath forKey:@"resourceContent"];
            [weakSelf showHUD];
            
            [[XGUploadDateManager sharedManager] uploadImageWithImage:self.songImage parm:parm progressHandler:^(CGFloat progress) {
                
            } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
                [self hideHUD];
                if (sussess) {
                    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                    [parm setObject:Message forKey:@"songCoverUri"];
                    if (weakSelf.zjNameUp) {
                        [parm setObject:weakSelf.zjNameUp forKey:@"albumName"];
                    }
                    [parm setObject:weakSelf.songNameUp forKey:@"songName"];
                    [parm setObject:weakSelf.artNameUp forKey:@"songSinger"];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/entries/3",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                        if (success) {
                            NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
                            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                            ctl.isFromAdd = YES;
                            ctl.songId = model.resource_id;
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

- (void)editClick{
    NSString *url = nil;
    if (self.isFromMangerM) {//判断是否是编辑用户添加的词条
        url = [NSString stringWithFormat:@"admin/entries/%@",self.song.albumId];
    }else{
        url = [NSString stringWithFormat:@"admin/resource/3/%@",self.song.albumId];
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.passCode forKey:@"confirmPasswd"];
    _sendBtn.enabled = NO;

    if (![self.songNameUp isEqualToString:self.song.song_name]) {
        [parm setObject:self.songNameUp forKey:@"songName"];
    }
    if (![self.artNameUp isEqualToString:self.song.song_singer]) {
        [parm setObject:self.artNameUp forKey:@"songSinger"];
    }
    if (![self.zjNameUp isEqualToString:self.song.album_name]) {
        [parm setObject:self.zjNameUp forKey:@"albumName"];
    }
    [self showHUD];
    if (!self.songImage) {
        [self editWithUrl:url parm:parm];
        return;
    }
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"17" forKey:@"resourceType"];
    [parm1 setObject:self.imgPath forKey:@"resourceContent"];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.songImage parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        [self hideHUD];
        if (sussess) {
            [parm setObject:Message forKey:@"songCoverUri"];
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
    if (indexPath.row == 0) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)/2,DR_SCREEN_WIDTH,DR_SCREEN_WIDTH);
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if (indexPath.row == 1){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.songNameUp;
        ctl.type = 2;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.songNameUp = name;
                weakSelf.songName = name;
            }else{
                weakSelf.songNameUp = @"";
                weakSelf.songName = @"";
            }
            weakSelf.addArr = @[self.songName,self.artName,self.zjName];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 2){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.artNameUp;
        ctl.type = 3;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.artNameUp = name;
                weakSelf.artName = name;
            }else{
                weakSelf.artNameUp = @"";
                weakSelf.artName = @"";
            }
            weakSelf.addArr = @[self.songName,self.artName,self.zjName];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 3){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.zjNameUp;
        ctl.type = 4;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.zjNameUp = name;
                weakSelf.zjName = name;
            }else{
                weakSelf.zjNameUp = @"";
                weakSelf.zjName = @"";
            }
            weakSelf.addArr = @[self.songName,self.artName,self.zjName];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
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
    self.songImage = image;
    
    [self.tableView reloadData];
    self.imgPath =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = _mainArr[indexPath.row];
    cell.line.hidden = (indexPath.row==_mainArr.count-1)? YES:NO;
    cell.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    cell.mainL.frame = CGRectMake(20, 0, GET_STRWIDTH(cell.mainL.text, 15, 64)+10, 65);
    cell.line.frame = CGRectMake(20, 64, DR_SCREEN_WIDTH-20, 1);
    cell.subImageV.image = UIImageNamed(@"Image_subinto");
    cell.subImageV.frame = CGRectMake(DR_SCREEN_WIDTH-20-24, 41/2, 24, 24);
    cell.subL.frame = CGRectMake(CGRectGetMaxX(cell.mainL.frame)+10, 0,200, 65);
    cell.subL.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row > 0) {
        cell.subL.text = [_addArr[indexPath.row-1] length]?_addArr[indexPath.row-1]: _infoArr[indexPath.row-1];
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }else if (indexPath.row == 0){
        cell.leftImageV.frame = CGRectMake(CGRectGetMaxX(cell.mainL.frame)+10, 23/2, 30, 42);
        cell.leftImageV.layer.cornerRadius = 5;
        cell.leftImageV.layer.masksToBounds = YES;
        if (self.songImage) {
            cell.leftImageV.image = self.songImage;
            cell.subL.text = @"";
        }else{
            if (self.isEdit) {
                [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.song.song_cover]
                                   placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                            options:SDWebImageRefreshCached];
                cell.subL.text = @"";
            }else{
                cell.subL.text = [NoticeTools getLocalStrWith:@"movie.noadd"];
            }
        }
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }
    if (self.isEdit) {
        if (self.songNameUp.length && self.artNameUp.length && self.zjNameUp.length) {
            if ([self.songNameUp isEqualToString:self.song.song_name] && [self.artNameUp isEqualToString:self.song.song_singer] && [self.zjNameUp isEqualToString:self.song.album_name] && !self.songImage) {//判断是否更改过
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
        if (self.songImage && self.songNameUp.length && self.artNameUp.length) {
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
