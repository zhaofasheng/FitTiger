//
//  NoticeHandAddBookController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHandAddBookController.h"
#import "NoticeTitleAndImageCell.h"
#import "NoticeAddMovieNameController.h"
#import "NoticeAddMovieTypeController.h"
#import "NoticeBookDetailController.h"
#import "NoticeScanBookController.h"
#import "NoticeBookBaseController.h"
#import "NoticeSacnModel.h"
@interface NoticeHandAddBookController ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *artName;
@property (nonatomic, strong) UIImage *bookImage;
@property (nonatomic, strong) NSString *bookNameUp;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSArray *addArr;
@property (nonatomic, strong) NSString *booIntro;
@property (nonatomic, strong) NSString *bookIntroUp;
@property (nonatomic, strong) NSString *iamgeUrl;
@end

@implementation NoticeHandAddBookController
{
    NSArray *_mainArr;
}

- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, GET_STRWIDTH([NoticeTools getLocalType]?@"Cancel":@"取消    ", 16, 40)+15, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
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
    self.navigationItem.title = self.isEdit?@"管理员编辑词条" : [NoticeTools getLocalStrWith:@"movie.shoudongaddbook"];
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    _mainArr = @[[NoticeTools getLocalStrWith:@"book.bookname"],[NoticeTools getLocalStrWith:@"movie.fm"],[NoticeTools getLocalStrWith:@"book.zuozhe"]];
 
    self.bookName = self.artName = self.booIntro = @"";
    _infoArr = @[[NoticeTools getLocalStrWith:@"movie.noadd"],[NoticeTools getLocalStrWith:@"movie.noadd"]];
    _addArr = @[self.bookName,self.artName];
    if (self.isEdit) {
        self.bookNameUp = self.book.book_name;
        self.artName = self.book.book_author;
        self.bookName = [NoticeTools getLocalStrWith:@"movie.aladd"];
        _mainArr = @[@"书名",@"书籍封面",@"作者",[NoticeTools getLocalStrWith:@"book.jianjie"]];
        if (self.book.book_intro.length) {
            self.booIntro = [NoticeTools getLocalStrWith:@"movie.aladd"];
            self.bookIntroUp = self.book.book_intro;
        }
        _addArr = @[self.bookName,self.artName,self.booIntro];
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
    
    if (!self.isEdit) {
   
        UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-56, 240, 56)];
        scanBtn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        scanBtn.layer.cornerRadius = 28;
        scanBtn.layer.masksToBounds = YES;
        [scanBtn setTitle:[NoticeTools getLocalStrWith:@"book.ISBN"] forState:UIControlStateNormal];
        [scanBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        scanBtn.titleLabel.font = XGTwentyBoldFontSize;
        [scanBtn addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanBtn];
  
    }
}

- (void)deleClick{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定删除词条吗？" sureBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/resource/2/%@",self.book.bookId] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
    if (self.bookIntroUp.length > 100) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"book.fail1"]];
        return;
    }
    if (self.bookNameUp.length > 100) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"book.fail2"]];
        return;
    }
    if (self.isEdit) {
        [self editClick];
        return;
    }
    self.imgPath =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999]]];//音频本地路径转换为md5字符串
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.checktosta"]:@"確定發布詞條嗎?\n(發布後就不能再次編輯啦)" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.rechecke"]:@"再檢查下" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            weakSelf.sendBtn.enabled = NO;
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"16" forKey:@"resourceType"];
            [parm setObject:weakSelf.imgPath forKey:@"resourceContent"];
            [weakSelf showHUD];
            if (!self.bookImage) {
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"book.fail3"]];
                return ;
            }
            [[XGUploadDateManager sharedManager] uploadImageWithImage:self.bookImage parm:parm progressHandler:^(CGFloat progress) {
                
            } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
                [self hideHUD];
                if (sussess) {
                    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                    [parm setObject:Message forKey:@"bookCoverUri"];
                    [parm setObject:weakSelf.bookNameUp forKey:@"bookName"];
                    [parm setObject:weakSelf.artName forKey:@"bookAuthor"];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/entries/2",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                        if (success) {
                            NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
                            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                            ctl.isFromAdd = YES;
                            ctl.bookId = model.resource_id;
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
        url = [NSString stringWithFormat:@"admin/entries/%@",self.book.bookId];
    }else{
        url = [NSString stringWithFormat:@"admin/resource/2/%@",self.book.bookId];
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.passCode forKey:@"confirmPasswd"];
    _sendBtn.enabled = NO;
    if (![self.bookIntroUp isEqualToString:self.book.book_intro]) {
        [parm setObject:self.bookIntroUp forKey:@"bookIntro"];
    }
    if (![self.bookNameUp isEqualToString:self.book.book_name]) {
        [parm setObject:self.bookNameUp forKey:@"bookName"];
    }
    if (![self.artName isEqualToString:self.book.book_author]) {
        [parm setObject:self.artName forKey:@"bookAuthor"];
    }
    [self showHUD];
    if (!self.bookImage) {
        [self editWithUrl:url parm:parm];
        return;
    }
    
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"16" forKey:@"resourceType"];
    [parm1 setObject:self.imgPath forKey:@"resourceContent"];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.bookImage parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        [self hideHUD];
        if (sussess) {
            [parm setObject:Message forKey:@"bookCoverUri"];
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

- (void)scanClick{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        [self showToastWithText:@"您没有开启相机权限，请到设置里面开启相机权限"];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self gotoScan];
                });
            }
        }];
    } else {
        [self gotoScan];
    }

    
 
}

- (void)gotoScan{
    NoticeScanBookController *ctl = [[NoticeScanBookController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.addBookBlock = ^(NoticeScanResult * _Nonnull scanModel) {
        weakSelf.bookNameUp = scanModel.title;
        weakSelf.bookName = scanModel.title;
        weakSelf.artName = scanModel.author;
        weakSelf.iamgeUrl = scanModel.images_large;
        weakSelf.addArr = @[self.bookName,self.artName,self.booIntro];
        weakSelf.sendBtn.enabled = YES;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
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
        ctl.movieName = self.bookNameUp;
        ctl.type = 1;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.bookNameUp = name;
                weakSelf.bookName = name;
            }else{
                weakSelf.bookNameUp = @"";
                weakSelf.bookName = @"";
            }
            if (weakSelf.isEdit) {
                weakSelf.addArr = @[self.bookName,self.artName,self.booIntro];
            }else{
                weakSelf.addArr = @[self.bookName,self.artName];
            }
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 2){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.artName;
        ctl.type = 6;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.artName = name;
            }else{
                weakSelf.artName = @"";
            }
            if (weakSelf.isEdit) {
                weakSelf.addArr = @[self.bookName,self.artName,self.booIntro];
            }else{
                weakSelf.addArr = @[self.bookName,self.artName];
            }
            
            [weakSelf.tableView reloadData];
        };
        
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 3){
        NoticeAddMovieNameController *ctl = [[NoticeAddMovieNameController alloc] init];
        ctl.movieName = self.bookIntroUp;
        ctl.type = 9;
        ctl.movieNameBlock = ^(NSString * _Nonnull name) {
            if (name && name.length) {
                weakSelf.bookIntroUp = name;
                weakSelf.booIntro = name;
            }else{
                weakSelf.bookIntroUp = @"";
                weakSelf.booIntro = @"";
            }
            if (weakSelf.isEdit) {
                weakSelf.addArr = @[self.bookName,self.artName,self.booIntro];
            }else{
                weakSelf.addArr = @[self.bookName,self.artName];
            }
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
    self.iamgeUrl = nil;
    self.bookImage = image;
   
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
    if (indexPath.row == 0) {
        cell.subL.text = [_addArr[0] length]?_addArr[0]: _infoArr[0];
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }else if (indexPath.row == 2){
        cell.subL.text = [_addArr[1] length]?_addArr[1]: _infoArr[1];
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }else if (indexPath.row == 3){
        cell.subL.text = [_addArr[2] length]?_addArr[2]: _infoArr[2];
        cell.subL.textColor = [cell.subL.text isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]?[UIColor colorWithHexString:@"#ACB3BF"]:[UIColor colorWithHexString:@"#FFFFFF"];
    }

    else if (indexPath.row == 1){
        cell.leftImageV.frame = CGRectMake(CGRectGetMaxX(cell.mainL.frame)+10, 23/2, 30, 42);
        cell.leftImageV.layer.cornerRadius = 5;
        cell.leftImageV.layer.masksToBounds = YES;
        if (self.bookImage) {
            cell.leftImageV.image = self.bookImage;
            cell.subL.text = @"";
            if (self.iamgeUrl){
                [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.iamgeUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    self.bookImage = image;
                }];
            }
        }else{
            if (self.isEdit) {
                [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.book.book_cover]
                                   placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                            options:SDWebImageRefreshCached];

                cell.subL.text = @"";
            }else if (self.iamgeUrl){
                [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.iamgeUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    self.bookImage = image;
                }];
                cell.subL.text = @"";
            }
            else{
                cell.subL.text = [NoticeTools getLocalStrWith:@"movie.noadd"];
            }
        }
    }
    if (self.isEdit) {
        if (self.bookNameUp.length && self.artName.length && self.bookIntroUp.length) {
            if ([self.bookIntroUp isEqualToString:self.book.book_intro] && [self.bookNameUp isEqualToString:self.book.book_name] && [self.artName isEqualToString:self.book.book_author] && !self.bookImage) {
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
        if ((self.bookImage || self.iamgeUrl) && self.bookNameUp.length && self.artName.length) {
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
