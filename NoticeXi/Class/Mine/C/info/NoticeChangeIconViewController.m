//
//  NoticeChangeIconViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeIconViewController.h"
#import "YYImageCoder.h"
@interface NoticeChangeIconViewController ()<TZImagePickerControllerDelegate>
@property (strong, nonatomic)  UIImageView *headeimageView;

@end

@implementation NoticeChangeIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headeimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-DR_SCREEN_WIDTH)/2-30, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    [self.view addSubview:self.headeimageView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"intro.tx"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(34,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-40-NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH-78-50, 50);
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [btn setTitle:[NoticeTools getLocalStrWith:@"intro.changetx"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    btn.layer.cornerRadius = 50/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame)+10,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-40-NAVIGATION_BAR_HEIGHT,50, 50);
    btn1.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    btn1.layer.cornerRadius = 50/2;
    btn1.layer.masksToBounds = YES;
    [btn1 setImage:UIImageNamed(@"Image_saveicon") forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(saveIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self.headeimageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
}

- (void)changeIcon{
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)saveIcon{
    [self.headeimageView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
    }];
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
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"6" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"avatarUri"];
            
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    self->_headeimageView.image = image;
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                        
                        if (success) {
                            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                            [NoticeSaveModel saveUserInfo:userIn];
                            if (self.imageBlock) {
                                self.imageBlock(image);
                                [UIView animateWithDuration:1 animations:^{
                                    [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.changesus"]];
                                } completion:^(BOOL finished) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                        }
                    } fail:^(NSError *error) {
                    }];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}
@end
