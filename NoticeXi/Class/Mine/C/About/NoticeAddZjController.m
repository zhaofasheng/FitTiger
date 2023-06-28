//
//  NoticeAddZjController.m
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddZjController.h"
#import "NoticeAddMovieNameController.h"
#import "NoticeZJSelectSetController.h"
@interface NoticeAddZjController ()<TZImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) NSString *zjType;
@property (nonatomic, strong) UIImage *zjImage;
@property (nonatomic, strong) NSArray *mainArr;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *selectType;
@property (nonatomic, assign) BOOL hasCHange;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UISwitch* switchButton;
@property (nonatomic, strong) UITextField *nameField;
@end

@implementation NoticeAddZjController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//开启右滑返回
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = self.isDiaAblum?[NoticeTools getLocalStrWith:@"zj.editduihzj"]: [NoticeTools getLocalStrWith:@"zj.editzj"];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(3, STATUS_BAR_HEIGHT,60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn1 setTitle:[NoticeTools getLocalType]?@"Cancel": @"取消" forState:UIControlStateNormal];
    if ([NoticeTools getLocalType] == 2) {
        [btn1 setTitle:@"取消    " forState:UIControlStateNormal];
    }
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [btn1 setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    btn1.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn1];
    self.navBarView.backButton.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-3-50, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [btn setTitle:[NoticeTools getLocalType]?@"Save":@"确认" forState:UIControlStateNormal];
    if ([NoticeTools getLocalType] == 2) {
        [btn setTitle:@"保存" forState:UIControlStateNormal];
    }
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];
    _finishBtn = btn;
    if (!self.isEditAblum) {
        _finishBtn.enabled = NO;
    }
    if (self.isEditAblum) {
        [_finishBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    }

    self.selectType = self.zjmodel.addType;
    _mainArr = self.isDiaAblum? @[[NoticeTools getLocalStrWith:@"zj.bt"],[NoticeTools getLocalStrWith:@"zj.fm"]]:@[[NoticeTools getLocalStrWith:@"zj.bt"],[NoticeTools getLocalStrWith:@"zj.fm"],[NoticeTools getLocalStrWith:@"zj.gk"]];
    
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 56;
    
    UISwitch* switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-44,16,44,24)];
    _switchButton = switchButton;
    _switchButton.onTintColor = [UIColor colorWithHexString:@"#0099E6"];
    [switchButton addTarget:self action:@selector(changeOnVale:) forControlEvents:UIControlEventValueChanged];
    [switchButton setOn:self.zjmodel.album_type.intValue == 1?YES:NO];
    switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(86,0,DR_SCREEN_WIDTH-86-20-40, 55)];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"zj.inputname"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5C5F66"]}];
    self.nameField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    self.nameField.font = FOURTHTEENTEXTFONTSIZE;
    self.nameField.text = self.zjmodel.album_name;
    self.nameField.delegate = self;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.nameField.backgroundColor = [self.tableView.backgroundColor colorWithAlphaComponent:0];
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.isEditAblum) {
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-305)/2, DR_SCREEN_HEIGHT-50-BOTTOM_HEIGHT-40-NAVIGATION_BAR_HEIGHT, 305, 50)];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        deleteBtn.layer.cornerRadius = 25; 
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        deleteBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [self.view addSubview:deleteBtn];
    }
}


- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NoticeTitleAndImageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (_field.text.length <= 20) {
        cell.subL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }else{
        cell.subL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    }
    cell.subL.text = [NSString stringWithFormat:@"%ld",_field.text.length];
    [_finishBtn setTitleColor:[UIColor colorWithHexString:_field.text.length?@"#0099E6": @"#5C5F66"] forState:UIControlStateNormal];
}

- (void)changeOnVale:(UISwitch *)switchbutton{
    
    if (switchbutton.isOn) {
        self.zjmodel.album_type = @"1";
    }else{
        self.zjmodel.album_type = @"3";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-DR_SCREEN_WIDTH)/2,DR_SCREEN_WIDTH,DR_SCREEN_WIDTH);
        [self presentViewController:imagePicker animated:YES completion:nil];
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
            filePath = [NSString stringWithFormat:@"%@-%u",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99098999];
            [self upLoadHeader:choiceImage path:filePath];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    self.hasCHange = YES;
    self.zjImage = image;
    [self.tableView reloadData];
    self.imgPath = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = _mainArr[indexPath.row];
    cell.subL.hidden = YES;
    cell.leftImageV.hidden = YES;
    cell.subImageV.hidden = YES;
    [_switchButton removeFromSuperview];
    if (indexPath.row == 0) {
        [self.nameField removeFromSuperview];
        [cell.contentView addSubview:self.nameField];
        cell.subL.hidden = NO;
    }else if (indexPath.row == 1){
        cell.leftImageV.hidden = NO;
        cell.subImageV.hidden = NO;
        if (self.zjImage) {
            cell.leftImageV.image = self.zjImage;
        }else{
            [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.zjmodel.album_cover_url]
                            placeholderImage:UIImageNamed(@"Image_addzjdefault")
                                     options:SDWebImageRefreshCached];
        }
    }else{
        [cell.contentView addSubview:_switchButton];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainArr.count;
}

- (void)fifinshClick{
    if (self.isEditAblum) {
        [self editZJ];
        return;
    }
}


- (void)editZJ{
    if (!self.nameField.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.inputname"]];
        return;
    }
    if (self.nameField.text.length > 20) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"zj.overnim"]];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self showHUD];
    if (!self.zjImage) {
        NSString *url = nil;
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.nameField.text forKey:@"albumName"];
        if (!self.isDiaAblum) {
            url = [NSString stringWithFormat:@"user/%@/voiceAlbum/%@",[[NoticeSaveModel getUserInfo] user_id],self.zjmodel.albumId];
            [parm setObject:self.zjmodel.album_type forKey:@"albumType"];
            
        }else{
            url = [NSString stringWithFormat:@"dialogAlbums/%@",self.zjmodel.albumId];
        }

        [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:self.isDiaAblum?@"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v3.8+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.zjmodel.album_name = self.nameField.text;
                if (self.editSuccessBlock) {
                    self.editSuccessBlock(self.zjmodel);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }else{
        NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
        [parm1 setObject:@"18" forKey:@"resourceType"];
        [parm1 setObject:self.imgPath forKey:@"resourceContent"];
        [self showHUD];
        self.finishBtn.enabled = NO;
        [[XGUploadDateManager sharedManager] uploadImageWithImage:self.zjImage parm:parm1 progressHandler:^(CGFloat progress) {
            
        } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
            
            if (sussess) {
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:Message forKey:@"albumCoverUri"];
                [parm setObject:self.nameField.text forKey:@"albumName"];
                NSString *url = nil;
                if (!self.isDiaAblum) {
                    [parm setObject:self.zjmodel.album_type forKey:@"albumType"];
                    url = [NSString stringWithFormat:@"user/%@/voiceAlbum/%@",[[NoticeSaveModel getUserInfo] user_id],self.zjmodel.albumId];
                }else{
                    url = [NSString stringWithFormat:@"dialogAlbums/%@",self.zjmodel.albumId];
                }
                
                [parm setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
                [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:self.isDiaAblum?@"application/vnd.shengxi.v4.3+json" : @"application/vnd.shengxi.v3.8+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [self hideHUD];
                    if (success) {
                        self.zjmodel.album_name = self.nameField.text;
                        self.zjmodel.image = self.zjImage;
                        if (self.editSuccessBlock) {
                            self.editSuccessBlock(self.zjmodel);
                        }
                        weakSelf.zjmodel.image = self.zjImage;
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                } fail:^(NSError *error) {
                    [self hideHUD];
                }];
            }else{
                [self hideHUD];
                self.finishBtn.enabled = YES;
                [self showToastWithText:Message];
            }
        }];
    }
}

- (void)deleteClick{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"zj.delthiszj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.del"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            
            [[DRNetWorking shareInstance] requestWithDeletePath:self.isDiaAblum?[NSString stringWithFormat:@"dialogAlbums/%@",self.zjmodel.albumId]: [NSString stringWithFormat:@"user/%@/voiceAlbum/%@",[NoticeTools getuserId],self.zjmodel.albumId] Accept:self.isDiaAblum?@"application/vnd.shengxi.v4.3+json": @"application/vnd.shengxi.v3.8+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    if (weakSelf.deleteSuccessBlock) {
                        weakSelf.deleteSuccessBlock(weakSelf.zjmodel);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                [weakSelf hideHUD];
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)backToPageAction{
    if (self.isEditAblum) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

@end
