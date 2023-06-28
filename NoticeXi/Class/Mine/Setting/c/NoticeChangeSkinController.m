//
//  NoticeChangeSkinController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/3.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeSkinController.h"
#import "NoticeSmallSkinCell.h"
#import "NoticeCurentLeaveController.h"
#import "SVGA.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@interface NoticeChangeSkinController ()<TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat effect;
@property (nonatomic, assign) CGFloat alphValue;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UISlider *effectSlider;
@property (nonatomic, strong) UISlider *alphaSlider;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) NSString *filepath;
@property (nonatomic, strong) UIImage *cutsumeImg;

@property (nonatomic, strong) UIButton *defaultBtn;
@property (nonatomic, strong) UIButton *cutsumeBtn;
@property (nonatomic, strong) UIButton *blackBtn;
@property (nonatomic, strong) UIImageView *defaultImgView;
@property (nonatomic, strong) UIImageView *cutsumeImgView;
@property (nonatomic, strong) UIImageView *blackImgView;

@property (nonatomic, strong) UIImageView *choiceImg;
@property (nonatomic, strong) UIButton *oldBtn;

@property (nonatomic, strong) UILabel *alphaL;
@property (nonatomic, strong) UILabel *effectL;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL is_unlock;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NoticeSkinModel *choiceM;
@property (nonatomic, strong) UIImage *zsImage;
@property (nonatomic, strong) UIImageView *fgImgV;

@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;
@property (nonatomic, strong) NSString *skinId;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation NoticeChangeSkinController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 64+20;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _tableView.frame =  CGRectMake(20, CGRectGetMaxY(self.backImageView.frame)+30,DR_SCREEN_WIDTH-40, 64+15);
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_tableView registerClass:[NoticeSmallSkinCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"skin.zdy"];
    if (self.type == 0) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"skin.mr"];
    }
    if (self.type == 2) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"skin.black"];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:userM.spec_bg_photo_url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (data) {
            UIImage *gqImage = [UIImage imageWithData:data];
            appdel.custumeImg = gqImage;
        }
    }];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    navView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:navView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-120, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = self.navigationItem.title;
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [backBtn setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-55, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [sureBtn setTitle:[NoticeTools getLocalStrWith:@"songList.use"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [sureBtn setTitleColor:[[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [navView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(useClick) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn = sureBtn;
    
    CGFloat widht = (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-188-10-70)*750/1624;
    
    self.effect = appdel.effect > 0?appdel.effect:0.1;
    self.alphValue = appdel.alphaValue > 0?appdel.alphaValue:0.3;
    if (self.type != 1) {
        self.alphValue = self.alphValue > 0.8?0.8:self.alphValue;
    }
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-widht)/2, 10+NAVIGATION_BAR_HEIGHT, widht, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-188-10-70)];

    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    [self.view addSubview:self.backImageView];
    self.backImageView.layer.cornerRadius = 15;
    self.backImageView.layer.masksToBounds = YES;
    
    self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:self.backImageView.bounds];
    _svagPlayer.loops = INT16_MAX;
    _svagPlayer.clearsAfterStop = YES;
    _svagPlayer.contentMode = UIViewContentModeScaleAspectFill;
    _svagPlayer.clipsToBounds = YES;
    self.parser = [[SVGAParser alloc] init];

    [self.backImageView addSubview:self.svagPlayer];
    
    self.mbView = [[UIView alloc] initWithFrame:self.backImageView.bounds];
    self.mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.alphValue];
  
    [self.backImageView addSubview:self.mbView];
    
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *allTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTap)];
    [self.backImageView addGestureRecognizer:allTap];
    
    UIImageView *fgImageView = [[UIImageView alloc] initWithFrame:self.backImageView.bounds];
    fgImageView.image = UIImageNamed(@"minetouming");
    self.fgImgV = fgImageView;
    [self.backImageView addSubview:fgImageView];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-118)/2, CGRectGetMaxY(self.backImageView.frame)+15, 118, 27)];
    changeBtn.layer.cornerRadius = 27/2;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.borderColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6].CGColor;
    changeBtn.layer.borderWidth = 1;
    [changeBtn setTitle:[NoticeTools getLocalStrWith:@"skin.changeback"] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [changeBtn setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
    [self.view addSubview:changeBtn];
    [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    self.changeButton = changeBtn;
    changeBtn.hidden = YES;
    
    if (self.type == 1) {
        self.changeButton.hidden = NO;
    }

    if (!self.type) {
        [self.parser parseWithNamed:@"paopao" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
            [self.svagPlayer startAnimation];
        } failureBlock:nil];
    }

    if (self.type != 2) {
        for (int i = 0; i < 2; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.changeButton.frame)+85+35*i, 35, 35)];
            label.text = i==0?[NoticeTools getLocalStrWith:@"skin.tmd"]:[NoticeTools getLocalStrWith:@"skin.mhd"];
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            label.font = ELEVENTEXTFONTSIZE;
            [self.view addSubview:label];
            if (i==0) {
                self.alphaL = label;
            }else{
                self.effectL = label;
            }
            UISlider *_slider = [[UISlider alloc] initWithFrame:CGRectMake(20+40,label.frame.origin.y, DR_SCREEN_WIDTH-40-20-20, 35)];
            _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#25262E"];
            [_slider setThumbImage:UIImageNamed(@"Image_tmslikedr") forState:UIControlStateNormal];
            _slider.alpha = 0.8;

            _slider.tag = i;
            [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:_slider];
            if (i == 0) {
                _slider.value = self.alphValue;
                self.alphaSlider = _slider;
                _slider.minimumValue = 0.3;
                _slider.maximumValue = 0.8;
            }else{
                _slider.minimumValue = 0.02;
                _slider.maximumValue = 0.3;
                _slider.value = self.effect;
                self.effectSlider = _slider;
            }
        }
    }

    if (self.type == 3) {
        self.isDown = YES;
        self.pageNo = 1;
        titleL.text = [NoticeTools getLocalStrWith:@"skin.sx"];
        self.dataArr = [[NSMutableArray alloc] init];
        [self.view addSubview:self.tableView];
      
        NoticeSkinModel *model = self.skinModel;
        self.choiceM.isSelect = NO;
        self.choiceM = model;
        model.isSelect = YES;
        self.skinId = self.skinModel.skinId;
        [self.tableView reloadData];
        [self showHUD];
        dispatch_async(globalQueue,^{
          //子线程下载图片
              NSURL *url=[NSURL URLWithString:model.image_url];
              NSData *data=[NSData dataWithContentsOfURL:url];
          //将网络数据初始化为UIImage对象
              UIImage *image=[UIImage imageWithData:data];
              if(image!=nil){
                  self.zsImage = image;
              //回到主线程设置图片，更新UI界面
                  dispatch_async(mainQueue,^{
                      if (self.zsImage) {
                          self.backImageView.image = [UIImage boxblurImage:self.zsImage withBlurNumber:self.effect];
                          [self.parser parseWithURL:[NSURL URLWithString:model.svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                              self.svagPlayer.videoItem = videoItem;
                              [self.svagPlayer startAnimation];
                          } failureBlock:nil];
                      }
                      [self hideHUD];
                  });
              }else{
                  dispatch_async(mainQueue,^{
                      [self hideHUD];
                  });
              }
            
          });
        
        [self request];
    }
    [self typeClick];
    
    [self.view bringSubviewToFront:self.backImageView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundEffect = nil;
        appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }else{
    
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#14151A"];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)allTap{
    self.isAll = !self.isAll;
    if (self.isAll) {
        self.backBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.backImageView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
            self.fgImgV.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
            self.mbView.frame = self.fgImgV.frame;
            self.svagPlayer.frame = self.fgImgV.frame;
        }];
    }else{
        self.backBtn.hidden = NO;
        self.sureBtn.hidden = NO;
        CGFloat widht = (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-188-10-70)*750/1624;
        [UIView animateWithDuration:0.5 animations:^{
            self.backImageView.frame = CGRectMake((DR_SCREEN_WIDTH-widht)/2, 10+NAVIGATION_BAR_HEIGHT, widht, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-188-10-70);
            self.fgImgV.frame = CGRectMake(0, 0, widht, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-188-10-70);
            self.mbView.frame = self.fgImgV.frame;
            self.svagPlayer.frame = self.fgImgV.frame;
        }];
    }
}

- (void)request{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=1"];
    }else{
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=%ld",self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"][@"skin_list"]) {
                NoticeSkinModel *model = [NoticeSkinModel mj_objectWithKeyValues:dic];
                if ([model.skinId isEqualToString:self.skinId]) {
                    model.isSelect = YES;
                    self.choiceM = model;
                }
                [self.dataArr addObject:model];
                hasData = YES;
            }
            [self.tableView reloadData];
            if (hasData) {
                self.isDown = NO;
                self.pageNo++;
                [self request];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSmallSkinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    if (indexPath.row <= self.dataArr.count-1 && self.dataArr.count) {
        cell.skinModel = self.dataArr[indexPath.row];
    }else{
        cell.lelveL.hidden = YES;
        cell.backImageView.image =  UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_qingqidai"]);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArr.count) {
        return;
    }
    self.skinId = nil;
    NoticeSkinModel *model = self.dataArr[indexPath.row];
    self.choiceM.isSelect = NO;
    self.choiceM = model;
    model.isSelect = YES;
    [self.tableView reloadData];
    [self showHUD];
    dispatch_async(globalQueue,^{
      //子线程下载图片
          NSURL *url=[NSURL URLWithString:model.image_url];
          NSData *data=[NSData dataWithContentsOfURL:url];
      //将网络数据初始化为UIImage对象
          UIImage *image=[UIImage imageWithData:data];
          if(image!=nil){
              self.zsImage = image;
          //回到主线程设置图片，更新UI界面
              dispatch_async(mainQueue,^{
                  self.backImageView.image = [UIImage boxblurImage:self.zsImage withBlurNumber:self.effect];
                  [self.parser parseWithURL:[NSURL URLWithString:model.svg_url] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
                      self.svagPlayer.videoItem = videoItem;
                      [self.svagPlayer startAnimation];
                  } failureBlock:nil];
                  [self hideHUD];
              });
          }else{
              dispatch_async(mainQueue,^{
                  [self hideHUD];
              });
          }
      });
}

- (void)typeClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.type == 1) {
        if (appdel.custumeImg) {
            self.backImageView.image = [UIImage boxblurImage:appdel.custumeImg withBlurNumber:self.effect];
        }else{
            if (self.cutsumeImg || appdel.backImg) {
                self.backImageView.image = [UIImage boxblurImage:self.cutsumeImg?self.cutsumeImg:appdel.backImg withBlurNumber:self.effect];
            }
        }
        self.changeButton.hidden = NO;
    }else{
        self.changeButton.hidden = YES;
    }
    
    if (self.type == 0) {
        if (appdel.backDefaultImg) {
            self.backImageView.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:self.effect];
        }
    }
    
    if (self.type == 2) {
        self.mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        self.alphaSlider.hidden = YES;
        self.effectSlider.hidden = YES;
    }else{
        
        self.alphaSlider.hidden = NO;
        self.effectSlider.hidden = NO;
    }
    self.alphaL.hidden = self.alphaSlider.hidden;
    self.effectL.hidden = self.alphaSlider.hidden;
}

- (void)changeClick{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self presentViewController:imagePicker animated:YES completion:nil];
   
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    self.cutsumeImg = choiceImage;
    self.backImageView.image = self.cutsumeImg;
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
            self.filepath = filePath;
            
        }else{
            self.filepath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {

        path = [NSString stringWithFormat:@"%@_%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
    }
    
    [self showHUD];
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"60" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"specBgPhotoUrl"];
            [parm setObject:@"2" forKey:@"specBgType"];
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }
           
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appdel.custumeImg = image;
                    appdel.backImg = image;
                    if (appdel.backImg) {
                        self.backImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:self.effect];
                    }
                    [self requestUserInfo];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        
        }else{
            [self hideHUD];
        }
    }];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//滑动进度条
- (void)handleSlide:(UISlider *)slider{

    if (slider.tag == 0) {
        self.alphValue = slider.value;
        DRLog(@"拖动透明度%f",self.alphValue);
        self.mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:self.alphValue];
    }else{
        self.effect = slider.value;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (self.type == 1) {
            if (self.cutsumeImg) {
                self.backImageView.image = [UIImage boxblurImage:self.cutsumeImg withBlurNumber:self.effect];
            }else if(appdel.backImg){
                self.backImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:self.effect];
            }
        }else if(self.type == 0){
            if (appdel.backDefaultImg) {
                self.backImageView.image = [UIImage boxblurImage:appdel.backDefaultImg withBlurNumber:self.effect];
            }
        }else if(self.type == 3){
            if (self.zsImage) {
                self.backImageView.image = [UIImage boxblurImage:self.zsImage withBlurNumber:self.effect];
            }
        }
    }
}

- (void)requestUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            [NoticeSaveModel saveUserInfo:userIn];
            
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
            [self showToastWithText:[NoticeTools getLocalStrWith:@"skin.setsuc"]];
            appdel.effect = self.effect;
            appdel.alphaValue = self.alphValue;
            [NoticeComTools saveAlphaValue:[NSString stringWithFormat:@"%f",appdel.alphaValue]];
            [NoticeComTools saveEffectValue:[NSString stringWithFormat:@"%f",appdel.effect]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
            __weak typeof(self) weakSelf = self;
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        
    } fail:^(NSError *error) {
    }];
}


//使用专属皮肤
- (void)useZjSkin{
    if (!self.choiceM) {
        return;
    }
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.choiceM.skinId forKey:@"skinId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/skin/set" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.backImg = self.zsImage;
            [self requestUserInfo];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)useClick{
    if (self.type == 3) {
        if (!self.choiceM) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"skin.choice"]];
            return;
        }
        __weak typeof(self) weakSelf = self;
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (userM.level.intValue < self.choiceM.level.intValue) {
            NSString *str = nil;
            if ([NoticeTools getLocalType] == 2) {
                str = [NSString stringWithFormat:@"Lv%@へのアップグレードを使用できる〜",self.choiceM.level];
            }else if ([NoticeTools getLocalType] == 1){
                str = [NSString stringWithFormat:@"Limited to Lv%@ or higher",self.choiceM.level];
            }else{
                str = [NSString stringWithFormat:@"升级至Lv%@可使用哦~",self.choiceM.level];
            }
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                    [weakSelf.navigationController pushViewController:ctl animated:YES];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        [self useZjSkin];
        return;
    }
   
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    userM.spec_bg_type = [NSString stringWithFormat:@"%ld",self.type];
    if (self.type == 1) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
     
        if(!self.cutsumeImg && !appdel.custumeImg && userM.spec_bg_type.intValue == 2){//自定义图片没选择图片，代表只更换模糊度和透明度
            appdel.effect = self.effect;
            appdel.alphaValue = self.alphValue;
            if (appdel.alphaValue >= 0.8) {
                appdel.alphaValue = 0.8;
            }
            [self requestUserInfo];
        }else if(self.cutsumeImg || appdel.custumeImg){//更换了图片
            [self upLoadHeader:self.cutsumeImg?self.cutsumeImg:appdel.custumeImg path:self.filepath withDate:nil];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"skin.choicecutume"]];
        }
        return;
    }
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.type==0?@"1":@"3" forKey:@"specBgType"];
        [parm setObject:@"" forKey:@"specBgPhotoUrl"];
        
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
            [self hideHUD];
            if (success1) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
             
                if(self.type == 2){
                    self.alphValue = 1;
                    appdel.backImg = nil;
                }
                
                if (self.type == 0) {
                    appdel.backImg = appdel.backDefaultImg;
                }
              
                if (appdel.backImg) {
                    self.backImageView.image = [UIImage boxblurImage:appdel.backImg withBlurNumber:self.effect];
                }
                
                appdel.effect = self.effect;
                appdel.alphaValue = self.alphValue;
                if (self.type == 0) {
                    if (appdel.alphaValue >= 0.8) {
                        appdel.alphaValue = 0.8;
                    }
                }
                [self requestUserInfo];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
}

@end
