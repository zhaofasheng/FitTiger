//
//  NoticeWhiteVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteVoiceController.h"
#import "NoticeSendWhiteListController.h"
#import "NoticeWhiteVoiceListCell.h"
#import "NoticeWhiteCardDetiailController.h"
#import "NoticeStaySys.h"
@interface NoticeWhiteVoiceController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *messL;
@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NoticeNoDataView *queshenView;
@end

@implementation NoticeWhiteVoiceController

- (NSMutableArray *)choiceArr{
    if (!_choiceArr) {
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+((self.isSendChat||self.isHsGet||self.isHasSend)?0: 55), DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-((self.isSendChat||self.isHsGet||self.isHasSend)?0: 55));
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;          // 隐藏垂直方向滚动条
        // 注册cell
        [_collectionView registerClass:[NoticeWhiteVoiceListCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.collectionView.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.titleL.font = [UIFont systemFontOfSize:20];
    self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.view addSubview:self.titleL];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    if (self.userId) {
        self.titleL.text = [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"bz.his"] fantText:@"Ta的白噪聲"];
    }else{
        self.titleL.text = [NoticeTools getLocalStrWith:@"main.whiteVoice"];
    }

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, STATUS_BAR_HEIGHT, 42, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Image_blackBack"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    
    if (!self.userId && !self.isSendChat && !self.isHsGet && !self.isHasSend) {
        UIImageView *messImgV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        messImgV.image = UIImageNamed(@"Image_whitevoice_b");
        [self.view addSubview:messImgV];
        messImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messTap)];
        [messImgV addGestureRecognizer:tap];
        
        self.messL = [[UILabel alloc] initWithFrame:CGRectMake(8, -8, 20, 15)];
        self.messL.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.messL.font = [UIFont systemFontOfSize:10];
        self.messL.textAlignment = NSTextAlignmentCenter;
        self.messL.backgroundColor = [NoticeTools getWhiteColor:@"#FB5C57" NightColor:@"#AD403D"];
        self.messL.layer.cornerRadius = 15/2;
        self.messL.layer.masksToBounds = YES;
        self.messL.hidden = YES;
        [messImgV addSubview:self.messL];
    }

    [self.view addSubview:self.collectionView];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    self.isDown = YES;
    

    if (!self.isSendChat && !self.isHsGet && !self.isHasSend) {
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20, 55)];
        self.markL.numberOfLines = 0;
        self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.markL.font = TWOTEXTFONTSIZE;
        [self.view addSubview:self.markL];
        [self requestAll];
        
    }
    
    if (self.isSendChat) {
        self.sendButton = [[UIButton alloc] init];
        self.sendButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.sendButton.layer.cornerRadius = 4;
        self.sendButton.layer.masksToBounds = YES;
        [self.sendButton setTitle:[NoticeTools getLocalStrWith:@"read.send"] forState:UIControlStateNormal];
        [self.view addSubview:self.sendButton];
        self.sendButton.frame = CGRectMake(DR_SCREEN_WIDTH-20-66, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 66, 28);
        [self.sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.isHsGet && !self.isHasSend) {
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.isDown = YES;
            weakSelf.pageNo = 1;
            [weakSelf request];
        }];
        self.collectionView.mj_header = header;
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.isDown = NO;
            weakSelf.pageNo++;
            [weakSelf request];
            
        }];
        [self.collectionView.mj_header beginRefreshing];
    }else{
        self.titleL.text = self.isHsGet?[NoticeTools getLocalStrWith:@"chat.hasgetcard"]:[NoticeTools getLocalStrWith:@"chat.hassended"];
        [self request];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refreshlistNotice" object:nil];
    
}

- (void)sendClick{
    if (self.choiceArr.count) {
        if (self.choiceArrBlock) {
            self.choiceArrBlock(self.choiceArr);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (NoticeNoDataView *)queshenView{
    if (!_queshenView) {
        _queshenView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, self.collectionView.frame.size.height-40)];
        _queshenView.titleImageV.image = UIImageNamed(@"Image_quesy21");
        _queshenView.titleStr = [NoticeTools getLocalStrWith:@"bz.howget"];
        [self.view addSubview:_queshenView];
        _queshenView.hidden = YES;
    }
    return _queshenView;
}


- (void)refresh{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestAll{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/famousQuotesCards/statistics",self.userId?self.userId: [NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeWhiteVoiceListModel *model = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (!self.userId) {
                NSString *str1 = [NSString stringWithFormat:@"%@%@%@",[NoticeTools getLocalStrWith:@"bz.haget"],model.total_type,[NoticeTools getLocalStrWith:@"bz.z"]];
                NSString *allStr = [NSString stringWithFormat:@"%@%@",str1,[NoticeTools getLocalStrWith:@"bz.mark"]];
                self.markL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setSize:16 setLengthString:str1 beginSize:0];
            }

            if (self.userId) {
                self.markL.text = [NSString stringWithFormat:@"%@%@，%@%@",model.total_num,[NoticeTools getLocalStrWith:@"bz.num"],model.total_type,[NoticeTools getLocalStrWith:@"bz.type"]];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    if (self.userId) {
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeStaySys *message = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            CGFloat width = GET_STRWIDTH(message.cardM.num, 10, 15)+6;
            if (width < 18) {
                width = 18;
            }
            self.messL.text = message.cardM.num;
            self.messL.frame = CGRectMake(8, -8, width, 15);
            self.messL.hidden = message.cardM.num.intValue?NO:YES;
            
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/%@/famousQuotesCards",self.userId?self.userId: [NoticeTools getuserId]];
    }else{
        url = [NSString stringWithFormat:@"users/%@/famousQuotesCards?lastId=%@&pageNo=%ld&lastCardNo=%@",self.userId?self.userId: [NoticeTools getuserId],self.cardId,self.pageNo,self.cardNo];
    }
    if (self.isHsGet || self.isHasSend) {
        url = [NSString stringWithFormat:@"chatGiveCardList/%@",self.dialogId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:(self.isHsGet || self.isHasSend)?@"application/vnd.shengxi.v5.3.7+json": @"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWhiteVoiceListModel *model = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dic];
                if (!model.titleImage) {
                    [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:model.banner_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        model.titleImage = image;
                    }];
                }
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.cardId = [self.dataArr[self.dataArr.count-1] cardId];
                self.cardNo = [self.dataArr[self.dataArr.count-1] card_no];
                self.queshenView.hidden = YES;
            }else{
                self.queshenView.hidden = NO;
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}



- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHasSend) {
        return;
    }
    NoticeWhiteCardDetiailController *ctl = [[NoticeWhiteCardDetiailController alloc] init];
    ctl.whiteModel = self.dataArr[indexPath.row];
    ctl.currentItem = indexPath.row;
    ctl.dataArr = self.dataArr;
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeWhiteVoiceListCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.userId) {
        merchentCell.noLongTap = YES;
    }
    if (self.isHasSend || self.isHsGet) {
        merchentCell.noLongTap = YES;
    }
    merchentCell.isSendChat = self.isSendChat;
    merchentCell.isFullMax = self.choiceArr.count>=3?YES:NO;
    __weak typeof(self) weakSelf = self;
    merchentCell.whiteVoiceM = self.dataArr[indexPath.row];
    
    merchentCell.choiceModelBlock = ^(NoticeWhiteVoiceListModel * _Nonnull whiteModel) {
        if (!whiteModel.isChoiceed) {
            if (weakSelf.choiceArr.count >= 3) {
                [weakSelf showToastWithText:@"一次最多只能送三张哦~"];
                return;
            }
        }
        whiteModel.isChoiceed = !whiteModel.isChoiceed;
        if (whiteModel.isChoiceed) {
            [weakSelf.choiceArr addObject:whiteModel];
        }else{
            for (NoticeWhiteVoiceListModel *addM in weakSelf.choiceArr) {
                if ([addM.cardId isEqualToString:whiteModel.cardId]) {
                    [weakSelf.choiceArr removeObject:addM];
                    break;
                }
            }
        }
        if (weakSelf.choiceArr.count) {
            [weakSelf.sendButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            weakSelf.sendButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        }else{
            [weakSelf.sendButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
            weakSelf.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        }
        [weakSelf.collectionView reloadData];
    };
    
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-40)/2,(DR_SCREEN_WIDTH-40)/2/162*212);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)messTap{
    self.messL.hidden = YES;
    NoticeSendWhiteListController *ctl = [[NoticeSendWhiteListController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (!self.dataArr.count) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 5;
    
    if(y > h + reload_distance) {
        if (self.canLoad) {
            self.canLoad = NO;
            [self.collectionView.mj_footer beginRefreshing];
        }
    }
}
@end
