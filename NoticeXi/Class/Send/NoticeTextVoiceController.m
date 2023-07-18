//
//  NoticeTextVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextVoiceController.h"
#import "NoticeKeyBordTopView.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Photos/Photos.h>
#import "NoticeChoicePhotoCell.h"
#import "NoticeTopicViewController.h"
#import "NoticeTextMBSTieleView.h"
#import "NoticeCaoGaoController.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeWhiteVoiceListModel.h"
#import "NoticeTextChoicePutView.h"
#import "NoticeSendTextStatusController.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import "NoticeSendStatusView.h"
#import "NoticeChoiceVoiceStatusController.h"
#import "NoticeVoiceImageView.h"
#import "NoticeTextTopicView.h"
#define Locapaths  @"locapath"
#define ImageDatas  @"ImageDatas"
#import "NoticeXi-Swift.h"
#import "NoticeSysMeassageTostView.h"
#import "NoticeBgmHasChoiceShowView.h"
@interface NoticeTextVoiceController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UITableViewDelegate>
@property (nonatomic, strong) NoticeBgmHasChoiceShowView *zjChoiceView;
@property (nonatomic, strong) UILabel *sendBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NoticeSendVoiceTools *toolsView;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, assign) CGFloat keyBordHeight;
@property (nonatomic, assign) BOOL isOnlySelf;
@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@property (nonatomic, assign) BOOL isMBS;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, assign) BOOL isHasTostsave;
@property (nonatomic, assign) BOOL hasChange;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *isTuijian;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) UIView *imageViewBack;
@property (nonatomic, assign) NSInteger timePercent;
@property (nonatomic, assign) NSInteger timeOutNum;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isHasTostProgross;
@property (nonatomic, assign) BOOL hasChangeSave;
@property (nonatomic, assign) BOOL canRecoder;
@property (nonatomic, assign) BOOL isRecodering;
@property (nonatomic, assign) BOOL needContSet;//是否需要设置偏移量
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) CGFloat hasTitleHeight;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NoticeVoiceStatusDetailModel *statusM;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSString *videoUpStr;
@property (nonatomic, strong) UIImage *videoCoverImage;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) NSInteger statysType;
@property (nonatomic, strong) NoticeVoiceImageView *imageViewS;
@property (nonatomic, strong) NoticeTextTopicView *topicView;
@property (nonatomic, strong) NoticeSendStatusView *statusView;
@property (nonatomic, assign) BOOL hasChangeImg;
@property (nonatomic, assign) NSInteger oldImgNum;
@property (nonatomic, strong) NSString *albumId;
@end

@implementation NoticeTextVoiceController

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
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    if (self.isReEdit) {
        titleL.text = [NoticeTools getLocalStrWith:@"sendTextt.reSend"];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-50)];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomFirstTap)];
    [self.tableView addGestureRecognizer:tap];
    
    self.plaStr = [NoticeTools getLocalStrWith:@"sendTextt.input"];
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,5, DR_SCREEN_WIDTH-30,35)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.scrollEnabled = NO;
    _textView.bounces = NO;
    _textView.backgroundColor = self.view.backgroundColor;
    
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithHexString:@"#25262E"];
    _textView.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    [_tableView addSubview:_textView];
    [_tableView addSubview:_plaL];
    self.phassetArr = [NSMutableArray new];
    self.moveArr = [NSMutableArray new];
    
    self.topicM = nil;

    self.statysType = 0;
    self.toolsView = [[NoticeSendVoiceTools alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.toolsView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.toolsView];
    [self.toolsView.topicButton addTarget:self action:@selector(insertClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.imgButton addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.shareButton addTarget:self action:@selector(needSHareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView.bgmButton setTitle:@"状态" forState:UIControlStateNormal];
    [self.toolsView.bgmButton setImage:UIImageNamed(@"toool_status") forState:UIControlStateNormal];
    if (!self.isReEdit && !self.isSave) {
        [self.toolsView.bgmButton addTarget:self action:@selector(choiceClick) forControlEvents:UIControlEventTouchUpInside];
        self.zjChoiceView.hidden = NO;
        self.zjChoiceView.closeBtn.hidden = YES;
    }
    
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-20-14,20, 20)];
    [webBtn setImage:UIImageNamed(@"ywh_black") forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webBtn];
    
    if (self.isReEdit) {
        [self.toolsView.bgmButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    }
    
    if (self.isReEdit) {
        
        [self setVoiceOpen:self.voiceM.voiceIdentity.intValue-1];
        [self.toolsView.bgmButton setImage:UIImageNamed(@"toool_statusn") forState:UIControlStateNormal];
        if (self.voiceM.title) {
            self.text = [self.voiceM.textContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@\n",self.voiceM.title] withString:@""];
        }else{
            self.text = self.voiceM.textContent;
        }
        
        self.textView.text = self.text;
        
        if (self.voiceM.topic_name) {
            self.topicM = [NoticeTopicModel new];
            self.topicM.topic_name = self.voiceM.topic_name;
            self.topicM.topic_id = self.voiceM.topic_id;
        }
        
        if (self.voiceM.statusM) {
            NoticeVoiceStatusDetailModel *statusM = [NoticeVoiceStatusDetailModel new];
            statusM.audioM = [NoticeVoiceStatusAudioModel new];
            statusM.picture_url = self.voiceM.statusM.picture_url;
            statusM.audioM.audios_url = self.voiceM.statusM.audios_url;
            statusM.describe = self.voiceM.statusM.category_name;
            self.statusView.hidden = NO;
            self.statusView.closeBtn.hidden = YES;
            self.statusView.statusM = statusM;
            [self.audioPlayer startPlayWithUrl:statusM.audioM.audios_url isLocalFile:NO];
            [self startAnimation];
            self.statusM = statusM;
        }
        self.oldImgNum = self.voiceM.img_list.count;
        self.moveArr = [[NSMutableArray alloc] init];
        if (self.voiceM.img_list.count) {
            for (int i = 0; i < self.voiceM.img_list.count; i++) {
                [self showHUD];
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.voiceM.img_list[i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (image) {
                        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                        UIImage *ciImage = image;
                        [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                        [self.moveArr addObject:imagerDic];
                        self.imageViewS.imgArr = self.moveArr;
                        self.imageViewS.hidden = NO;
                        [self setTextViewHeight:self.textView text:@""];
                        [self keyboardHide];
                        [self.textView becomeFirstResponder];
                    }
                    [self hideHUD];
                }];
            }
        }else{
            [self setTextViewHeight:self.textView text:@""];
            [self.textView becomeFirstResponder];
        }

    }else{
        [self.textView resignFirstResponder];
    }
    
    [self comeFromSave];
    
    if (self.topicName || self.topicM) {
        if (!self.topicM) {
            NoticeTopicModel *topic = [[NoticeTopicModel alloc] init];
            topic.topic_name = self.topicName;
            topic.topic_id = self.topicId;
            self.topicM = topic;
        }
        self.topicView.hidden = NO;
        self.topicView.topicM = self.topicM;
        self.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
        if (!self.topicM.topic_id.intValue) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.topicM.topic_name forKey:@"topicName"];
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    self.topicM.topic_id = topicId;
                    [self setTextViewHeight:self.textView text:@""];
                    [self keyboardHide];
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }else{
            [self setTextViewHeight:self.textView text:@""];
            [self keyboardHide];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)webClick{
    NoticeSysMeassageTostView *tostV = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    NoticeMessage *messM = [[NoticeMessage alloc] init];
    messM.type = @"19";
    messM.title = [NoticeTools getLocalStrWith:@"em.sx"];
    messM.content = [NoticeTools getLocalStrWith:@"em.content"];
    tostV.message = messM;
    [tostV showActiveView];
}

- (void)comeFromSave{
    //缓存进来的
    if (self.isSave) {
        [self setVoiceOpen:self.saveModel.voiceIdentity.intValue-1];
        [self.toolsView.bgmButton setImage:UIImageNamed(@"toool_statusn") forState:UIControlStateNormal];
        self.text = self.saveModel.textContent;
        
        self.textView.text = self.text;
        
        if (self.saveModel.topName) {
            self.topicM = [NoticeTopicModel new];
            self.topicM.topic_name = self.saveModel.topName;
            self.topicM.topic_id = self.saveModel.topicId;
        }
     
        self.moveArr = [[NSMutableArray alloc] init];
        if (self.saveModel.img1Path || self.saveModel.img2Path || self.saveModel.img3Path) {
            [self showHUD];
            
            if (self.saveModel.img1Path) {
                [self getsaveimg1];
            }
        }else{
            [self setTextViewHeight:self.textView text:@""];
            [self.textView becomeFirstResponder];
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
                self.imageViewS.imgArr = self.moveArr;
                self.imageViewS.hidden = NO;
                [self setTextViewHeight:self.textView text:@""];
                [self keyboardHide];
                [self.textView becomeFirstResponder];
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
                self.imageViewS.imgArr = self.moveArr;
                self.imageViewS.hidden = NO;
                [self setTextViewHeight:self.textView text:@""];
                [self keyboardHide];
                [self.textView becomeFirstResponder];
                [self hideHUD];
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
            self.imageViewS.imgArr = self.moveArr;
            self.imageViewS.hidden = NO;
            [self setTextViewHeight:self.textView text:@""];
            [self keyboardHide];
            [self.textView becomeFirstResponder];
            [self hideHUD];
        }else{
            [self hideHUD];
        }
        
    }];
}

- (void)becomFirstTap{
    [self.textView becomeFirstResponder];
}

- (void)setVoiceOpen:(NSInteger)type{
    self.statysType = type;
    if (type == 0) {
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-66,10, 66, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.open"] forState:UIControlStateNormal];
    }else if (type == 1){
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-90,10, 90, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.tpkjian"] forState:UIControlStateNormal];
    }else{
        self.toolsView.shareButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-102,10, 102, 25);
        [self.toolsView.shareButton setTitle:[NoticeTools getLocalStrWith:@"n.onlyself"] forState:UIControlStateNormal];
    }
}

- (void)needSHareClick{
    NoticeChoiceVoiceStatusController *ctl = [[NoticeChoiceVoiceStatusController alloc] init];
    ctl.type = self.statysType;
    __weak typeof(self) weakSelf = self;
    ctl.typeBlock = ^(NSInteger type) {
        [weakSelf setVoiceOpen:type];

    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)imgTap:(UITapGestureRecognizer *)tap{
    [self.textView resignFirstResponder];
    UIImageView *imageV = (UIImageView *)tap.view;
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = imageV;
    item.largeImageURL = [NSURL URLWithString:self.voiceM.img_list[imageV.tag]];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:imageV
                   toContainer:toView
                      animated:YES completion:nil];
}

- (NoticeBgmHasChoiceShowView *)zjChoiceView{
    if (!_zjChoiceView) {
        _zjChoiceView = [[NoticeBgmHasChoiceShowView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-16-20, DR_SCREEN_WIDTH-40, 20)];
        [self.view addSubview:_zjChoiceView];
        _zjChoiceView.isaddSend = YES;
        _zjChoiceView.nameView.backgroundColor = self.view.backgroundColor;
        _zjChoiceView.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _zjChoiceView.backgroundColor = self.view.backgroundColor;
        _zjChoiceView.closeBtn.hidden = YES;
        _zjChoiceView.title = @"加入专辑";
        _zjChoiceView.markImageView.image = UIImageNamed(@"Image_voiczjnoin");
        [_zjChoiceView.closeBtn addTarget:self action:@selector(closezjClick) forControlEvents:UIControlEventTouchUpInside];
        _zjChoiceView.nameView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToZJ)];
        [_zjChoiceView.nameView addGestureRecognizer:tap];
    }
    return _zjChoiceView;
}

- (void)addToZJ{
    __weak typeof(self) weakSelf = self;
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _listView.isSendVoiceAdd = YES;
    _listView.addSuccessBlock = ^(NoticeZjModel * _Nonnull model) {
        weakSelf.albumId = model.albumId;
        weakSelf.zjChoiceView.isaddSend = YES;
        weakSelf.zjChoiceView.title = model.album_name;
        weakSelf.zjChoiceView.closeBtn.hidden = NO;
        weakSelf.zjChoiceView.markImageView.image = UIImageNamed(@"Image_voiczjnoiny");
    };
    [_listView show];
}

- (void)closezjClick{
    self.zjChoiceView.title = @"加入专辑";
    self.zjChoiceView.closeBtn.hidden = YES;
    self.zjChoiceView.markImageView.image = UIImageNamed(@"Image_voiczjnoin");
    self.albumId = nil;
}

- (void)choiceClick{

    NoticeSendTextStatusController *ctl = [[NoticeSendTextStatusController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.statusBlock = ^(NoticeVoiceStatusDetailModel * _Nonnull statusM) {
        weakSelf.statusView.statusM = statusM;
        weakSelf.statusView.hidden = NO;
        [weakSelf.audioPlayer startPlayWithUrl:statusM.audioM.audios_url isLocalFile:NO];
        [weakSelf startAnimation];
        weakSelf.statusM = statusM;
        weakSelf.statusView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, weakSelf.statusView.frame.size.width, 20);
        weakSelf.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
        [weakSelf keyboardHide];
    };

    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)insertClick{
    self.isFromActivity = NO;
 
    NoticeTopicViewController *ctl = [[NoticeTopicViewController alloc] init];
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_HEIGHT, 50);
     __weak typeof(self) weakSelf = self;
    ctl.topicBlock = ^(NoticeTopicModel * _Nonnull topic) {
        weakSelf.hasChangeSave = YES;
        weakSelf.topicM = topic;
        weakSelf.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_HEIGHT, 50);
        if (!topic.topic_id) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:topic.topic_name forKey:@"topicName"];
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    topic.topic_id = topicId;
                    weakSelf.topicM = topic;
                    weakSelf.topicView.hidden = NO;
                    weakSelf.topicView.topicM = weakSelf.topicM;
                    weakSelf.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
                    [weakSelf keyboardHide];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
            return ;
        }
        weakSelf.topicView.hidden = NO;
        weakSelf.topicView.topicM = weakSelf.topicM;
        weakSelf.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
        [weakSelf keyboardHide];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)closeTopicClick{
    self.topicM = nil;
    self.topicView.hidden = YES;
    self.hasChangeSave = YES;
}

- (NoticeSendStatusView *)statusView{
    if (!_statusView) {
        _statusView = [[NoticeSendStatusView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 20)];
        _statusView.backgroundColor = self.view.backgroundColor;
        _statusView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTap)];
        [_statusView addGestureRecognizer:tap];
        [_statusView.closeBtn addTarget:self action:@selector(closeStatusClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_statusView];
        _statusView.hidden = YES;
    }
    return _statusView;
}


- (NoticeVoiceImageView *)imageViewS{
    if (!_imageViewS) {
        _imageViewS = [[NoticeVoiceImageView alloc] initWithFrame:CGRectMake(15, 15, self.tableView.frame.size.width-30, self.tableView.frame.size.width-30)];
        _imageViewS.isLocaImage = YES;
        _imageViewS.layer.cornerRadius = 10;
        _imageViewS.layer.masksToBounds = YES;
        [self.tableView addSubview:_imageViewS];
        _imageViewS.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _imageViewS.imgBlock = ^(NSInteger tag) {
            if (tag <= weakSelf.moveArr.count-1) {
                weakSelf.hasChangeSave = YES;
                [weakSelf.moveArr removeObjectAtIndex:tag];
                if (weakSelf.moveArr.count) {
                    weakSelf.imageViewS.imgArr = [NSArray arrayWithArray:weakSelf.moveArr];
                }else{
                    weakSelf.imageViewS.hidden = YES;
                    [weakSelf keyboardHide];
                }
                [weakSelf.toolsView.imgButton setImage:UIImageNamed(weakSelf.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
            }
            
        };
    }
    return _imageViewS;
}

- (NoticeTextTopicView *)topicView{
    if (!_topicView) {
        _topicView = [[NoticeTextTopicView alloc] initWithFrame:CGRectMake(0,_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20)];
        [self.tableView addSubview:_topicView];
        _topicView.backgroundColor = self.view.backgroundColor;
        _topicView.hidden = YES;
        [_topicView.closeBtn addTarget:self action:@selector(closeTopicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topicView;
}

//打开相册
- (void)openPhotoClick{

    if (self.moveArr.count >= 3) {
        [self showToastWithText:@"最多只能选择三张图片哦~"];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.moveArr.count delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    if ([NoticeTools isManager]) {
        imagePicker.allowPickingVideo = YES;
        imagePicker.allowPickingMultipleVideo = NO;
    }
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    self.isRecodering = NO;

    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!self.isRecodering) {
        self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.toolsView.frame.size.height-10, DR_SCREEN_HEIGHT, 60);
    }
    
    self.keyBordHeight = keyboardF.size.height;
    _plaL.frame = CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14);
    self.imageViewS.frame = CGRectMake(15, -self.imageViewS.frame.size.height-50-10, self.imageViewS.frame.size.width, self.imageViewS.frame.size.width);
    self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    [self setTextViewHeight:self.textView text:@""];
}

- (void)keyboardHide{
    if (self.isRecodering) {
        return;
    }
    self.imageViewS.frame = CGRectMake(15, 15, self.tableView.frame.size.width-30, self.tableView.frame.size.width-30);
    _plaL.frame = CGRectMake(19, 15+(self.imageViewS.hidden?0: CGRectGetMaxY(self.imageViewS.frame)), DR_SCREEN_WIDTH-19-5, 14);
    self.textView.frame = CGRectMake(15,5 +(_imageViewS.hidden?0:CGRectGetMaxY(_imageViewS.frame)), DR_SCREEN_WIDTH-30,(self.textHeight>35?self.textHeight:35));
    self.toolsView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50);
    self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height+(self.statusView.hidden?0:40)+(self.topicView.hidden?0:40)+(self.imageViewS.hidden?0:DR_SCREEN_WIDTH-30+15));
    self.statusView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, self.statusView.frame.size.width, 20);
    self.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
    
    [self.toolsView.imgButton setImage:UIImageNamed(self.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
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
        self.textView.frame = CGRectMake(15,self.tableView.frame.size.height-curSelectHeight-canLookHeight, DR_SCREEN_WIDTH-30,self.textHeight);
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    }else{
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
        self.textView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-30,(self.textHeight>35?self.textHeight:35));
    }
    self.statusView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame)+10, self.statusView.frame.size.width, 20);
    self.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
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

    return [self getSpaceLabelHeight:strText withFont:SIXTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30]+20;

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

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.hasChangeImg = YES;
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
                    self.isVideo = NO;
                }else{
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    UIImage *ciImage = [UIImage imageWithData:imageData];
                    [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
                    self.isVideo = NO;
                }
                self.hasChangeSave = YES;
                [self.moveArr addObject:imagerDic];
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                self.imageViewS.hidden = NO;
                [self keyboardHide];
            }];
        });
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
        self.isVideo = YES;
        self.videoPath = outputPath;
        self.videoCoverImage = coverImage;
    } failure:^(NSString *errorMessage, NSError *error) {
        
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset{
    self.hasChangeImg = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (!imageData) {
            [self showToastWithText:@"图片选择失败"];
            return ;
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        [imagerDic setObject:imageData forKey:ImageDatas];
        [imagerDic setObject:@"1" forKey:@"type"];
        self.isVideo = NO;
        [self.moveArr addObject:imagerDic];
        
        self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
        self.imageViewS.hidden = NO;
        [self keyboardHide];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
    [self.audioPlayer stopPlaying];
    [self stopAnimtion];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)backClick{
    [_textView resignFirstResponder];
    if (self.isReEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_textView.text.length || self.moveArr.count) {
        if (self.isSave) {
            if (self.hasChangeSave || (![self.saveModel.textContent isEqualToString:self.textView.text]) || (self.saveModel.voiceIdentity.intValue-1 != self.statysType)) {
                
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
                    weakSelf.deleteSaveModelBlock(weakSelf.index, YES);
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

- (BOOL)isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (void)sendClick{
    if (self.textView.text.length > 3000) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali1"]];
        return;
    }

    if (!self.textView.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali2"]];
        return;
    }
    
    if ([self isEmpty:self.textView.text]) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali3"]];
        return;
    }
    if (self.isReEdit) {

        if (!self.topicM.topic_id.intValue && self.topicM.topic_name) {
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.topicM.topic_name forKey:@"topicName"];
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topics" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    NSString *topicId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                    self.topicM.topic_id = topicId;
                    [self editVoice:nil];
                }
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            return;
        }
        if (self.moveArr.count) {
            [self updateImage];
            return;
        }
        [self editVoice:nil];
        return;
    }
    if (self.isVideo) {
        [self upVideo];
    }else{
        if (self.moveArr.count) {//判断是否有图片
            [self updateImage];
        }else{
            [self updateVoice];
        }
    }
}

- (void)upVideo{
    [self showHUD];
    self.timePercent = 0;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    self.isHasTostsave = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    _sendBtn.enabled = NO;
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.mp4",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.videoPath]]];
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"5" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    DRLog(@"视频地址%@  md5:%@",self.videoPath,pathMd5);
    _sendBtn.enabled = NO;
    
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.videoPath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            if (self.timeOutNum >= 35 || self.isHasTostsave) {
                [self timerinvalidate];
                return ;
            }
            self.bucket_id = bucketId;
            self.videoUpStr = Message;
            [self updateVoice];
        }else{
            [self showToastWithText:@"上传视频失败"];
        }
    }];
}

- (void)timerinvalidate{
    self.timeOutNum = 0;
    [self.timer invalidate];
    self.timePercent = 20;
    self.isHasTostProgross = NO;
    [self hideHUD];
}

- (void)backSucdess{
    
    [self showToastWithText:[NoticeTools getLocalStrWith:@"py.sendsus"]];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        if (weakSelf.isFromActivity && weakSelf.statysType != 3) {
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock(YES);
            }
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGETHEROOTSELECTTEXT" object:self userInfo:@{@"voiceStatus":[NSString stringWithFormat:@"%ld",self.statysType+1]}];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    });

}

- (void)timeChange{

    if (self.isHasTostProgross) {
        self.timeOutNum = 0;
        [self.timer invalidate];
        return;
    }
    self.timeOutNum ++;
    if (self.timeOutNum >= 10  && self.timeOutNum <= 35) {
        [self showHUDWithText:[NSString stringWithFormat:@"%ld%%",self.timePercent+=4]];
    }
    
    if (self.timeOutNum >= 35) {
        [self.timer invalidate];
        [self hideHUD];
        return;
    }
}

- (void)editVoice:(NSString *)titleId{
    [self.timer invalidate];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.topicM) {
        self.voiceM.topic_name = self.topicM.topic_name;
        self.voiceM.topic_id = self.topicM.topic_id;
        if (self.voiceM.topic_id && self.voiceM.topic_id.length) {
            [parm setObject:self.voiceM.topic_id forKey:@"topicId"];
        }
    }else{
        [parm setObject:@"0" forKey:@"topicId"];
    }
    [parm setObject:[NSString stringWithFormat:@"%ld",self.statysType+1] forKey:@"voiceIdentity"];
    [parm setObject:self.textView.text forKey:@"voiceContent"];
    [parm setObject:[NSString stringWithFormat:@"%ld",self.textView.text.length] forKey:@"contentLen"];
    if (self.imageJsonString) {
        [parm setObject:self.imageJsonString forKey:@"voiceImg"];
        [parm setObject:self.bucket_id forKey:@"bucketId"];
    }
    if (self.voiceM.title) {
        self.voiceM.voice_content = [NSString stringWithFormat:@"%@\n%@",self.voiceM.title,self.textView.text];
    }else{
        self.voiceM.voice_content =  self.textView.text;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v5.2.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            NSDictionary *dic = dict[@"data"];
            if (dic) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTICEREEDITVOICENotification" object:self userInfo:@{@"data":dic}];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATIONtext" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)updateVoice{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.bucketId?self.bucketId:@"0" forKey:@"bucketId"];
    [parm setObject:@"2" forKey:@"contentType"];
    [parm setObject:[NSString stringWithFormat:@"%ld",self.textView.text.length] forKey:@"contentLen"];
    [parm setObject:self.textView.text forKey:@"voiceContent"];
    [parm setObject:[NSString stringWithFormat:@"%ld",self.statysType+1] forKey:@"voiceIdentity"];
    if (self.statusM) {
        [parm setObject:self.statusM.picture_id forKey:@"stateId"];
    }
    if (self.isVideo) {
        [parm setObject:self.videoUpStr forKey:@"voiceImg"];
        [parm setObject:@"2" forKey:@"attrType"];
    }else{
        if (self.moveArr.count && self.imageJsonString) {
            [parm setObject:self.imageJsonString forKey:@"voiceImg"];
            [parm setObject:@"1" forKey:@"attrType"];
            UIImage *image =  [UIImage sd_imageWithGIFData:[self.moveArr[0] objectForKey:@"ImageDatas"]];
            if (image.size.height > 0 && image.size.width > 0) {
                [parm setObject:[NSString stringWithFormat:@"%f",image.size.height/image.size.width] forKey:@"scale"];
            }else{
                [parm setObject:@"1" forKey:@"scale"];
            }
        }
    }
    
    if (self.albumId) {
        [parm setObject:self.albumId forKey:@"albumId"];
    }
    

    if (self.topicM) {
        if (self.topicM.topic_id) {
            [parm setObject:self.topicM.topic_id forKey:@"topicId"];
        }
    }
    [parm setObject: @"2" forKey:@"voiceType"];
    _sendBtn.userInteractionEnabled = NO;
    [self.timer invalidate];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self timerinvalidate];
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
            if (self.deleteSaveModelBlock) {
                self.deleteSaveModelBlock(self.index,YES);
            }
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self backSucdess];
                return ;
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWSHENGXINOTICETION" object:nil];
            [self backSucdess];
        }else{
            [self hideHUD];
            if (self.isSave) {
                if (self.deleteSaveModelBlock) {
                    self.deleteSaveModelBlock(self.index,NO);
                }
             
                [self saveTocaogao];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            if (!self.isReEdit) {
                [self caaceSave];
            }
        }
    } fail:^(NSError *error) {
        [self hideHUD];
        [self timerinvalidate];
        self->_sendBtn.userInteractionEnabled = YES;
        if (self.isSave) {
            if (self.deleteSaveModelBlock) {
                self.deleteSaveModelBlock(self.index,NO);
            }
            [self saveTocaogao];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (!self.isReEdit) {
            [self caaceSave];
        }
    }];
}

- (void)updateImage{
    [self showHUD];
    
    self.timePercent = 0;
    self.timeOutNum = 0;
    self.isHasTostsave = NO;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    _sendBtn.userInteractionEnabled = NO;
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];
    for (NSMutableDictionary *dic in self.moveArr) {
        [arr addObject:[dic objectForKey:Locapaths]];
        [arr1 addObject:[dic objectForKey:ImageDatas]];
    }
    
    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"5" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 
    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            [self hideHUD];
            self.isHasTostProgross = YES;
            [self.timer invalidate];
            if (!self.isReEdit && !self.isSave) {
                [self caaceSave];
            }
            if (self.isSave) {
                if (self.deleteSaveModelBlock) {
                    self.deleteSaveModelBlock(self.index,NO);
                }
             
                [self saveTocaogao];
                [self.navigationController popViewControllerAnimated:YES];
            }
            return ;
        }else{
            if (self.timeOutNum >= 35) {
                [self timerinvalidate];
                if (!self.isReEdit && !self.isSave) {
                    [self caaceSave];
                }
                return ;
            }
            self.bucketId = bucketId;
            self.bucket_id = bucketId;
            self.imageJsonString = Message;
            if (self.isReEdit) {
                [self editVoice:nil];
            }else{
                [self updateVoice];
            }
        }
    }];
}

- (void)caaceSave{//缓存发送失败的心情
    [_textView resignFirstResponder];
    if (self.isHasTostsave) {
        return;
    }
    self.isHasTostsave = YES;
    __weak typeof(self) weakSelf = self;
    NSString *str = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"sendTextt.cace"]:@"是否將心情保留到離線緩存?\n(重新發布：設置-草稿箱)";
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"em.fail"]:@"心情發布失敗" message:str sureBtn:[NoticeTools getLocalStrWith:@"em.save"] cancleBtn:[NoticeTools getLocalStrWith:@"py.dele"] right:YES];
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
    NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getVoiceArrary];
    NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
    saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
    saveM.textContent = self.textView.text;
    if (self.topicM) {
        saveM.topName = self.topicM.topic_name;
        if (self.topicM.topic_id) {
            saveM.topicId = self.topicM.topic_id;
        }
    }
    saveM.voiceIdentity = [NSString stringWithFormat:@"%ld",self.statysType+1];
    saveM.contentType = @"2";
    if (self.statusM) {
        saveM.stateId = self.statusM.picture_id;
    }
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
    [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];

}

- (void)cachaSuccdss{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"sendTextt.save"] message:[NoticeTools getLocalStrWith:@"sendTextt.tosetlook"] sureBtn:[NoticeTools getLocalStrWith:@"sendTextt.look"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NoticeCaoGaoController *ctl = [[NoticeCaoGaoController alloc] init];
            ctl.backToRoot = YES;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

//关闭状态
- (void)closeStatusClick{
    self.statusView.hidden = YES;
    [self.audioPlayer stopPlaying];
    self.statusM = nil;
    self.topicView.frame = CGRectMake(0,!_statusView.hidden?(CGRectGetMaxY(_statusView.frame)+10):(CGRectGetMaxY(self.textView.frame)+10), DR_SCREEN_WIDTH, 20);
}

//改变状态
- (void)changeTap{
    if (self.isReEdit) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf.audioPlayer stopPlaying];
            [weakSelf.audioPlayer startPlayWithUrl:weakSelf.statusM.audioM.audios_url isLocalFile:NO];
            [weakSelf startAnimation];
        }else if (buttonIndex == 2){
            [weakSelf choiceClick];
        }else if (buttonIndex == 3){
            [weakSelf closeStatusClick];
        }
    } otherButtonTitleArray:self.isReEdit?@[[NoticeTools getLocalStrWith:@"sendTextt.replay"]]: @[[NoticeTools getLocalStrWith:@"sendTextt.replay"],[NoticeTools getLocalStrWith:@"sendTextt.changestatus"],[NoticeTools getLocalStrWith:@"sendTextt.closestatus"]]];
    [sheet show];
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
        __weak typeof(self) weakSelf = self;
        _audioPlayer.playComplete = ^{
            [weakSelf stopAnimtion];
        };
    }
    return _audioPlayer;
}



- (void)startAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    [self.statusView.musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimtion{
    [self.statusView.musicImageView.layer removeAllAnimations];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}


@end
