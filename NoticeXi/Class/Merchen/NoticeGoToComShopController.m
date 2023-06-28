//
//  NoticeGoToComShopController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGoToComShopController.h"
#import "NoticeComLabelModel.h"
#import "KMTagListView.h"
#import "NoticeOrderComDetailController.h"
@interface NoticeGoToComShopController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *markL;

@property (nonatomic, strong) UIView *goodView;
@property (nonatomic, strong) UILabel *goodL;

@property (nonatomic, strong) UIView *nomerView;
@property (nonatomic, strong) UILabel *nomerL;

@property (nonatomic, strong) UIView *badView;
@property (nonatomic, strong) UILabel *badL;

@property (nonatomic, strong) UIButton *comButton;

@property (nonatomic, strong) NSString *score;

@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeGoToComShopController
{
    UILabel *_plaL;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-55);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 68)];
    titleView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFC"];
    titleView.layer.cornerRadius = 10;
    titleView.layer.masksToBounds = YES;
    [self.headerView addSubview:titleView];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
    self.iconImageView.layer.cornerRadius = 2;
    self.iconImageView.layer.masksToBounds = YES;
    [titleView addSubview:self.iconImageView];
    
    self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(66, 14, DR_SCREEN_WIDTH-30-68, 21)];
    self.priceL.font = FIFTHTEENTEXTFONTSIZE;
    self.priceL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [titleView addSubview:self.priceL];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake(66, 39,DR_SCREEN_WIDTH-30-68, 16)];
    self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.markL.font = ELEVENTEXTFONTSIZE;
    self.markL.text = @"仅支持连麦 | 聊天记录不保存";
    [titleView addSubview:self.markL];
    
    if(self.resultModel){
        self.priceL.text = self.resultModel.room_id.intValue?[NSString stringWithFormat:@"%@*%@",self.resultModel.goods_name?self.resultModel.goods_name:@"语音通话",[self getMMSSFromSS:self.resultModel.second]]:[NSString stringWithFormat:@"文字聊天*%@",self.resultModel.goods_name];
        self.markL.text = self.resultModel.created_atTime;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.resultModel.goods_img_url]];
    }
    
    if (self.orderM) {
        self.priceL.text = self.orderM.room_id.intValue?[NSString stringWithFormat:@"%@*%@",self.orderM.goods_name,[self getMMSSFromSS:self.orderM.voice_duration]]:[NSString stringWithFormat:@"文字聊天*%@",self.orderM.goods_name];
        self.markL.text = self.orderM.created_at;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.orderM.goods_img_url]];
    }
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, DR_SCREEN_WIDTH, 28)];
    titleL.font = XGTwentyBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleL.text = @"感觉店主怎么样呢？";
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:titleL];
    
    NSArray *arr = @[@"太治愈了",@"还可以啦",@"不太行噢"];
    for (int i = 0; i < 3; i++) {
        UIView *comView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88*3-40)/2+108*i, CGRectGetMaxY(titleL.frame)+30, 88, 110)];
        comView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        comView.layer.cornerRadius = 10;
        comView.layer.masksToBounds = YES;
        comView.userInteractionEnabled = YES;
        [self.headerView addSubview:comView];
        comView.tag = i;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, 48, 48)];
        imageView.userInteractionEnabled = YES;
        [comView addSubview:imageView];
        NSString *imgName = [NSString stringWithFormat:@"goodcomimg_%d",i];
        imageView.image = UIImageNamed(imgName);
        
        UILabel *goodL = [[UILabel alloc] initWithFrame:CGRectMake(0, 72,88, 22)];
        goodL.font = FIFTHTEENTEXTFONTSIZE;
        goodL.textColor = [UIColor colorWithHexString:@"#25262E"];
        goodL.text = arr[i];
        goodL.textAlignment = NSTextAlignmentCenter;
        [comView addSubview:goodL];
        
        if(i == 0){
            self.goodView = comView;
            self.goodL = goodL;
        }else if (i==1){
            self.nomerView = comView;
            self.nomerL = goodL;
        }else{
            self.badView = comView;
            self.badL = goodL;
        }
        
        UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodLikeTap:)];
        [comView addGestureRecognizer:comTap];
    }
    
    self.comButton = [[UIButton alloc] initWithFrame:CGRectMake(68, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, DR_SCREEN_WIDTH-68*2, 40)];
    self.comButton.layer.cornerRadius = 20;
    self.comButton.layer.masksToBounds = YES;
    [self.comButton setTitle:@"匿名评价" forState:UIControlStateNormal];
    self.comButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [self.comButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    self.comButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.comButton];
    [self.comButton addTarget:self action:@selector(comClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self getComLabelRequest];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15,414, DR_SCREEN_WIDTH-30, 90)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.headerView addSubview:backView];
    self.inputBackView = backView;
    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, DR_SCREEN_WIDTH-40, 30)];
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    self.nameField.delegate = self;
    self.nameField.font = FOURTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 14)];
    _plaL.text = @"还有话想说...";
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(backView.frame)+10,50, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.numL.font = TWOTEXTFONTSIZE;
    NSString *allStr = @"0/50";
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"50" beginSize:allStr.length-2];
    [self.headerView addSubview:self.numL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    
    [self.navBarView.backButton removeFromSuperview];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView addSubview:backBtn];
    self.navBarView.backButton = backBtn;
    [self.navBarView.backButton addTarget:self action:@selector(sureBackClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureBackClick{
    if(self.score.intValue || self.nameField.text.length){
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定放弃评价吗？" message:nil sureBtn:@"再想想" cancleBtn:@"放弃" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    
    BOOL hasChocie = NO;
    for (NoticeComLabelModel *model in self.labelArr) {
        if(model.isChoice){
            hasChocie = YES;
            break;
        }
    }
    if(hasChocie){
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定放弃评价吗？" message:nil sureBtn:@"再想想" cancleBtn:@"放弃" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getComLabelRequest{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopCommentLabel" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeComLabelModel *lableM = [NoticeComLabelModel mj_objectWithKeyValues:dic];
                [self.labelArr addObject:lableM];
            }
            if(self.labelArr.count){
                KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(25,300, self.view.frame.size.width-50, 0)];
                [tagV setupCustomeImgSubViewsWithTitles:self.labelArr];
                
                CGRect rect = tagV.frame;
                rect.size.height = tagV.contentSize.height;
                tagV.frame = rect;
                
                self.inputBackView.frame = CGRectMake(15,CGRectGetMidY(tagV.frame)+45, DR_SCREEN_WIDTH-30, 90);
                self.numL.frame =  CGRectMake(15,CGRectGetMaxY(self.inputBackView.frame)+10,50, 13);
                
                [self.headerView addSubview:tagV];
                
                self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,CGRectGetMaxY(tagV.frame)+90+45);
            }
        
        }
 
    } fail:^(NSError * _Nullable error) {

        [self showToastWithText:error.debugDescription];
    }];
}

- (void)comClick{
    if(!self.score.intValue){
        [self showToastWithText:@"请选择满意度"];
        return;
    }
    if (self.nameField.text.length > 50) {
        [self showToastWithText:@"评价字数不能超过50个字哦~"];
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.resultModel) {
        [parm setObject:self.resultModel.orderId forKey:@"orderId"];
    }
    if(self.orderM){
        [parm setObject:self.orderM.orderId forKey:@"orderId"];
    }
    [parm setObject:self.score forKey:@"score"];
    if(self.nameField.text.length){
        [parm setObject:self.nameField.text forKey:@"marks"];
    }
    NSString *lableStr = @"";
    BOOL hasChoice = NO;
    for (NoticeComLabelModel *model in self.labelArr) {
        if(model.isChoice){
            hasChoice = YES;
            if(lableStr.length){
                lableStr = [NSString stringWithFormat:@"%@,%@",lableStr,model.labelId];
            }else{
                lableStr = model.labelId;
            }
            
        }
    }
    
    if(hasChoice){
        [parm setObject:lableStr forKey:@"label"];
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/buyComment" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
         
            NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
    
            if(self.resultModel){
                ctl.orderId = self.resultModel.orderId;
                ctl.isFromCom = YES;
                ctl.goodsUrl = self.resultModel.goods_img_url;
                ctl.isVoice = self.resultModel.room_id.intValue?YES:NO;
                ctl.orderName = self.resultModel.shop_name;
                ctl.time = self.resultModel.created_atTime;
                ctl.second =self.resultModel.second;
                ctl.needDelete = YES;
                if(self.hasComBlock){
                    self.hasComBlock(self.resultModel.orderId);
                }
            }
            
            if (self.orderM) {
                if(self.hasComBlock){
                    self.hasComBlock(self.orderM.orderId);
                }
                ctl.orderId = self.orderM.orderId;
                ctl.isFromCom = YES;
                ctl.goodsUrl = self.orderM.shop_avatar_url;
                ctl.isVoice = self.orderM.room_id.intValue?YES:NO;
                ctl.orderName = self.orderM.goods_name;
                ctl.time = self.orderM.created_at;
                ctl.second =self.orderM.voice_duration;
                ctl.needDelete = YES;
            }
            [self.navigationController popViewControllerAnimated:NO];
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)goodLikeTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    self.goodView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.nomerView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.badView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.goodL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.nomerL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.badL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    if(tapV.tag == 0){
        self.goodView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.goodL.textColor = [UIColor whiteColor];
        self.score = @"1";
    }else if (tapV.tag == 1){
        self.nomerView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.nomerL.textColor = [UIColor whiteColor];
        self.score = @"2";
    }else{
        self.badView.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.badL.textColor = [UIColor whiteColor];
        self.score = @"3";
    }
    self.comButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
 
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
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
    if (height > 90) {
        height = 90;
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
        _plaL.text = @"还有话想说...";
    }
    
    if (textView.text.length > 50) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/50",textView.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/50",textView.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"5" beginSize:allStr.length-2];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (NSMutableArray *)labelArr{
    if(!_labelArr){
        _labelArr = [[NSMutableArray alloc] init];
    }
    return _labelArr;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
 

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(CGRectGetMaxY(self.inputBackView.frame)+30+NAVIGATION_BAR_HEIGHT > DR_SCREEN_HEIGHT-keyboardF.size.height){
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT-(CGRectGetMaxY(self.inputBackView.frame)+30 + NAVIGATION_BAR_HEIGHT - (DR_SCREEN_HEIGHT-keyboardF.size.height)), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-55);
    }
}

- (void)keyboardDiddisss{
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-55);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if(scrollView == self.tableView){
        [self.nameField resignFirstResponder];
    }
}


@end
