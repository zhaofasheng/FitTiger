//
//  NoticeSendBBSController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/5.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendBBSController.h"
#import "NoticeKeyBordTopView.h"
#import "RTDragCellTableView.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Photos/Photos.h>
#import "NoticeChoicePhotoCell.h"
#import "YYKit.h"

#define ImageDatas  @"ImageDatas"
#define Locapaths  @"locapath"

@interface NoticeSendBBSController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate,NoticeDeleteImageDelegate>
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextField *nameFiled;
@property (nonatomic, assign) BOOL needContSet;//是否需要设置偏移量
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NoticeKeyBordTopView *toolsView;
@property (nonatomic, strong) RTDragCellTableView *tableView;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, assign) CGFloat keyBordHeight;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) UIView *imageViewBack;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) NSArray *imageJsonArr;
@property (nonatomic, assign) BOOL hasChangePhoto;//是否编辑了图片
@property (nonatomic, strong) YYAnimatedImageView *upImage1;
@property (nonatomic, strong) YYAnimatedImageView *upImage2;
@property (nonatomic, strong) YYAnimatedImageView *upImage3;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation NoticeSendBBSController
{
    UILabel *_plaL;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.nameFiled resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.navigationItem.title =self.manageCode?@"编辑稿子": @"投稿给啊囧，不囧不足够";
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = EIGHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VMainTextColor);
    label.text = self.manageCode?@"编辑稿子": @"投稿";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-60, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2,60, 25);
    [btn setTitle:self.manageCode?[NoticeTools getLocalStrWith:@"py.send"]: @"投稿" forState:UIControlStateNormal];
    [btn setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e3e4a"] forState:UIControlStateNormal];
    btn.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
    btn.layer.cornerRadius = 25/2;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn = btn;
    [self.view addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    self.nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(17,NAVIGATION_BAR_HEIGHT+0.5,DR_SCREEN_WIDTH-32,40)];
    self.nameFiled.delegate = self;
    self.nameFiled.textColor = GetColorWithName(VMainTextColor);
    self.nameFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题(50个字以内)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    self.nameFiled.delegate = self;
    self.nameFiled.font = XGFifthBoldFontSize;
    self.nameFiled.tintColor = GetColorWithName(VMainThumeColor);
    [self.view addSubview:self.nameFiled];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
    name:@"UITextFieldTextDidChangeNotification" object:self.nameFiled];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.nameFiled.frame), DR_SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line1];
        
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(line1.frame), DR_SCREEN_WIDTH, 100+(DR_SCREEN_WIDTH-30-10)/3)];
    _backView.backgroundColor = GetColorWithName(VBackColor);
    _backView.showsVerticalScrollIndicator = NO;
    _backView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_backView];
    
    self.plaStr = @"说说你的故事吧";
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(17, 15, 200, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3e3e4a"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,5, DR_SCREEN_WIDTH-30,45)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.backgroundColor = GetColorWithName(VBackColor);
    _textView.delegate = self;
    _textView.textColor = GetColorWithName(VMainTextColor);
    _textView.scrollEnabled = NO;
    _textView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    [_backView addSubview:_textView];
    [_backView addSubview:_plaL];
        
    self.tableView = [[RTDragCellTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;
    self.tableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(15,CGRectGetMaxY(self.textView.frame)+25,DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30-10)/3);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeChoicePhotoCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = (DR_SCREEN_WIDTH-30-10)/3+5;
    [_backView addSubview:self.tableView];
    
    self.phassetArr = [NSMutableArray new];
    self.moveArr = [NSMutableArray new];
    
    self.toolsView = [[NoticeKeyBordTopView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 45)];
    [self.view addSubview:self.toolsView];
    [self.toolsView.photoBtn addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    self.toolsView.topicBtn.hidden = YES;
    self.toolsView.hidden = YES;
    
    if (self.bbsM) {
        self.nameFiled.text = self.bbsM.title;
        _plaL.text = @"";
        self.textView.text = self.bbsM.textContent;
        [self textView:self.textView shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@""];
        
        if (self.bbsM.annexsArr.count) {//获取图片
            [self getBBSImage];
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

//打开相册
- (void)openPhotoClick{

    if (self.moveArr.count >= 3) {
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.moveArr.count delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;

    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (self.textView.text.length && self.nameFiled.text.length) {
        _plaL.text = @"";
        [_sendBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = GetColorWithName(VMainThumeColor);

    }else{
        _plaL.text = self.textView.text.length?@"": self.plaStr;
        [_sendBtn setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e3e4a"] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
    }
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 50)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:9];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:50];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.toolsView.frame.size.height, DR_SCREEN_HEIGHT, 45);
    self.toolsView.hidden = NO;
    if (keyboardF.size.height>200) {
        self.keyBordHeight = keyboardF.size.height;
    }
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (keyboardF.size.height>200) {
        self.keyBordHeight = keyboardF.size.height;
        //[self refreshHeight];
    }
}

- (void)keyboardDiddisss{
    self.toolsView.hidden = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 3000) {
        
        text = [text substringToIndex:3000];
        self.textView.text = text;
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali1"]];
    }
    if (textView.text.length > 3000) {
        
        textView.text = [textView.text substringToIndex:3000];
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali1"]];
    }
    if (range.location < textView.text.length) {
        self.needContSet = NO;
    }else{
        self.needContSet = YES;
    }
    float height;
    if ([text isEqual:@""]) {
        if (![textView.text isEqualToString:@""]) {
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
        }else{
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    self.textHeight = height+30;
    [self refreshHeight];
    return YES;
}

- (void)refreshHeight{
    
    if (self.keyBordHeight < 10) {
        return;
    }

    _backView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+41, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.keyBordHeight-self.toolsView.frame.size.height-5-NAVIGATION_BAR_HEIGHT);
    self.textView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-30,self.textHeight>45?self.textHeight:45);
    
    if (self.textHeight >= (_backView.frame.size.height-5-self.tableView.frame.size.height)) {
        _backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, self.textHeight+(DR_SCREEN_WIDTH-30-10)/3+30);
        self.tableView.frame = CGRectMake(15,CGRectGetMaxY(self.textView.frame),DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30-10)/3);
        if (self.needContSet) {
            [_backView setContentOffset:CGPointMake(0, (self.textHeight-(_backView.frame.size.height-5-self.tableView.frame.size.height)))];
        }
        
    }else{
        _backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, 0);
        self.tableView.frame = CGRectMake(15,_backView.frame.size.height-(DR_SCREEN_WIDTH-30-10)/3-20,DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30-10)/3);
    }
    self.imageViewBack.frame = self.tableView.frame;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length && self.nameFiled.text.length) {
        _plaL.text = @"";
        [_sendBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _sendBtn.backgroundColor = GetColorWithName(VMainThumeColor);

    }else{
        _plaL.text = self.textView.text.length?@"": self.plaStr;
        [_sendBtn setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e3e4a"] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#222238"];
    }
}

- (float)heightForTextView:(UITextView *)textView WithText:(NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)deleteImageWith:(NSInteger)index{
    self.hasChangePhoto = YES;
    [self.moveArr removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.moveArr.count == 3) {
        [self.toolsView.photoBtn setBackgroundImage:UIImageNamed(@"Image_textchoiceimgn") forState:UIControlStateNormal];
    }else{
        [self.toolsView.photoBtn setBackgroundImage:UIImageNamed(@"Image_textchoiceimg") forState:UIControlStateNormal];
    }
    NoticeChoicePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    __weak typeof(self) weakSelf = self;
    cell.hideKeybord = ^(BOOL hideKeyBord) {
        if (hideKeyBord) {
            [weakSelf.textView resignFirstResponder];
            weakSelf.toolsView.hidden = YES;
        }else{
            [weakSelf.textView becomeFirstResponder];
            weakSelf.toolsView.hidden = NO;
        }
    };
   
    cell.choiceImageView.image =  [UIImage sd_imageWithGIFData:[self.moveArr[indexPath.row] objectForKey:ImageDatas]];
    
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.moveArr.count > 3) {
        return 3;
    }
    return self.moveArr.count;
}

- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return self.moveArr;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    self.hasChangePhoto = YES;
    self.moveArr = [NSMutableArray arrayWithArray: newArray];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.hasChangePhoto = YES;
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
                NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    [imagerDic setObject:imageData forKey:ImageDatas];
                }else{
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    UIImage *ciImage = [UIImage imageWithData:imageData];
                    [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                }
                [self.moveArr addObject:imagerDic];
                [self.tableView reloadData];
                
            }];
        });
    }
}

- (void)backClick{
    if (_textView.text.length || self.moveArr.count || self.nameFiled.text.length) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定退出吗？退出后内容不会被保存" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [self->_textView becomeFirstResponder];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.nameFiled resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)sendClick{

    if (!self.nameFiled.text.length || !self.textView.text.length) {
        return;
    }
    if (self.textView.text.length > 3000) {
        [self showToastWithText:@"最多只允许输入三千个字哦"];
        return;
    }
    if (self.isFromCaiNa) {
        [self showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.manageCode forKey:@"confirmPasswd"];
        [parm setObject:self.bbsM.contribution_id forKey:@"contributionId"];
        [parm setObject:@"1" forKey:@"contributionFrom"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/posts" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
                self.bbsM.post_id = model.allId;
                if (self.managerTypeBlock) {
                    self.managerTypeBlock(1, model.allId);
                }
                
                if (![self.nameFiled.text isEqualToString:self.bbsM.title] || ![self.textView.text isEqualToString:self.bbsM.textContent] || self.hasChangePhoto) {//判断是否改动了
                    [self hasChange];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                   [self.navigationController popViewControllerAnimated:YES];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    if (self.bbsM && !self.isFromCaiNa) {
        if (![self.nameFiled.text isEqualToString:self.bbsM.title] || ![self.textView.text isEqualToString:self.bbsM.textContent] || self.hasChangePhoto) {//判断是否改动了
            [self hasChange];
        }
        return;
    }
    [self updateImage];
}

//编辑
- (void)hasChange{
    [self updateImage];
}

- (void)updateImage{
    [self showHUD];
    _sendBtn.enabled = NO;
    if (!self.moveArr.count) {
        [self upData];
        return;
    }
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];
    for (NSMutableDictionary *dic in self.moveArr) {
        [arr addObject:[dic objectForKey:Locapaths]];
        [arr1 addObject:[dic objectForKey:ImageDatas]];
    }
    
    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串
   
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"126" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 
    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            [self hideHUD];
            self.sendBtn.enabled = YES;
            return ;
        }else{

            self.bucketId = bucketId;
    
            self.imageJsonArr = [NoticeTools arraryWithJsonString:Message];
            [self upData];
        }
    }];
}

- (void)upData{
    NSMutableDictionary *parm = [NSMutableDictionary new];

    NSMutableArray *annexsArr = [NSMutableArray new];
    if (self.imageJsonArr.count && self.moveArr.count) {
        for (NSString *urlstr in self.imageJsonArr) {
            NSMutableDictionary *subParm = [NSMutableDictionary new];
            [subParm setObject:self.bucketId?self.bucketId:@"0" forKey:@"bucketId"];
            [subParm setObject:urlstr forKey:@"annexUri"];
            [subParm setObject:@"1" forKey:@"annexType"];
            [subParm setObject:@"0" forKey:@"annexLength"];
            [annexsArr addObject:subParm];
        }
    }
    [parm setObject:[NoticeTools arrayToJSONString:annexsArr] forKey:@"annexs"];
    if (self.manageCode) {
        [parm setObject:self.manageCode forKey:@"confirmPasswd"];
        [parm setObject:self.nameFiled.text forKey:@"postTitle"];
        [parm setObject:self.textView.text forKey:@"postContent"];
    }else{
        [parm setObject:self.nameFiled.text forKey:@"draftTitle"];
        [parm setObject:self.textView.text forKey:@"draftContent"];
    }
    NSString *url = self.manageCode?[NSString stringWithFormat:@"admin/posts/%@",self.bbsM.post_id]:@"drafts";
    if (self.manageCode) {
        [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.isFromCaiNa) {
                    return ;
                }
                [UIView animateWithDuration:1.5 animations:^{
                    [self showToastWithText:self.manageCode?@"编辑成功": @"投稿成功"];
                } completion:^(BOOL finished) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                self.sendBtn.enabled = YES;
            }
        } fail:^(NSError * _Nullable error) {
            self.sendBtn.enabled = YES;
            [self hideHUD];
        }];
    }else{
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.manageCode?nil: @"application/vnd.shengxi.v4.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.isFromCaiNa) {
                    return ;
                }
                [UIView animateWithDuration:1.5 animations:^{
                    [self showToastWithText:self.manageCode?@"编辑成功": @"投稿成功"];
                } completion:^(BOOL finished) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                self.sendBtn.enabled = YES;
            }
        } fail:^(NSError * _Nullable error) {
            self.sendBtn.enabled = YES;
            [self hideHUD];
        }];
    }

}

- (void)getBBSImage{
     [self showHUD];
    NSMutableArray *imgListArr = [NSMutableArray new];
    self.imgArr = imgListArr;
    for (NoticeAnnexsModel *imgM in self.bbsM.annexsArr) {
        [self.imgArr addObject:imgM.annex_url];
    }
     __weak typeof(self) weakSelf = self;
     if (self.bbsM.annexsArr.count == 1) {
         self.upImage1 = [[YYAnimatedImageView alloc] init];
         [self.upImage1 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.imgArr[0]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
             [weakSelf hideHUD];
             NSMutableDictionary *imagerDic1 = [NSMutableDictionary new];
             id imageItem1 = [weakSelf.upImage1.image imageDataRepresentation];
             YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem1));
             NSString *path1 = nil;
             if (type == YYImageTypeGIF) {
                 NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                 path1 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
             }else{
                 NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                 path1 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
             }
             [imagerDic1 setObject:path1 forKey:Locapaths];
             [imagerDic1 setObject:imageItem1 forKey:ImageDatas];

             [weakSelf.moveArr addObject:imagerDic1];
             [weakSelf.tableView reloadData];
         
         }];
     }else if (self.bbsM.annexsArr.count == 2){
         self.upImage1 = [[YYAnimatedImageView alloc] init];
         [self.upImage1 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.imgArr[0]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    
             NSMutableDictionary *imagerDic1 = [NSMutableDictionary new];
             id imageItem1 = [weakSelf.upImage1.image imageDataRepresentation];
             YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem1));
             NSString *path1 = nil;
             if (type == YYImageTypeGIF) {
                 NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                 path1 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
             }else{
                 NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                 path1 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
             }
             [imagerDic1 setObject:path1 forKey:Locapaths];
             [imagerDic1 setObject:imageItem1 forKey:ImageDatas];

             [weakSelf.moveArr addObject:imagerDic1];
             [weakSelf.tableView reloadData];
         
             weakSelf.upImage2 = [[YYAnimatedImageView alloc] init];
             [weakSelf.upImage2 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:weakSelf.imgArr[1]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
             } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                 [weakSelf hideHUD];
                 NSMutableDictionary *imagerDic2 = [NSMutableDictionary new];
                 id imageItem2 = [weakSelf.upImage2.image imageDataRepresentation];
                 YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem2));
                 NSString *path2 = nil;
                 if (type == YYImageTypeGIF) {
                     NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                     path2 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                 }else{
                     NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                     path2 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                 }
                 [imagerDic2 setObject:path2 forKey:Locapaths];
                 [imagerDic2 setObject:imageItem2 forKey:ImageDatas];

                 [weakSelf.moveArr addObject:imagerDic2];
                 [weakSelf.tableView reloadData];
             
             }];
         }];
     }else if (self.bbsM.annexsArr.count == 3){
              self.upImage1 = [[YYAnimatedImageView alloc] init];
              [self.upImage1 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.imgArr[0]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
              } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
         
                  NSMutableDictionary *imagerDic1 = [NSMutableDictionary new];
                  id imageItem1 = [weakSelf.upImage1.image imageDataRepresentation];
                  YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem1));
                  NSString *path1 = nil;
                  if (type == YYImageTypeGIF) {
                      NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                      path1 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                  }else{
                      NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                      path1 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                  }
                  [imagerDic1 setObject:path1 forKey:Locapaths];
                  [imagerDic1 setObject:imageItem1 forKey:ImageDatas];

                  [weakSelf.moveArr addObject:imagerDic1];
                  [weakSelf.tableView reloadData];
              
                  weakSelf.upImage2 = [[YYAnimatedImageView alloc] init];
                  [weakSelf.upImage2 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:weakSelf.imgArr[1]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                  } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                      NSMutableDictionary *imagerDic2 = [NSMutableDictionary new];
                      id imageItem2 = [weakSelf.upImage2.image imageDataRepresentation];
                      YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem2));
                      NSString *path2 = nil;
                      if (type == YYImageTypeGIF) {
                          NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                          path2 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                      }else{
                          NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                          path2 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                      }
                      [imagerDic2 setObject:path2 forKey:Locapaths];
                      [imagerDic2 setObject:imageItem2 forKey:ImageDatas];

                      [weakSelf.moveArr addObject:imagerDic2];
                      [weakSelf.tableView reloadData];
                  
                      weakSelf.upImage3 = [[YYAnimatedImageView alloc] init];
                      [weakSelf.upImage3 setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:weakSelf.imgArr[2]]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                      } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                          [weakSelf hideHUD];
                          NSMutableDictionary *imagerDic3 = [NSMutableDictionary new];
                          id imageItem3= [weakSelf.upImage2.image imageDataRepresentation];
                          YYImageType type = YYImageDetectType((__bridge CFDataRef)(imageItem3));
                          NSString *path3 = nil;
                          if (type == YYImageTypeGIF) {
                              NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                              path3 = [NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                          }else{
                              NSString *path = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
                              path3 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
                          }
                          [imagerDic3 setObject:path3 forKey:Locapaths];
                          [imagerDic3 setObject:imageItem3 forKey:ImageDatas];

                          [weakSelf.moveArr addObject:imagerDic3];
                          [weakSelf.tableView reloadData];
                      
                      }];
                  }];
              }];
     }
}
@end
