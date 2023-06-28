//
//  NoticeAddSellMerchantController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddSellMerchantController.h"
#import "NoticeChatVoiceShopCell.h"
#import "NoticeChatTextCell.h"
#import "UIView+CLSetRect.h"
@interface NoticeAddSellMerchantController ()
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NoticeGoodsModel *oldGoodsModel;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation NoticeAddSellMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navBarView.titleL.text = @"商品";
    
    
    [self.tableView registerClass:[NoticeChatVoiceShopCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeChatTextCell class] forCellReuseIdentifier:@"cell2"];
    
    for (NoticeGoodsModel *goods in self.goodsModel.goods_listArr) {
        goods.choice = @"0";
        for (NoticeGoodsModel *choiceM in self.sellGoodsArr) {
            if([goods.goodId isEqualToString:choiceM.goodId]){
                goods.choice = @"1";
                [self.choiceArr addObject:goods];
            }
        }
        
        if(goods.type.intValue == 1){
            [self.textArr addObject:goods];
        }else{
            [self.voiceArr addObject:goods];
        }
    }
    
    [self.tableView reloadData];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, DR_SCREEN_WIDTH-40, 40)];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.layer.masksToBounds = YES;
    if(self.choiceArr.count){
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }

    [self.addButton setTitle:@"添加商品" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50);
}

- (NSMutableArray *)choiceArr{
    if(!_choiceArr){
        _choiceArr = [[NSMutableArray alloc] init];
    }
    return _choiceArr;
}

- (void)addClick{
    if(!self.choiceArr.count){
        return;
    }
   
    if(self.refreshGoodsBlock){
        self.refreshGoodsBlock(self.choiceArr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)sectionView{
    if(!_sectionView){
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        _sectionView.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 50)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        [backV setCornerOnTop:10];
        [_sectionView addSubview:backV];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, GET_STRWIDTH(@"文字聊天(单选)", 15, 20), 20)];
        titleL.font = XGFourthBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.text = @"文字聊天(单选)";
        [backV addSubview:titleL];
        
        UILabel *titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(backV.frame.size.width-GET_STRWIDTH(@"不支持连麦 | 聊天记录不保存", 12, 17)-15, 16, GET_STRWIDTH(@"不支持连麦 | 聊天记录不保存", 12, 17), 17)];
        titleL1.font = TWOTEXTFONTSIZE;
        titleL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        titleL1.text = @"不支持连麦 | 聊天记录不保存";
        [backV addSubview:titleL1];
    }
    return _sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        __weak typeof(self) weakSelf = self;
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) { // 有使用麦克风的权限
                    NoticeGoodsModel *voiceChatM = weakSelf.voiceArr[indexPath.row];
                    voiceChatM.choice = voiceChatM.choice.boolValue?@"0":@"1";
                    [weakSelf.tableView reloadData];
                    
                    [self.choiceArr removeAllObjects];
                    for (NoticeGoodsModel *voiceM in weakSelf.voiceArr) {
                        if(voiceM.choice.boolValue){
                            [weakSelf.choiceArr addObject:voiceM];
                        }
                    }
                    
                    for (NoticeGoodsModel *textM in weakSelf.textArr) {
                        if(textM.choice.boolValue){
                            [weakSelf.choiceArr addObject:textM];
                        }
                    }
                    
                    if(weakSelf.choiceArr.count){
                        weakSelf.addButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                        [weakSelf.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                    }else{
                        weakSelf.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
                        [weakSelf.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
                    }
                }else { // 没有麦克风权限
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以开通语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 1) {
                            UIApplication *application = [UIApplication sharedApplication];
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            if ([application canOpenURL:url]) {
                                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                    if (@available(iOS 10.0, *)) {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    }
                                } else {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            }
                        }
                    };
                    [alerView showXLAlertView];
                }
            });
        }];
    }else if(indexPath.section == 1){
        NoticeGoodsModel *choiceModel = self.textArr[indexPath.row];

        if(choiceModel.choice.boolValue){
            choiceModel.choice = @"0";
            for (NoticeGoodsModel *textM in self.textArr) {
                textM.choice = @"0";
            }
        }else{
            for (NoticeGoodsModel *textM in self.textArr) {
                textM.choice = @"0";
            }
            choiceModel.choice = @"1";
            
        }

        [self.tableView reloadData];
        
        [self.choiceArr removeAllObjects];
        for (NoticeGoodsModel *textM in self.textArr) {
            if(textM.choice.boolValue){
                [self.choiceArr addObject:textM];
            }
        }
        
        for (NoticeGoodsModel *voiceM in self.voiceArr) {
            if(voiceM.choice.boolValue){
                [self.choiceArr addObject:voiceM];
            }
        }
            
        if(self.choiceArr.count){
            self.addButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }else{
            self.addButton.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
            [self.addButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return self.sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 15;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        UIView *sectionFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 15)];
        sectionFoot.backgroundColor = [UIColor whiteColor];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 15)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        [backV setCornerOnBottom:10];
        [sectionFoot addSubview:backV];
        return sectionFoot;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NoticeChatVoiceShopCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell1.shopId = self.goodsModel.myShopM.shopId;
        cell1.goodModel = self.voiceArr[indexPath.row];
        __weak typeof(self) weakSelf = self;
        cell1.changePriceBlock = ^(NSString * _Nonnull price) {
            if(weakSelf.changePriceBlock){
                weakSelf.changePriceBlock(price);
            }
        };
        return cell1;
    }else{
        NoticeChatTextCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.goodModel = self.textArr[indexPath.row];
        return cell2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 173;
    }
    return 76;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.voiceArr.count;
    }
    return self.textArr.count;
}

- (NSMutableArray *)voiceArr{
    if(!_voiceArr){
        _voiceArr = [[NSMutableArray alloc] init];
    }
    return _voiceArr;
}

- (NSMutableArray *)textArr{
    if(!_textArr){
        _textArr = [[NSMutableArray alloc] init];
    }
    return _textArr;
}


@end
