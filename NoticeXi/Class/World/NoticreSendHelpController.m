//
//  NoticreSendHelpController.m
//  NoticeXi
//
//  Created by li lei on 2022/8/3.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticreSendHelpController.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeCaoGaoController.h"
#define Locapaths  @"locapath"
#define ImageDatas  @"ImageDatas"
@interface NoticreSendHelpController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate>
@property (nonatomic, strong) UILabel *sendBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, assign) CGFloat keyBordHeight;
@property (nonatomic, assign) BOOL isOnlySelf;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, assign) BOOL isHasTostsave;
@property (nonatomic, assign) BOOL hasChange;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL needContSet;//是否需要设置偏移量
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, assign) BOOL hasChangeSave;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) NSMutableAttributedString *attStr1;
@property (nonatomic, strong) NSMutableAttributedString *attStr2;
@end

@implementation NoticreSendHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    navView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:navView];
    
    UILabel *btn = [[UILabel alloc] init];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-66-20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2,66,28);
    btn.text = [NoticeTools getLocalStrWith:@"py.send"];
    btn.font = TWOTEXTFONTSIZE;
    btn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    btn.userInteractionEnabled = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    btn.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = 14;
    btn.layer.masksToBounds = YES;
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
    [btn addGestureRecognizer:sendTap];
    _sendBtn = btn;
    [self.view addSubview:btn];
    

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = [NoticeTools getLocalStrWith:@"help.qiuz"];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20-20-34, 49)];
    [self.nameField setupToolbarToDismissRightButton];
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"help.titlein"] attributes:@{NSFontAttributeName:XGEightBoldFontSize,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    [self.view addSubview:self.nameField];
    self.nameField.font = XGEightBoldFontSize;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-34,NAVIGATION_BAR_HEIGHT,34, 49)];
    self.numL.font = TWOTEXTFONTSIZE;
    self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    [self.view addSubview:self.numL];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+49, DR_SCREEN_WIDTH-20, 1)];
    line.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:line];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+50, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-50)];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomFirstTap)];
    [self.tableView addGestureRecognizer:tap];
    
    self.plaStr = [NoticeTools getLocalStrWith:@"help.conin"];
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, DR_SCREEN_WIDTH-40, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20,5, DR_SCREEN_WIDTH-40,35)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.scrollEnabled = NO;
    _textView.bounces = NO;
    _textView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithHexString:@"#25262E"];
    _textView.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    [_tableView addSubview:_textView];
    [_tableView addSubview:_plaL];
    self.phassetArr = [NSMutableArray new];
    self.moveArr = [NSMutableArray new];


    [self.textView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50,DR_SCREEN_WIDTH, 50)];
    self.toolsView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.toolsView];
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-20-60, 50)];
    markL.font = FOURTHTEENTEXTFONTSIZE;
    markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    markL.textAlignment = NSTextAlignmentRight;
    markL.text = [NoticeTools getLocalStrWith:@"help.niming"];
    [self.toolsView addSubview:markL];
    
    self.photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,5,40, 40)];
    [self.photoBtn setBackgroundImage:UIImageNamed(@"Image_textchoiceimg") forState:UIControlStateNormal];
    [self.toolsView addSubview:self.photoBtn];
    [self.photoBtn addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isSave) {
        self.nameField.text = self.saveModel.titleName;
        self.textView.text = self.saveModel.textContent;
        [self.textView becomeFirstResponder];
        if (self.saveModel.img1Path) {
            [self getsaveimg1];
        }else{
            [self keyboardHide];
        }
    }
}


- (void)getsaveimg1{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img1Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];

            if (self.saveModel.img2Path) {
                [self getsaveimg2];
            }else{
                [self keyboardHide];
                [self hideHUD];
            }
        }else{
            [self hideHUD];
        }
        
    }];
}

- (void)getsaveimg2{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img2Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];
            if (self.saveModel.img3Path) {
                [self getsaveimg3];
            }else{
                [self keyboardHide];
            }
        }else{
            [self hideHUD];
        }
        
    }];
}

- (void)getsaveimg3{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [imgView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img3Path]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
            NSMutableDictionary *imagerDic = [NSMutableDictionary new];
            [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
            UIImage *ciImage = image;
            [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
            [self.moveArr addObject:imagerDic];
            [self keyboardHide];
            [self hideHUD];
        }else{
            [self hideHUD];
        }
        
    }];
}


//打开相册
- (void)openPhotoClick{

    if (self.moveArr.count >= 3) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"photo.limit"]];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.moveArr.count delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = NO;
    imagePicker.showPhotoCannotSelectLayer = YES;

    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dispatch_queue_t queue = dispatch_queue_create("com.itheima.queue", DISPATCH_QUEUE_SERIAL);
    for (PHAsset *asset in assets) {
        dispatch_sync(queue, ^{
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (!imageData) {
                    [self showToastWithText:@"图片选择失败"];
                    return ;
                }
                self.hasChangeSave = YES;
                NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                UIImage *ciImage = [UIImage imageWithData:imageData];
                [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                [self.moveArr addObject:imagerDic];
 
                [self keyboardHide];
            }];
        });
    }
}

- (UIImageView *)imageView1{
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textView.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self.tableView addSubview:_imageView1];
        _imageView1.layer.cornerRadius = 5;
        _imageView1.layer.masksToBounds = YES;
        _imageView1.hidden = YES;
        _imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView1 addGestureRecognizer:tap];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-12-28, 12, 28, 28)];
        cancelBtn.tag = 0;
        [cancelBtn setBackgroundImage:UIImageNamed(@"cancelimgbtn") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView1 addSubview:cancelBtn];
    }
    return _imageView1;
}

- (UIImageView *)imageView2{
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView1.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self.tableView addSubview:_imageView2];
        _imageView2.layer.cornerRadius = 5;
        _imageView2.layer.masksToBounds = YES;
        _imageView2.hidden = YES;
        _imageView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView2 addGestureRecognizer:tap];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-12-28, 12, 28, 28)];
        cancelBtn.tag = 1;
        [cancelBtn setBackgroundImage:UIImageNamed(@"cancelimgbtn") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView2 addSubview:cancelBtn];
    }
    return _imageView2;
}

- (UIImageView *)imageView3{
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageView2.frame)+10, DR_SCREEN_WIDTH-40, 0)];
        [self.tableView addSubview:_imageView3];
        _imageView3.layer.cornerRadius = 5;
        _imageView3.layer.masksToBounds = YES;
        _imageView3.hidden = YES;
        _imageView3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigLook:)];
        [_imageView3 addGestureRecognizer:tap];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-12-28, 12, 28, 28)];
        cancelBtn.tag = 2;
        [cancelBtn setBackgroundImage:UIImageNamed(@"cancelimgbtn") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView3 addSubview:cancelBtn];
    }
    return _imageView3;
}

- (void)cancelClick:(UIButton *)btn{
    if (self.moveArr.count-1 < btn.tag) {
        return;
    }
    self.hasChangeSave = YES;
    [self.moveArr removeObjectAtIndex:btn.tag];
    [self keyboardHide];
}

- (void)bigLook:(UITapGestureRecognizer *)tap{
    UIImageView *tapImg = (UIImageView *)tap.view;
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = tapImg;
    
    NSMutableArray *_photosItemArr = [[NSMutableArray alloc] init];
    [_photosItemArr addObject:item];
    
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:_photosItemArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:tapImg
                   toContainer:toView
                      animated:YES completion:nil];
}

- (void)refreshImageView{
    _imageView1.hidden = YES;
    _imageView2.hidden = YES;
    _imageView3.hidden = YES;
    if (self.moveArr.count) {
        
        self.imageView1.hidden = NO;
        self.imageView1.image = [UIImage imageWithData:[self.moveArr[0] objectForKey:@"ImageDatas"]];
        self.imageView1.frame = CGRectMake(20, CGRectGetMaxY(self.textView.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (self.imageView1.image.size.height/self.imageView1.image.size.width));
        if (self.moveArr.count == 2) {
            self.imageView2.hidden = NO;
            self.imageView2.image = [UIImage imageWithData:[self.moveArr[1] objectForKey:@"ImageDatas"]];
            self.imageView2.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (self.imageView2.image.size.height/self.imageView2.image.size.width));
        }else if (self.moveArr.count > 2){
            
            self.imageView2.hidden = NO;
            self.imageView2.image = [UIImage imageWithData:[self.moveArr[1] objectForKey:@"ImageDatas"]];
            self.imageView2.frame = CGRectMake(20, CGRectGetMaxY(self.imageView1.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (self.imageView2.image.size.height/self.imageView2.image.size.width));
            
            self.imageView3.hidden = NO;
            self.imageView3.image = [UIImage imageWithData:[self.moveArr[2] objectForKey:@"ImageDatas"]];
            self.imageView3.frame = CGRectMake(20, CGRectGetMaxY(self.imageView2.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40) * (self.imageView3.image.size.height/self.imageView3.image.size.width));
        }
        
        if (self.moveArr.count == 1) {
            self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height+10+self.imageView1.frame.size.height);
        }else if (self.moveArr.count == 2){
            self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height+10+self.imageView1.frame.size.height+10+self.imageView2.frame.size.height);
        }else if (self.moveArr.count == 3){
            self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height+10+self.imageView1.frame.size.height+10+self.imageView2.frame.size.height+10+self.imageView3.frame.size.height);
        }
        
    }
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    self.attStr2 = nil;
    if (_field.text.length > 15) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/15",(unsigned long)_field.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/15",(unsigned long)_field.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:@"10" beginSize:allStr.length-2];
    }
    
    if (self.textView.text.length && self.nameField.text.length) {
        _plaL.text = @"";
        _sendBtn.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        _plaL.text = self.plaStr;
        _sendBtn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
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


-(void)keyboardDidChangeFrame:(NSNotification *)notification{
 
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.toolsView.frame.size.height, DR_SCREEN_HEIGHT, 50);
    self.keyBordHeight = keyboardF.size.height;
    self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    [self setTextViewHeight:self.textView text:@""];
}

- (void)keyboardHide{
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50,DR_SCREEN_WIDTH, 50);
    self.textView.frame = CGRectMake(20,15, DR_SCREEN_WIDTH-40,(self.textHeight>35?self.textHeight:35)+30);
    self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height);
    [self.photoBtn setBackgroundImage:UIImageNamed(self.moveArr.count==3? @"Image_textchoiceimgn":@"Image_textchoiceimg") forState:UIControlStateNormal];
    [self refreshImageView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (range.location < textView.text.length) {
        self.needContSet = NO;
    }else{
        self.needContSet = YES;
    }
    return YES;
}

- (void)setTextViewHeight:(UITextView *)textView text:(NSString *)text{
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    self.textHeight = height+20;
    [self refreshHeight];
}


- (void)refreshHeight{
    
    NSString *currentSelectStr = [self.textView.text substringToIndex:self.textView.selectedRange.location];
    CGFloat curSelectHeight = [self heightForTextView:_textView WithText:currentSelectStr]+20;//当前光标位置高度
    
   // CGFloat allHeight = self.textHeight;//总高度
    CGFloat canLookHeight = self.tableView.frame.size.height-50-self.keyBordHeight-20+100+BOTTOM_HEIGHT;//文本输入可视区域
    
    if (curSelectHeight >= canLookHeight) {//如果光标位置的高度超过了可视高度
        self.textView.frame = CGRectMake(20,self.tableView.frame.size.height-curSelectHeight-canLookHeight, DR_SCREEN_WIDTH-40,self.textHeight);
        
        if (CGRectGetMaxY(self.textView.frame) < canLookHeight/2) {
            self.textView.frame = CGRectMake(20,-self.textHeight+canLookHeight/2, DR_SCREEN_WIDTH-40,self.textHeight);
        }
    }else{
        self.textView.frame = CGRectMake(20,5, DR_SCREEN_WIDTH-40,(self.textHeight>35?self.textHeight:35));
    }
    self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    [self refreshImageView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.attStr1 = nil;
    if (textView.text.length && self.nameField.text.length) {
        _plaL.text = @"";
        _sendBtn.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        _plaL.text = self.plaStr;
        _sendBtn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    _plaL.text = textView.text.length?@"":self.plaStr;
    [self setTextViewHeight:textView text:@""];
}

- (float)heightForTextView:(UITextView *)textView WithText:(NSString *) strText{

    return [self getSpaceLabelHeight:strText withFont:[UIFont systemFontOfSize:17] withWidth:DR_SCREEN_WIDTH-40]+20;

}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
    [self.nameField resignFirstResponder];
}

- (void)backClick{
    [_textView resignFirstResponder];
    [self.nameField resignFirstResponder];
    if (_textView.text.length && self.nameField.text.length) {
        if (self.isSave) {
            if ( (self.hasChangeSave || (![self.textView.text isEqualToString:self.saveModel.textContent]) || (![self.saveModel.titleName isEqualToString:self.nameField.text]))) {
                [self tosastSave];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }
        [self tosastSave];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tosastSave{
    __weak typeof(self) weakSelf = self;
    
    LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
        if (buttonIndex1 == 2) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        if (buttonIndex1 == 1){
            if (weakSelf.isSave) {
                if (weakSelf.deleteSaveModelBlock) {
                    weakSelf.deleteSaveModelBlock(weakSelf.index, NO);
                }
            }
            [weakSelf saveTocaogao];
            
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.save"]];
      
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:NO];
            });
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"cao.savecao"],[NoticeTools getLocalStrWith:@"cao.nosave"]]];
    [sheet1 show];
}


- (void)becomFirstTap{
    [self.textView becomeFirstResponder];
}

- (void)sendClick{
    if (self.nameField.text.length == 0) {
        [self showToastWithText:@"请输入标题"];
        return;
    }
    if (self.nameField.text.length > 15) {
        [self showToastWithText:@"标题不可以超过15个字哦~"];
        return;
    }
    
    if (self.textView.text.length == 0) {
        [self showToastWithText:@"请输入正文"];
        return;
    }
    if (self.textView.text.length > 5000) {
        [self showToastWithText:@"标题不可以超过5000个字哦~"];
        return;
    }
    [self.nameField resignFirstResponder];
    [self.textView resignFirstResponder];
    _sendBtn.userInteractionEnabled = NO;
    if (self.moveArr.count) {
        [self updateImage];
    }else{
        [self upTiezi];
    }
}


- (void)updateImage{
    [self showHUD];

    
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];
    for (NSMutableDictionary *dic in self.moveArr) {
        [arr addObject:[dic objectForKey:Locapaths]];
        [arr1 addObject:[dic objectForKey:ImageDatas]];
    }
    
    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"71" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 
    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            _sendBtn.userInteractionEnabled = YES;
            [self hideHUD];
            [self caaceSave];
            return ;
        }else{
            self.bucket_id = bucketId;
            self.imageJsonString = Message;
            [self upTiezi];
        }
    }];
}

- (void)upTiezi{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.nameField.text forKey:@"title"];
    [parm setObject:self.textView.text forKey:@"content"];
    if (self.imageJsonString) {
        [parm setObject:self.imageJsonString forKey:@"invitation_img"];
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"invitation" Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if (self.upSuccess) {
                self.upSuccess(YES);
               
            }
            if (self.deleteSaveModelBlock) {
                self.deleteSaveModelBlock(self.index,YES);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            _sendBtn.userInteractionEnabled = YES;
            
            NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
  
            if (msgModel.chatM.keyword.count) {
                for (NSString *str in msgModel.chatM.keyword) {
                    [self setRedColor:str sourceString:self.textView.text textView:self.textView att:self.attStr1];
                    [self setRedColor2:str sourceString:self.nameField.text textView:self.nameField att:self.attStr2];
                }
                return;
            }
            
            if (self.isSave) {
                if (self.deleteSaveModelBlock) {
                    self.deleteSaveModelBlock(self.index,NO);
                }
             
                [self saveTocaogao];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    } fail:^(NSError * _Nullable error) {
        _sendBtn.userInteractionEnabled = YES;
        [self hideHUD];
        if (self.isSave) {
            if (self.deleteSaveModelBlock) {
                self.deleteSaveModelBlock(self.index,NO);
            }
         
            [self saveTocaogao];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self caaceSave];
    
    }];
}

- (void)setRedColor2:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextField*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attStr2 = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:XGEightBoldFontSize range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}

- (void)setRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextView*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attStr1 = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:SIXTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}



- (void)caaceSave{//缓存发送失败的心情

    __weak typeof(self) weakSelf = self;
    NSString *str = [NoticeTools getLocalStrWith:@"sendTextt.cace"];
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"help.sendfail"] message:str sureBtn:[NoticeTools getLocalType]==0? @"保留帖子":[NoticeTools getLocalStrWith:@"sendTextt.save"] cancleBtn:[NoticeTools getLocalStrWith:@"py.dele"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf saveTocaogao];
            [weakSelf cachaSuccdss];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (void)saveTocaogao{
    NSMutableArray *alreadyArr = [NoticeSaveVoiceTools gethelpArrary];
    NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
    saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
    saveM.textContent = self.textView.text;
    saveM.titleName = self.nameField.text;
    saveM.contentType = @"5";//帖子

    if (self.moveArr.count) {
        for (int i = 0; i < self.moveArr.count; i++) {
            UIImage * imgsave = [UIImage imageWithData:[self.moveArr[i] objectForKey:ImageDatas]];
            NSString *pathName = [NSString stringWithFormat:@"/%@",[self.moveArr[i] objectForKey:Locapaths]];
            NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:pathName];
            [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
            if (i == 0) {
                saveM.img1Path = [self.moveArr[i] objectForKey:Locapaths];
            }else if (i == 1){
                saveM.img2Path = [self.moveArr[i] objectForKey:Locapaths];
            }else if (i == 2){
                saveM.img3Path = [self.moveArr[i] objectForKey:Locapaths];
            }
        }
    }
    [alreadyArr insertObject:saveM atIndex:0];
    [NoticeSaveVoiceTools savehelpArr:alreadyArr];
}

- (void)cachaSuccdss{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"sendTextt.save"] message:[NoticeTools getLocalStrWith:@"sendTextt.tosetlook"] sureBtn:[NoticeTools getLocalStrWith:@"sendTextt.look"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NoticeCaoGaoController *ctl = [[NoticeCaoGaoController alloc] init];
            ctl.backToRoot = YES;
            ctl.choiceToPost = YES;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    appdel.noPop = NO;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    appdel.noPop = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
