//
//  NoticeNewChatVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewChatVoiceView.h"
#import "NoticeAction.h"
#import "NoticeXi-Swift.h"
#import "NoticeChangeTextView.h"
#import "NoticeSysMeassageTostView.h"
#import "NoticeChocieImgListView.h"

@interface NoticeNewChatVoiceView()

@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, assign) BOOL httpOpen;//链接框架打开
@property (nonatomic, strong) NSMutableArray *photoArr;
@end

@implementation NoticeNewChatVoiceView
{
    UIView *_knowView;
}

- (NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [NSMutableArray new];
    }
    return _photoArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.isFirst = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.oldSelectIndex = 7689;
        
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 500)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentView.clipsToBounds = YES;
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = [NoticeTools getLocalStrWith:@"em.hs"];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGTwentyBoldFontSize;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        self.colseBtn = closeBtn;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10+5-10)];
        self.tableView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:0];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeChatsCell class] forCellReuseIdentifier:@"cell"];
        [self.contentView addSubview:self.tableView];
        
        UILabel *footL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
        footL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        footL.font = TWOTEXTFONTSIZE;
        footL.text = [NoticeTools getLocalStrWith:@"long.le"];
        footL.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = footL;
        
        self.localdataArr = [NSMutableArray new];
        self.nolmorLdataArr = [NSMutableArray new];
        self.dataArr = [NSMutableArray new];
        [self createRefesh];
        
        appdel.socketManager.chatDelegate = self;
        
        if (![NoticeComTools ifKnowHsRul]) {
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
            _knowView = [[UIView alloc] initWithFrame:CGRectMake(20, 65, DR_SCREEN_WIDTH-40, 36)];
            _knowView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.5];
            _knowView.layer.cornerRadius = 4;
            _knowView.layer.masksToBounds = YES;
            [self.contentView addSubview:_knowView];
            
            UILabel *slabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _knowView.frame.size.width-45, 36)];
            slabel.text = [NoticeTools getLocalStrWith:@"no.elsesee"];
            slabel.font = TWOTEXTFONTSIZE;
            slabel.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6];
            [_knowView addSubview:slabel];
            
            UIButton *xbutton = [[UIButton alloc] initWithFrame:CGRectMake(_knowView.frame.size.width-10-36, 0, 36, 36)];
            [xbutton setImage:UIImageNamed(@"Image_sendXXtm") forState:UIControlStateNormal];
            [_knowView addSubview:xbutton];
            [xbutton addTarget:self action:@selector(xClick) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        
        _sendView = [[NoticeSendView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50)];
        _sendView.isHs = YES;
        _sendView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sendView.imageView.image = UIImageNamed(@"Image_newmacp");
        _sendView.titleL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _sendView.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
        _sendView.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"group.copylianjie"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
        _sendView.delegate = self;
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        [_sendView.emtionBtn addTarget:self action:@selector(sendEmtionClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.imgBtn addTarget:self action:@selector(sendImagClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.httpBtn addTarget:self action:@selector(httpClick) forControlEvents:UIControlEventTouchUpInside];
        [_sendView.sendBtn addTarget:self action:@selector(sendLinkUrlClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendView];
                    
        UIButton *rulButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-50, 0, 40, 50)];
        [rulButton setImage:UIImageNamed(@"Image_newblackrul") forState:UIControlStateNormal];
        [self.contentView addSubview:rulButton];
        [rulButton addTarget:self action:@selector(rulClick) forControlEvents:UIControlEventTouchUpInside];
        self.rulBtn = rulButton;
        
        self.userInteractionEnabled = YES;
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-self.contentView.frame.size.height+10)];
        tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
        [tapView addGestureRecognizer:tap];
        [self addSubview:tapView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
        _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _emotionView.backgroundColor = self.sendView.backgroundColor;
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            [weakSelf sendEmtionClick];
            if (weakSelf.emtionBlock) {
                weakSelf.emtionBlock(url, buckId, pictureId, isHot);
            }
        };
        _emotionView.pushBlock = ^(BOOL push) {
            [weakSelf closeClick];
        };
        [self.contentView addSubview:_emotionView];
    }
    return _emotionView;
}

- (NoticeChocieImgListView *)imgListView{
    if (!_imgListView) {
        __weak typeof(self) weakSelf = self;
        _imgListView = [[NoticeChocieImgListView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _imgListView.didSelectPhotosMBlock = ^(NSMutableArray * _Nonnull photoArr) {
            [weakSelf sendImagClick];
            weakSelf.photoArr = [NSMutableArray arrayWithArray:photoArr];
            [weakSelf sendImagePhoto];
        };
        [self.contentView addSubview:_imgListView];
    }
    return _imgListView;
}


- (void)sendImagePhoto{
    if (!self.photoArr.count) {
        return;
    }
    PHAsset *asset = self.photoArr[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999999996];
            [self upLoadHeader:imageData path:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]]];
        }];
    }else{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!self.photoArr.count) {
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6) path:pathMd5];
            ;
        }];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path{
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
      
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:weakSelf.toUserId forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:weakSelf.voiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:@"12" forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.voiceM.voice_id}];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            
            if (self.photoArr.count) {
                [self.photoArr removeObjectAtIndex:0];
                if (self.photoArr.count) {
                    [self sendImagePhoto];
                }
            }
        }
    }];
}

- (void)sendLinkUrlClick{
    if (!self.sendView.topicField.text.length || !self.sendView.topicField.text) {
        return;
    }
    NSString *urlStr = self.sendView.topicField.text;
    if (![NoticeTools isWhetherNoUrl:urlStr]) {//存在中文字的话
        NSArray *arr = [NoticeTools getURLFromStr:urlStr];
        if (arr.count) {
             urlStr = arr[0];
        
        }else{
            return;
        }
    }
    
    self.sendView.topicField.text = @"";
    self.sendView.topicField.text = nil;
    NSMutableDictionary *sendDic = [NSMutableDictionary new];
    [sendDic setObject:self.toUserId forKey:@"to"];
    [sendDic setObject:@"singleChat" forKey:@"flag"];
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self.voiceM.voice_id forKey:@"voiceId"];
    [messageDic setObject:@"5" forKey:@"dialogContentType"];
    [messageDic setObject:urlStr forKey:@"shareUrl"];
    [sendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:sendDic];
    
    [self backView];
}

- (void)setIsLead:(BOOL)isLead{
    _isLead = isLead;
    if (isLead) {
        self.sendView.emtionBtn.hidden = YES;
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (![NoticeComTools ifKnowHsRul]){
        self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-10-15-36-keyboardF.size.height);
    }else{
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-10-keyboardF.size.height);
    }
    self.sendView.frame = CGRectMake(0, self.contentView.frame.size.height-50-keyboardF.size.height-20, DR_SCREEN_WIDTH,50);
}

- (void)keyboardDiddisss{
    if (![NoticeComTools ifKnowHsRul]){
        self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
    }else{
        self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
    }
    self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    [self backView];
}

//发链接
- (void)httpClick{
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    if (self.httpOpen) {
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_hslinkimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.sendView.topicField.text = @"";
        [self.sendView.topicField resignFirstResponder];
    }else{
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_linkurl") forState:UIControlStateNormal];
        
        self.sendView.recordButton.hidden = YES;
        self.sendView.textView.hidden = NO;
        [self.sendView.topicField becomeFirstResponder];
    }
    self.httpOpen = !self.httpOpen;
}


- (void)sendEmtionClick{

    if (self.httpOpen) {
    
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_hslinkimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
        [self.sendView.topicField resignFirstResponder];
    }
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    
    if (self.emotionOpen) {
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.backImageViews.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            if (![NoticeComTools ifKnowHsRul]){
                self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
            }else{
                self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
            }
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
        }];
    }else{
        self.backImageViews.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            if (![NoticeComTools ifKnowHsRul]){
                self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-10-15-36-self.emotionView.frame.size.height);
            }else{
                self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-10-self.emotionView.frame.size.height);
            }
            self.sendView.frame = CGRectMake(0, self.contentView.frame.size.height-50-self.emotionView.frame.size.height-20, DR_SCREEN_WIDTH,50);
            self.emotionView.frame = CGRectMake(0,self.contentView.frame.size.height-self.emotionView.frame.size.height-20, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        }];
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
    }
    self.emotionOpen = !self.emotionOpen;
}

//发图片
- (void)sendImagClick{
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    
    if (self.httpOpen) {
    
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_hslinkimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
        [self.sendView.topicField resignFirstResponder];
    }
    
    if (self.imgOpen) {
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            if (![NoticeComTools ifKnowHsRul]){
                self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
            }else{
                self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
            }
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
        }];
    }else{
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            if (![NoticeComTools ifKnowHsRul]){
                self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-10-15-36-self.imgListView.frame.size.height);
            }else{
                self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-10-self.imgListView.frame.size.height);
            }
            self.sendView.frame = CGRectMake(0, self.contentView.frame.size.height-50-self.imgListView.frame.size.height-20, DR_SCREEN_WIDTH,50);
            self.imgListView.frame = CGRectMake(0,self.contentView.frame.size.height-self.imgListView.frame.size.height-20, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        }];
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
      
        [self scroToBottom];
    }
    self.imgOpen = !self.imgOpen;
}
    
- (void)backView{
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.sendView.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        [self.sendView.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
    }
    if (self.httpOpen) {
    
        [self.sendView.httpBtn setImage:UIImageNamed(@"Image_hslinkimg") forState:UIControlStateNormal];
        self.sendView.recordButton.hidden = NO;
        self.sendView.textView.hidden = YES;
        self.httpOpen = NO;
        if (![NoticeComTools ifKnowHsRul]){
            self.tableView.frame = CGRectMake(0,50+15+36,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10-15-36);
        }else{
            self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
        }
        self.sendView.frame = CGRectMake(0,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH, 50);
        [self.sendView.topicField resignFirstResponder];
    }
}

- (void)onStartRecording{
    [self hsClick];
}

- (void)sendTextDelegate{
    if (self.textBlock) {
        self.textBlock(YES);
    }
}

- (void)setIsBack:(BOOL)isBack{
    _isBack = isBack;
    if (isBack) {
        self.rulBtn.hidden = YES;
        self.colseBtn.frame = CGRectMake(20, 13, 24, 24);
        [self.colseBtn setImage:UIImageNamed(@"btn_nav_white") forState:UIControlStateNormal];
    }
}

- (void)rulClick{
    NoticeSysMeassageTostView *tostV = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    NoticeMessage *messM = [[NoticeMessage alloc] init];
    messM.type = @"19";
    messM.title = [NoticeTools getLocalStrWith:@"em.sx"];
    messM.content = [NoticeTools getLocalStrWith:@"em.content"];
    tostV.message = messM;
    [tostV showActiveView];
}

- (void)xClick{
    [_knowView removeFromSuperview];
    [NoticeComTools saveHasClickHs];
    self.tableView.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 480-90-BOTTOM_HEIGHT-10);
}

- (void)refreshData{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"chats/1/%@/%@",self.userId,self.voiceM.voice_id];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"chats/1/%@/%@?lastId=%@",self.userId,self.voiceM.voice_id,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"chats/1/%@/%@",self.userId,self.voiceM.voice_id];
        }
    }
    [self requestWith:url];
    
}

- (void)requestWith:(NSString *)url{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                BOOL alerady = NO;
                for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
                    if ([olM.dialog_id isEqualToString:model.dialog_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [self.nolmorLdataArr addObject:model];
                    [newArr addObject:model];
                }
            }
            
            if (self.nolmorLdataArr.count) {
                //2.倒序的数组
                NSArray *reversedArray = [[self.nolmorLdataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:reversedArray];
                NoticeChats *lastM = self.dataArr[0];
                self.chatId = lastM.chat_id;
                self.lastId = lastM.dialog_id;
            }
            
            if (self.isFirst) {
                NSMutableArray *localArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",self.userId,self.voiceM.voice_id]];
                if ([localArr count]) {
                    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
                    for (NoticeChatSaveModel *chatM in localArr) {
                        NoticeChats *locaChat = [[NoticeChats alloc] init];
                        locaChat.from_user_id = selfUser.user_id;
                        locaChat.content_type = chatM.type;
                        locaChat.resource_url = chatM.type.intValue==1? chatM.voiceFilePath:chatM.imgUpPath;
                        locaChat.isSaveCace = YES;
                        locaChat.avatar_url = selfUser.avatar_url;
                        locaChat.resource_type = chatM.type;
                        locaChat.resource_len = chatM.voiceTimeLen;
                        locaChat.isText = chatM.type.intValue==2?@"1":@"0";
                        locaChat.saveId = chatM.saveId;
                        locaChat.text = chatM.text;
                        [self.localdataArr addObject:locaChat];
                    }
                }
            }
            
            [self.tableView reloadData];
     
            if (self.isFirst) {
                if (self.dataArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
            if (self.isFirst) {
                self.isFirst = NO;
                if (self.dataArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)scroToBottom{
    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)createRefesh{
    
    __weak NoticeNewChatVoiceView *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl refreshData];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;

}

- (void)hsClick{
    [self stopCurrentPlay];
    if (self.hsBlock) {
        self.hsBlock(YES);
    }
}

- (void)stopCurrentPlay{
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 567890;
    [self.tableView reloadData];
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (UIButton *)recoBtn{
    if (!_recoBtn) {
        _recoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, self.sendView.frame.origin.y-122, 129, 122)];
        [_recoBtn setBackgroundImage:UIImageNamed(@"Image_hszhiyin3") forState:UIControlStateNormal];

        [self.contentView addSubview:_recoBtn];
    
    }
    return _recoBtn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isLead = self.isLead;
    NoticeChats *chat = indexPath.section == 0 ? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];
    
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {//第一个要显示时间
            chat.isShowTime = YES;
        }else{
            if (indexPath.row > 0) {//第二个开始做前一个比较
                NoticeChats *beChat = self.dataArr[indexPath.row-1];
                chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
            }
        }
    }else{
        if (!self.dataArr.count) {//如果不存在第一组数据
            if (indexPath.row == 0) {//第一个要显示时间
                chat.isShowTime = YES;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }else{//存在第一组数据
            if (indexPath.row == 0) {
                NoticeChats *firdtChat = self.dataArr[0];
                chat.isShowTime = (chat.created_at.integerValue - firdtChat.created_at.integerValue)>60 ? YES : NO;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }
    }
    
    if (chat.is_self.integerValue) {
        chat.identity_type = [[NoticeSaveModel getUserInfo] identity_type];
    }else{
        chat.identity_type = self.identType;
    }
    cell.chat = chat;
    cell.index = indexPath.row;
    cell.section = indexPath.section;
    cell.delegate = self;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {
        return self.localdataArr.count;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeChats *chat = indexPath.section == 0 ? self.dataArr[indexPath.row]:self.localdataArr[indexPath.row];
    if (chat.cellHeihgt) {
        return chat.cellHeihgt;
    }
    
    if (chat.content_type.intValue == 5) {
        if (chat.needMarkAuto) {
            chat.cellHeihgt = 27+44+26+53;
        }else{
            chat.cellHeihgt = 35+44+53;
        }
    }else{
        if (chat.needMarkAuto) {
            chat.cellHeihgt = 27+44+26+(chat.content_type.intValue != 1?103:10) - (chat.content_type.intValue == 2?70:0);
        }else{
            chat.cellHeihgt = 35+44+(chat.content_type.intValue != 1?103:10)- (chat.content_type.intValue == 2?70:0);
        }
    }
    

    
    return chat.cellHeihgt;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView && section == 0) {
        return DR_SCREEN_WIDTH*44/375;
    }
    return 0;
}


- (void)didReceiveMessage:(id)message{

    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [NoticeChats mj_objectWithKeyValues:message[@"data"]];

    if ([ifDelegate.action isEqualToString:@"delete"]) {
        self.noAuto = YES;//收到对方删除的时候，停止自动播放语音
        [self.audioPlayer stopPlaying];
        for (NoticeChats *chatAll in self.dataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialogId] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.dataArr removeObject:chatAll];
                break;
            }
        }
        
        for (NoticeChats *chatAll in self.localdataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialog_id] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.localdataArr removeObject:chatAll];
                break;
            }
        }
        
        for (NoticeChats *norChat in self.nolmorLdataArr) {
            if ([norChat.dialog_id isEqualToString:chat.dialog_id] || [norChat.dialog_id isEqualToString:chat.dialogId]) {
                [self.nolmorLdataArr removeObject:norChat];
                break;
            }
        }
        
        [self.tableView reloadData];
        return;
    }
    
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
        if (![chat.from_user_id isEqualToString:self.userId] || ![self.voiceM.voice_id isEqualToString:chat.voice_id]) {
            return;
        }
    }
    
    if (![chat.chat_type isEqualToString:@"1"]) {
        return;
    }
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.from_user_id isEqualToString:self.userId]) {//别人发来的消息，判断是否是当前对话人
            return;
        }
    }else{
        self.noAuto = NO;
    }
    
    BOOL alerady = NO;
    for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.dialog_id isEqualToString:chat.dialog_id]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
    }
    self.chatId = chat.chat_id;

    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
   
    }
    return _voicePlayer;
}


- (void)show{

    if (!self.dataArr.count) {
        [self.tableView.mj_header beginRefreshing];
    }
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-480, DR_SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
        if (self.isLead) {
           self.recoBtn.frame = CGRectMake(100, self.sendView.frame.origin.y-122-50, 129, 122);
            NSString *path = [[NSBundle mainBundle] pathForResource:@"25" ofType:@"m4a"];
            [self.voicePlayer startPlayWithUrl:path isLocalFile:YES];
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                self.recoBtn.frame = CGRectMake(100, self.sendView.frame.origin.y-122, 129, 122);
            } completion:nil];
        }
    }];
}

- (void)close{
    [self stopCurrentPlay];
    [self removeFromSuperview];
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
    [self backView];
}

- (void)closeClick{
    [self backView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
    [self stopCurrentPlay];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 500);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
}


- (void)dissMissTap{
    [self backView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
    [self stopCurrentPlay];
    [self removeFromSuperview];
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
}

- (void)palyWithModel:(NoticeChats *)model{
   
    if (self.oldModel) {
        self.oldModel.isPlaying = NO;
        [self.tableView reloadData];
    }
    
    self.oldModel = model;
    
    if ((self.currentIndex != self.oldSelectIndex) || (self.currentSection!= self.oldSection)) {//判断点击的是否是当前视图
        self.oldSelectIndex = self.currentIndex;
        self.oldSection = self.currentSection;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");

        if (!model.read_at.integerValue && !model.is_self.integerValue) {
            [self setAleryRead:model];
        }
    }else{
        DRLog(@"点击的是当前视图");
    }
  
    if (self.isReplay || model.resource_len.integerValue == 1) {
        if (!model.read_at.integerValue && !model.is_self.integerValue) {
            [self setAleryRead:model];
        }
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:model.isSaveCace?YES: NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
       
        }else{

            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{

        if (!weakSelf.isTap) {
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            if (!weakSelf.isClickChonbo) {
                if (!model.is_self.integerValue) {
                    [weakSelf audioNextPlayer];
                }
            }else{
                weakSelf.isClickChonbo = NO;
            }
        }
         weakSelf.isTap = NO;
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
        NoticeChatsCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.oldSection = 1000000;
            model.nowPro = 0;
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowTime = model.resource_len;
           // [weakSelf.tableView reloadData];
        }
        weakSelf.isTap = NO;
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)audioNextPlayer{

    if (self.noAuto) {
        self.noAuto = NO;
        return;
    }
    if (self.currentSection == 0) {//在第一组的时候
        
        if (self.dataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.dataArr[self.currentIndex+1];//获取最后一条信息
            if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
                //[self palyNextWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }else{//到了最后一条的时候，查询第二组是否存在未读消息
            if (self.localdataArr.count) {//如果第二组存在
                self.currentIndex = 0;
                self.currentSection = 1;
                NoticeChats *model = self.localdataArr[0];//获取第二组第一条信息
                if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                    self.currentModel = model;
                    [self palyWithModel:self.currentModel];
                    //[self palyNextWithModel:self.currentModel];
                }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                    self.currentIndex ++;
                    self.currentSection = 1;
                    self.currentModel = model;
                    [self audioNextPlayer];
                }
            }
        }
    }else{//直接在第二组
        if (self.localdataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.localdataArr[self.currentIndex+1];//获取最后一条信息
            if (!model.read_at.integerValue && !model.is_self.integerValue && model.resource_type.intValue == 1) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
              //  [self palyNextWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }
    }
}

- (void)setAleryRead:(NoticeChats *)chat{
    chat.read_at = [NoticeTools getNowTimeTimestamp];
    [self.tableView reloadData];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:[NoticeTools getNowTimeTimestamp] forKey:@"readAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",chat.chat_id,chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
       
        }
    } fail:^(NSError *error) {
    }];
    if (self.stayChat) {
        if (self.stayChat.un_read_num.intValue) {
            self.stayChat.un_read_num = [NSString stringWithFormat:@"%ld",self.stayChat.un_read_num.integerValue-1];
        }
    }
}

- (void)clickBigImageDelegete{
    if (self.stayChat) {
        if (self.stayChat.un_read_num.intValue) {
            self.stayChat.un_read_num = [NSString stringWithFormat:@"%ld",self.stayChat.un_read_num.integerValue-1];
        }
    }
}


- (void)beginDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag section:(NSInteger)section{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}
#pragma Mark - 音频播放模块
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{

    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section{
 
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 10040000;//设置个很大 数值以免冲突
    self.oldSection = 10004000;
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}


- (void)deleteWithIndex:(NSInteger)tag section:(NSInteger)section{
    __weak typeof(self) weakSelf = self;
    NoticeChats *deleteModel = nil;
    if (section == 0) {
        if (tag > self.dataArr.count-1) {
            return;
        }
        deleteModel = self.dataArr[tag];
    }else{
        if (tag > self.localdataArr.count-1) {
            return;
        }
        deleteModel = self.localdataArr[tag];
    }
    self.choiceModel = deleteModel;
    if (deleteModel.is_self.integerValue) {
        if (deleteModel.content_type.intValue == 1) {
            LCActionSheet *sheetd = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndexd) {
                if (buttonIndexd == 2) {
                    [weakSelf backMessage:tag tag:section deleteM:deleteModel];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"yl.schuisheng"],[NoticeTools getLocalStrWith:@"group.back"]]];
            sheetd.delegate = self;
            self.selfSheet = sheetd;
            [sheetd show];
            return;
        }
        LCActionSheet *sheetd = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndexd) {
            if (buttonIndexd == 1) {
                [weakSelf backMessage:tag tag:section deleteM:deleteModel];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"group.back"]]];
        sheetd.delegate = self;
        self.selfSheet = sheetd;
        [sheetd show];
        
    }else{
        if (self.choiceModel.content_type.intValue == 1) {
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"yl.schuisheng"],[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"]]];
            sheet.delegate = self;
            self.juSheet = sheet;
            [sheet show];
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
            } otherButtonTitleArray:@[[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"]]];
            sheet.delegate = self;
            self.juSheet = sheet;
            [sheet show];
        }
        
    }
    
}

- (void)changeToText:(NSString *)diologId{
   
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dialogs/%@/recognitionContent",diologId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
 
        if (success) {
            NoticeChats *textM = [NoticeChats mj_objectWithKeyValues:dict[@"data"]];
            NoticeChangeTextView *changeView = [[NoticeChangeTextView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            changeView.voiceContent = (textM.recognition_content&&textM.recognition_content.length)?textM.recognition_content:@"转文字失败";
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)backMessage:(NSInteger)section tag:(NSInteger)tag deleteM:(NoticeChats *)deleteModel{
    //判断有无，以免对方已经删除
    BOOL hasModel = NO;
    for (NoticeChats *allm in self.dataArr) {
        if ([allm.dialog_id isEqualToString:deleteModel.dialog_id]) {
            hasModel = YES;
            break;
        }
    }
    
    for (NoticeChats *allm in self.localdataArr) {
        if ([allm.dialog_id isEqualToString:deleteModel.dialog_id]) {
            hasModel = YES;
            break;
        }
    }
    
    if (!hasModel) {
        return ;
    }
    
    NSMutableDictionary * dsendDic = [NSMutableDictionary new];
    [dsendDic setObject: [NSString stringWithFormat:@"%@%@",socketADD,self.userId] forKey:@"to"];
    [dsendDic setObject:@"singleChat" forKey:@"flag"];
    [dsendDic setObject:@"delete" forKey:@"action"];
    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self.voiceM.voice_id forKey:@"voiceId"];
    [messageDic setObject:deleteModel.chat_id forKey:@"chatId"];
    [messageDic setObject:deleteModel.dialog_id forKey:@"dialogId"];
    [messageDic setObject:@"1" forKey:@"chatType"];
    [dsendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:dsendDic];
    
    for (NoticeChats *norChat in self.nolmorLdataArr) {
        if ([norChat.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.nolmorLdataArr removeObject:norChat];
            break;
        }
    }
    if ([self.currentModel.dialog_id isEqualToString:deleteModel.dialog_id]) {
        [self.audioPlayer stopPlaying];
    }
    self.noAuto = YES;
    
    for (NoticeChats *allM in self.dataArr) {
        if ([allM.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.dataArr removeObject:allM];
            [self.tableView reloadData];
            break;
        }
    }
    for (NoticeChats *allM in self.localdataArr) {
        if ([allM.dialog_id isEqualToString:deleteModel.dialog_id]) {
            [self.localdataArr removeObject:allM];
            [self.tableView reloadData];
            break;
        }
    }
    if (self.voiceM.voice_id) {
        //撤回悄悄话通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DELETECHATENotification" object:self userInfo:@{@"voiceId":self.voiceM.voice_id}];
    }

}

- (void)failReSendchatM:(NoticeChats *)chat{
    self.reSendChat = chat;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"msg.resend"],[NoticeTools getLocalStrWith:@"msg.back"]]];
    sheet.delegate = self;
    self.failSheet = sheet;
    [sheet show];

}

//删除缓存
- (void)deleteSave:(NoticeChats *)chat{
    for (NoticeChats *locaChat in self.localdataArr) {
        if ([locaChat.saveId isEqualToString:chat.saveId]) {
            NSMutableArray *saveArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",self.userId,self.voiceM.voice_id]];
            for (NoticeChatSaveModel *saveM in saveArr) {
                if ([saveM.saveId isEqualToString:chat.saveId]) {
                    [saveArr removeObject:saveM];
                    [NoticeTools savehsChatArr:saveArr chatId:[NSString stringWithFormat:@"%@%@",self.userId,self.voiceM.voice_id]];
                    break;
                }
            }
            [self.localdataArr removeObject:locaChat];
            break;
        }
    }
    self.reSendChat = nil;
    [self.tableView reloadData];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.failSheet) {
        if (buttonIndex == 1) {
            if (self.reSendBlock) {
                self.reSendBlock(self.reSendChat);
            }
        }else if (buttonIndex == 2){
            [self deleteSave:self.reSendChat];
            self.reSendChat = nil;
        }
        return;
    }
    if (buttonIndex == 3) {
        [self changeToText:self.choiceModel.dialog_id];
    }
    if (self.choiceModel.resource_type.intValue == 2 && buttonIndex == 1) {
        if (self.choiceModel.isSelf) {
            return;
        }else{
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.choiceModel.dialog_id;
            juBaoView.reouceType = @"3";
            [juBaoView showView];
        }
        return;
    }
    if (actionSheet == self.juSheet && buttonIndex == 2) {
        NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
        juBaoView.reouceId = self.choiceModel.dialog_id;
        juBaoView.reouceType = @"3";
        [juBaoView showView];
    }
    if (buttonIndex == 1 && self.choiceModel.content_type.intValue==1) {
        [self collectionHS];
    }
}

- (void)collectionHS{
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT) isLimit:YES];
    _listView.dialogId = self.choiceModel.dialog_id;
    [_listView show];
}

- (void)dissMissList{
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
    [self backView];
    [self removeFromSuperview];
}
@end
