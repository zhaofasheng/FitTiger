//
//  NoticeAddReadController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddReadController.h"
#import "FDAlertView.h"
#import "ZFSDateFormatUtil.h"
#import "RBCustomDatePickerView.h"
@interface NoticeAddReadController ()<UITextFieldDelegate,TZImagePickerControllerDelegate,sendTheValueDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIImage *choiceImage;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) NSString *activeTime;
@end

@implementation NoticeAddReadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.navigationItem.title = @"添加定时任务";
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 40)];
    backV.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backV.layer.cornerRadius = 5;
    backV.layer.masksToBounds = YES;
    [self.view addSubview:backV];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, DR_SCREEN_WIDTH-50, 40)];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.nameField.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    [backV addSubview:self.nameField];
    
    self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, CGRectGetMaxY(backV.frame)+10, 335, 360)];
    self.choiceImageView.layer.cornerRadius = 8;
    self.choiceImageView.layer.masksToBounds = YES;
    self.choiceImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.choiceImageView.clipsToBounds = YES;
    self.choiceImageView.image = UIImageNamed(@"Image_choicebiaoti");
    [self.view addSubview:self.choiceImageView];
    self.choiceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap)];
    [self.choiceImageView addGestureRecognizer:tap];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-243)/2,self.view.frame.size.height-BOTTOM_HEIGHT-50-30-NAVIGATION_BAR_HEIGHT, 243, 50)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    addBtn.layer.cornerRadius = 25;
    addBtn.layer.masksToBounds = YES;
    [addBtn setTitle:@"添加定时任务" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    addBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.choiceImageView.frame), 200, 35)];
    label.font = SIXTEENTEXTFONTSIZE;
    label.text = @"生效时间";
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:label];
    
    self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+20, DR_SCREEN_WIDTH-40, 40)];
    self.timeL.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    self.timeL.layer.cornerRadius = 5;
    self.timeL.layer.masksToBounds = YES;
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.font = SIXTEENTEXTFONTSIZE;
    self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.timeL];
    self.timeL.userInteractionEnabled = YES;
    UITapGestureRecognizer *choiceTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTimeT)];
    [self.timeL addGestureRecognizer:choiceTimeTap];
    
    if (self.bannerM) {
        [addBtn setTitle:@"编辑任务" forState:UIControlStateNormal];
        self.navigationItem.title = @"编辑定时任务";
        self.nameField.text = self.bannerM.title;
        self.timeL.text = self.bannerM.taketed_at;
        [self.choiceImageView sd_setImageWithURL:[NSURL URLWithString:self.bannerM.http_attr_pc]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

//删除每日一阅
- (void)deleteClick{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/article/%@",self.bannerM.bannerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)choiceTimeT{
    FDAlertView *alert = [[FDAlertView alloc] init];
    RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    contentView.delegate=self;
    alert.contentView = contentView;
    [alert show];
}

- (void)getTimeToValue:(NSString *)theTimeStr{

    self.activeTime = theTimeStr;
    self.timeL.text = theTimeStr;
}

- (void)choiceTap{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    self.choiceImage = choiceImage;
    self.choiceImageView.image = choiceImage;
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
            self.imgPath = filePath;
        }else{
            self.imgPath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        }
    }];
}

- (void)editBanner{
    if (self.choiceImage) {
        NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:self.imgPath]];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"111" forKey:@"resourceType"];
        [parm setObject:pathMd5 forKey:@"resourceContent"];

        [[XGUploadDateManager sharedManager] uploadImageWithImage:self.choiceImage parm:parm progressHandler:^(CGFloat progress) {
            
        } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
            if (sussess) {
                
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:self.nameField.text forKey:@"title"];
                [parm setObject:errorMessage forKey:@"attr_pc"];
                [parm setObject:@"1" forKey:@"type"];
                if (self.activeTime) {
                    NSString *timeInt = [NSString stringWithFormat:@"%@:00",self.activeTime];
                    NSInteger timeNum = [ZFSDateFormatUtil timeIntervalWithDateString:timeInt];
                    [parm setObject:[NSString stringWithFormat:@"%ld",timeNum] forKey:@"taketed_at"];
                }
         
                [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
                if (bucketId) {
                   [parm setObject:bucketId forKey:@"bucketId"];
                }
                [self showHUDWithText:@"图片上传中..."];
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/article/%@",self.bannerM.bannerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                    if (success1) {
                        [self showToastWithText:@"已编辑"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    [self hideHUD];
                } fail:^(NSError * _Nullable error) {
                }];
            }else{
                [self showToastWithText:errorMessage];
                [self hideHUD];
            }
        }];
    }else{
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.nameField.text forKey:@"title"];
        [parm setObject:@"1" forKey:@"type"];
        if (self.activeTime) {
            NSString *timeInt = [NSString stringWithFormat:@"%@:00",self.activeTime];
            NSInteger timeNum = [ZFSDateFormatUtil timeIntervalWithDateString:timeInt];
            [parm setObject:[NSString stringWithFormat:@"%ld",timeNum] forKey:@"taketed_at"];
        }
 
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
  
        [self showHUDWithText:@"图片上传中..."];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/article/%@",self.bannerM.bannerId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
            if (success1) {
                [self showToastWithText:@"已编辑"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
        }];
    }
}

- (void)addClick{
    if (!self.nameField.text.length) {
        return;
    }
    if (self.bannerM) {
        [self editBanner];
        return;
    }
    if (!self.choiceImage) {
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:self.imgPath]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"111" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:self.choiceImage parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self.nameField.text forKey:@"title"];
            [parm setObject:errorMessage forKey:@"attr_pc"];
            [parm setObject:@"1" forKey:@"type"];
            NSString *timeInt = [NSString stringWithFormat:@"%@:00",self.activeTime];
            NSInteger timeNum = [ZFSDateFormatUtil timeIntervalWithDateString:timeInt];
            [parm setObject:[NSString stringWithFormat:@"%ld",timeNum] forKey:@"taketed_at"];
            [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }
            [self showHUDWithText:@"图片上传中..."];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/article" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    [self showToastWithText:[NoticeTools getLocalStrWith:@"movie.aladd"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } fail:^(NSError * _Nullable error) {
                [self showToastWithText:errorMessage];
                [self hideHUD];
            }];
   
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


@end
