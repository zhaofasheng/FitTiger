//
//  NoticeManagerSendController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerSendController.h"
#import "FDAlertView.h"
#import "ZFSDateFormatUtil.h"
#import "RBCustomDatePickerView.h"
#import "NoticePlayerVideoController.h"
@interface NoticeManagerSendController ()<UITextFieldDelegate,UITextViewDelegate,sendTheValueDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) UITextField *secondField;
@property (nonatomic, strong) UIView *sendondView;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UIButton *tsBtn;
@property (nonatomic, strong) UIButton *btsBtn;
@property (nonatomic, strong) UIButton *buttonView;
@property (nonatomic, assign) BOOL isNeedTuisong;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) NSData *videoData;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *outPath;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *videoImageView;
@end

@implementation NoticeManagerSendController
{
    UILabel *_plaL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 800)];
    self.tableView.tableHeaderView = contentView;
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, 40)];
    backV.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backV.layer.cornerRadius = 5;
    backV.layer.masksToBounds = YES;
    [contentView addSubview:backV];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, DR_SCREEN_WIDTH-50, 40)];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    [self.nameField setupToolbarToDismissRightButton];
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.nameField.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    [backV addSubview:self.nameField];
    
    //光标右移
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(15,0,7,30)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nameField.leftView = leftView;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backV.frame)+15, DR_SCREEN_WIDTH-40, 150)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [contentView addSubview:backView];
    
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, DR_SCREEN_WIDTH-40-20, 30)];

    self.contentView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.contentView.backgroundColor = backView.backgroundColor;
    if (self.movieName.length) {
        self.contentView.text = self.movieName;
        CGRect frame = self.contentView.frame;
        float height;
        height = [self heightForTextView:self.contentView WithText:self.contentView.text];
        if (height > 120) {
            height = 120;
        }
        frame.size.height = height;
        self.contentView.frame = frame;
    }
    
    self.contentView.delegate = self;
    self.contentView.font =FIFTHTEENTEXTFONTSIZE;
    self.contentView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [backView addSubview:self.contentView];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+15, 200, 15)];
    if (self.movieName.length && self.movieName) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请输入正文";

    }
    
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = GetColorWithName(VDarkTextColor);
    [backView addSubview:_plaL];
    
    self.sendondView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backView.frame), DR_SCREEN_WIDTH-40, 80)];
    [contentView addSubview:self.sendondView];
    
    self.subL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200,40)];
    self.subL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.subL.font = FOURTHTEENTEXTFONTSIZE;
    [self.sendondView addSubview:self.subL];
    
    UIView *backV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, DR_SCREEN_WIDTH-40, 40)];
    backV1.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backV1.layer.cornerRadius = 5;
    backV1.layer.masksToBounds = YES;
    [self.sendondView addSubview:backV1];
    
    self.secondField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, DR_SCREEN_WIDTH-50, 40)];
    self.secondField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.secondField.delegate = self;
    self.secondField.font =FIFTHTEENTEXTFONTSIZE;
    self.secondField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.secondField setupToolbarToDismissRightButton];
    self.secondField.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    [backV1 addSubview:self.secondField];

    self.secondField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.secondField.leftViewMode = UITextFieldViewModeAlways;
    
    
    NSString *str = @"";
    if (self.type == 1) {
        self.subL.text = @"文章ID";
        str = @"请输入ID";
        self.navigationItem.title = @"编辑图书消息";
    }else if (self.type == 2){
        self.subL.text = @"播客ID";
        str = @"请输入ID";
        self.navigationItem.title = @"编辑播客消息";
    }else if (self.type == 3){
        self.subL.text = @"#话题#";
        str = @"请输入话题";
        self.navigationItem.title = @"编辑话题消息";
    }else if (self.type == 4){
        self.subL.text = @"活动链接";
        str = @"请输入链接";
        self.navigationItem.title = @"编辑活动消息";
    }else if (self.type == 5){
        self.sendondView.hidden = YES;
    }else if (self.type == 6){
        self.subL.text = @"反馈序号";
        str = @"请输入序号";
        self.navigationItem.title = @"编辑反馈消息";
    }else if (self.type == 8){
        self.subL.text = @"商品id";
        str = @"请复制商品id";
        self.navigationItem.title = @"编辑声昔小铺消息";
    }
    else{
        self.sendondView.hidden = YES;
        self.navigationItem.title = @"编辑版本更新消息";
    }
    
    self.secondField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    
    self.buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sendondView.frame)+20, DR_SCREEN_WIDTH, 40)];
    self.tsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [self.tsBtn setTitle:@"推送" forState:UIControlStateNormal];
    [self.tsBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.tsBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.tsBtn setImage:UIImageNamed(@"img_nochoiceno") forState:UIControlStateNormal];
    [self.buttonView addSubview:self.tsBtn];
    
    [contentView addSubview:self.buttonView];
    
    self.btsBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tsBtn.frame), 0, 80, 40)];
    [self.btsBtn setTitle:@"不推送" forState:UIControlStateNormal];
    [self.btsBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.btsBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.btsBtn setImage:UIImageNamed(@"img_nochoice") forState:UIControlStateNormal];
    [self.buttonView addSubview:self.btsBtn];
    
    self.isNeedTuisong = YES;
    [self.tsBtn addTarget:self action:@selector(tuisonClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.btsBtn addTarget:self action:@selector(butuisongClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.buttonView.frame)+10, DR_SCREEN_WIDTH-40, 40)];
    timeBtn.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    timeBtn.layer.cornerRadius = 5;
    timeBtn.layer.masksToBounds = YES;
    [timeBtn setTitle:@"选择生效时间" forState:UIControlStateNormal];
    [timeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    timeBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [contentView addSubview:timeBtn];
    [timeBtn addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton = timeBtn;
    
    UILabel *upSpL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(timeBtn.frame)+15, 200, 20)];
    upSpL.text = @"上传视频";
    upSpL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    upSpL.font = FOURTHTEENTEXTFONTSIZE;
    [contentView addSubview:upSpL];
    
    
    self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(upSpL.frame)+10, (DR_SCREEN_WIDTH-30-10)/3, (DR_SCREEN_WIDTH-30-10)/3)];
    self.choiceImageView.layer.cornerRadius = 8;
    self.choiceImageView.layer.masksToBounds = YES;
    self.choiceImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.choiceImageView.clipsToBounds = YES;
    [contentView addSubview:self.choiceImageView];
    self.choiceImageView.userInteractionEnabled = YES;
    self.choiceImageView.image = UIImageNamed(@"btn_post_photo");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.choiceImageView addGestureRecognizer:tap];
    self.choiceImageView.hidden = self.type==8?NO:YES;
    upSpL.hidden = self.choiceImageView.hidden;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.choiceImageView.frame)+50, DR_SCREEN_WIDTH-40, 40)];
    [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"py.send"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    cancelBtn.layer.cornerRadius = 20;
    cancelBtn.layer.masksToBounds = YES;
    [contentView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.messageM) {
        self.nameField.text = self.messageM.title;
        self.secondField.text = self.messageM.supply;
        self.contentView.text = self.messageM.content;
        if (self.messageM.take_time) {
            [self.timeButton setTitle:self.messageM.take_time forState:UIControlStateNormal];
            self.timeStr = self.messageM.take_time;
        }
        [cancelBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self textView:self.contentView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
    }
}

- (void)tapAction{
    if (self.videoPath) {
        NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
        ctl.videoUrl = self.outPath;
        ctl.islocal = YES;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (UIImageView *)videoImageView{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _videoImageView.image = UIImageNamed(@"Image_videoimg");
        [self.choiceImageView addSubview:_videoImageView];
        _videoImageView.hidden = YES;
        _videoImageView.center = _choiceImageView.center;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.choiceImageView.frame.size.width-30, 0, 30, 30)];
        [button setImage:UIImageNamed(@"btn_img_close") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self.choiceImageView addSubview:button];
        self.deleteBtn = button;
    }
    return _videoImageView;
}

- (void)deleteImageClick{
    self.deleteBtn.hidden = YES;
    self.videoPath = nil;
    self.videoImageView.hidden = YES;
    self.choiceImageView.image = UIImageNamed(@"btn_post_photo");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{

    [self showHUD];
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
        NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.mp4",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,outputPath]]];
        NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
        [parm1 setObject:@"70" forKey:@"resourceType"];
        [parm1 setObject:pathMd5 forKey:@"resourceContent"];
        [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:outputPath parm:parm1 progressHandler:^(CGFloat progress) {
            
        } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
            if (sussess) {
                self.outPath = outputPath;
                self.choiceImageView.image = coverImage;
                self.videoImageView.hidden = NO;
                self.bucket_id = bucketId;
                self.videoPath = Message;
                self.deleteBtn.hidden = NO;
            }else{
                [self showToastWithText:@"上传视频失败"];
            }
            [self hideHUD];
        }];
    } failure:^(NSString *errorMessage, NSError *error) {
        [self hideHUD];
    }];
}


- (void)timeClick{
    FDAlertView *alert = [[FDAlertView alloc] init];
    RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    contentView.delegate = self;
    alert.contentView = contentView;
    [alert show];
}

- (void)getTimeToValue:(NSString *)theTimeStr{

    self.timeStr = theTimeStr;
    [self.timeButton setTitle:theTimeStr forState:UIControlStateNormal];
}
- (void)sendClick{
    if (!self.nameField.text.length) {
        [self showToastWithText:@"请输入标题"];
        return;
    }
    if (!self.contentView.text.length) {
        [self showToastWithText:@"请输入正文"];
        return;
    }
    if (self.type == 1 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入文章ID"];
        return;
    }
    if (self.type == 2 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入播客ID"];
        return;
    }
    if (self.type == 3 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入话题"];
        return;
    }
    if (self.type == 4 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入链接"];
        return;
    }
    
    if (self.type == 6 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入反馈序号"];
        return;
    }
    if (self.type == 8 && !self.secondField.text.length) {
        [self showToastWithText:@"请输入商品id"];
        return;
    }


    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.timeStr) {
        NSString *timeInt = [NSString stringWithFormat:@"%@:00",self.timeStr];
        NSInteger timeNum = [ZFSDateFormatUtil timeIntervalWithDateString:timeInt];
        [parm setObject:[NSString stringWithFormat:@"%ld",timeNum] forKey:@"take_time"];
    }
    [parm setObject:self.nameField.text forKey:@"title"];
    [parm setObject:self.contentView.text forKey:@"content"];
    [parm setObject:self.isNeedTuisong?@"1":@"0" forKey:@"action"];
    [parm setObject:[NSString stringWithFormat:@"%ld",self.type] forKey:@"categoryId"];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    if (self.type == 8 && self.videoPath) {
        [parm setObject:self.videoPath forKey:@"supply"];
        [parm setObject:self.bucket_id?@"0":self.bucket_id forKey:@"bucket_id"];
     
    }
    if (self.secondField.text.length) {
        [parm setObject:self.secondField.text forKey:self.type==8?@"link_url": @"supply"];
    }
    [self showHUD];
    if (self.messageM) {
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/sysmsgs/%@",self.messageM.msgId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self showToastWithText:@"已编辑"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }

    if (self.type == 8 && !self.videoPath) {
        [self showToastWithText:@"请选择视频"];
        return;
    }
    if (self.type == 8) {
        [parm setObject:self.videoPath forKey:@"supply"];
        [parm setObject:self.bucket_id?@"0":self.bucket_id forKey:@"bucket_id"];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/sysmsgs" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.hassend"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)tuisonClcik{
    self.isNeedTuisong = YES;
    if (self.isNeedTuisong) {
        [self.tsBtn setImage:UIImageNamed(@"img_nochoiceno") forState:UIControlStateNormal];
        [self.btsBtn setImage:UIImageNamed(@"img_nochoice") forState:UIControlStateNormal];
    }else{
        [self.btsBtn setImage:UIImageNamed(@"img_nochoiceno") forState:UIControlStateNormal];
        [self.tsBtn setImage:UIImageNamed(@"img_nochoice") forState:UIControlStateNormal];
    }
}

- (void)butuisongClick{
    self.isNeedTuisong = NO;
    if (self.isNeedTuisong) {
        [self.tsBtn setImage:UIImageNamed(@"img_nochoiceno") forState:UIControlStateNormal];
        [self.btsBtn setImage:UIImageNamed(@"img_nochoice") forState:UIControlStateNormal];
    }else{
        [self.btsBtn setImage:UIImageNamed(@"img_nochoiceno") forState:UIControlStateNormal];
        [self.tsBtn setImage:UIImageNamed(@"img_nochoice") forState:UIControlStateNormal];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        if (![textView.text isEqualToString:@""]) {
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
        }else{
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 120) {
        height = 120;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请输入正文";
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.nameField resignFirstResponder];
    [self.contentView resignFirstResponder];
}

@end
