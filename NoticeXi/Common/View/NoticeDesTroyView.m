//
//  NoticeDesTroyView.m
//  NoticeXi
//
//  Created by li lei on 2020/8/20.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeDesTroyView.h"
#import "JJCPayCodeTextField.h"
@implementation NoticeDesTroyView
{
    UILabel *_titleL;
}

- (instancetype)initWithShowRule{
    if(self = [super init]){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        [self addGestureRecognizer:closeTap];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-325)/2, (NAVIGATION_BAR_HEIGHT-400)/2,325,400)];
        [self addSubview:contentView];
        self.contentView = contentView;
        self.contentView.center = self.center;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,325,400)];
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        self.imageView.image = UIImageNamed(@"ruleshow_imgs");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTap)];
        [self.imageView addGestureRecognizer:tap];
        
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0,371, contentView.frame.size.width, 17)];
        markL.font = TWOTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#9EB38A"];
        markL.textAlignment = NSTextAlignmentCenter;
        markL.text = @"声昔不鼓励颜值社交，请不要发布个人自拍";
        [contentView addSubview:markL];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30,195, 275,165)];
        [self.imageView addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 275, 25)];
        titleL.font = FIFTHTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.numberOfLines = 0;
        _titleL = titleL;
        [self.scrollView addSubview:titleL];
        
        [self getrule];
    }
    return self;
}

- (void)getrule{
    NSString *url = @"getTextRule";
   
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            NSAttributedString *attStr = [NoticeTools getStringWithLineHight:4 string:aboutM.voiceText];
            CGFloat height = [NoticeTools getHeightWithLineHight:4 font:15 width:275 string:aboutM.voiceText];
            _titleL.frame = CGRectMake(0, 0, 275, height);
            _titleL.attributedText = attStr;
            self.scrollView.contentSize = CGSizeMake(275, height);
        }
    } fail:^(NSError *error) {

    }];
}


- (void)noTap{
    
}

- (instancetype)initWithShowSendSMS{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.userInteractionEnabled = YES;
        self.isSendSMS = YES;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-280)/2, NAVIGATION_BAR_HEIGHT+20,280,340)];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;

        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake(contentView.frame.size.width/2,contentView.frame.size.height-44,contentView.frame.size.width/2, 44);
        [self.sureBtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        self.sureBtn.tag = 2;
        self.sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.sureBtn];
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.frame = CGRectMake(0,contentView.frame.size.height-44,contentView.frame.size.width/2, 44);
        [self.cancleBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.rethink"] forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.cancleBtn.tag = 1;
        self.cancleBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.cancleBtn];
                
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent)];
        [contentView addGestureRecognizer:contentTap];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,24, contentView.frame.size.width, 25)];
        titleL.font = XGEightBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = [NoticeTools chinese:@"请输入图形验证码" english:@"Input verification code" japan:@"認証コードを入力してください"];
        _titleL = titleL;
        [contentView addSubview:titleL];
        
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(38,CGRectGetMaxY(titleL.frame)+20, 206, 72)];
        numView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        numView.layer.cornerRadius = 8;
        numView.layer.masksToBounds = YES;
        [contentView addSubview:numView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 206, 72)];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [numView addSubview:self.imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeImage)];
        [self.imageView addGestureRecognizer:tap];
        
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(numView.frame)+14, contentView.frame.size.width, 13)];
        markL.font = TWOTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        markL.textAlignment = NSTextAlignmentCenter;
        markL.text = [NoticeTools chinese:@"点击图片刷新·不区分大小写" english:@"Click image to refresh" japan:@"画像をクリックして更新"];
        [contentView addSubview:markL];
        
        JJCPayCodeTextField *codeField = [[JJCPayCodeTextField alloc] initWithFrame:CGRectMake(38,CGRectGetMaxY(numView.frame)+61,contentView.frame.size.width-38*2, 45) TextFieldType:JJCPayCodeTextFieldTypeSpaceBorder];
        codeField.finishedBlock = ^(NSString *payCodeString) {
            self.allStr = payCodeString;
        };
        codeField.textField.keyboardType = UIKeyboardTypeEmailAddress;
        codeField.isneedChangeColor = YES;
        codeField.borderSpace = 10;
        codeField.borderColor = [UIColor clearColor];
        codeField.textFieldNum = 4;
        codeField.isShowTrueCode = YES;
        [codeField.textField setupToolbarToDismissRightButton];
        [contentView addSubview:codeField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-44, contentView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [contentView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2-0.5, contentView.frame.size.height-44, 1, 44)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [contentView addSubview:line1];
        [self getCodeImage];
    }
    return self;
}

- (void)getCodeImage{
    NSString *url = @"users/captcha";
   
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.codeModel = aboutM;
            NSURL *baseImageUrl = [NSURL URLWithString:aboutM.img];
            NSData *imageData = [NSData dataWithContentsOfURL:baseImageUrl];
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
        }
    } fail:^(NSError *error) {

    }];
}

- (instancetype)initWithShowDestroy{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        self.userInteractionEnabled = YES;

        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-280)/2, NAVIGATION_BAR_HEIGHT+20,280,344)];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;

        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake(contentView.frame.size.width/2,contentView.frame.size.height-44,contentView.frame.size.width/2, 44);
        [self.sureBtn setTitle:[NoticeTools getLocalStrWith:@"accunt.surezx"] forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
        self.sureBtn.tag = 2;
        self.sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.sureBtn];
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.frame = CGRectMake(0,contentView.frame.size.height-44,contentView.frame.size.width/2, 44);
        [self.cancleBtn setTitle:[NoticeTools getLocalStrWith:@"groupManager.rethink"] forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.cancleBtn.tag = 1;
        self.cancleBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.cancleBtn];
                
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent)];
        [contentView addGestureRecognizer:contentTap];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,24, contentView.frame.size.width, 25)];
        titleL.font = XGEightBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = [NoticeTools getLocalStrWith:@"Login.inSmsCode"];
        _titleL = titleL;
        [contentView addSubview:titleL];
        
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(38,CGRectGetMaxY(titleL.frame)+20, 206, 116)];
        numView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        numView.layer.cornerRadius = 8;
        numView.layer.masksToBounds = YES;
        [contentView addSubview:numView];
        
        for (int i = 0; i < 4; i++) {
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(206/4*i, (arc4random()%80+10), 206/4, 26)];
            numL.font = [UIFont systemFontOfSize:20];
            numL.textAlignment = NSTextAlignmentCenter;
            numL.textColor = [UIColor colorWithHexString:@"#25262E"];
            numL.text = [NSString stringWithFormat:@"%u",arc4random()%10];
            if (i == 0) {
                self.num1 = numL.text;
            }else if (i == 1){
                self.num2 = numL.text;
            }else if (i == 2){
                self.num3 = numL.text;
            }else{
                self.num4 = numL.text;
            }
            [numView addSubview:numL];
        }
        
        JJCPayCodeTextField *codeField = [[JJCPayCodeTextField alloc] initWithFrame:CGRectMake(38,CGRectGetMaxY(numView.frame)+20,contentView.frame.size.width-38*2, 45) TextFieldType:JJCPayCodeTextFieldTypeSpaceBorder];
        codeField.finishedBlock = ^(NSString *payCodeString) {
            self.allStr = payCodeString;
        };
        codeField.isneedChangeColor = YES;
        codeField.borderSpace = 10;
        codeField.borderColor = [UIColor clearColor];
        codeField.textFieldNum = 4;
        codeField.isShowTrueCode = YES;
        codeField.textField.keyboardType = UIKeyboardTypePhonePad;
        [codeField.textField setupToolbarToDismissRightButton];
        [contentView addSubview:codeField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-44, contentView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [contentView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2-0.5, contentView.frame.size.height-44, 1, 44)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [contentView addSubview:line1];
    }
    return self;
}

#pragma mark - 弹出 -


- (void)buttonEvent:(UIButton *)button{
    if (button.tag == 2) {
        if(self.isSendSMS){
            if (self.allStr.length == 4) {
                [self dissMissView];
                if (self.sureCodeBlock) {
                    self.sureCodeBlock(self.allStr,self.codeModel.key);
                }
            }else{
                _titleL.text = @"请输入正确验证码";
                _titleL.textColor = [UIColor redColor];
            }
        }else{
            if (self.allStr.intValue && [self.allStr isEqualToString:[NSString stringWithFormat:@"%@%@%@%@",self.num1,self.num2,self.num3,self.num4]]) {
                [self dissMissView];
                if (self.sureDestroy) {
                    self.sureDestroy(YES);
                }
            }else{
                _titleL.text = @"请输入正确验证码";
                _titleL.textColor = [UIColor redColor];
            }
        }


    }else{
        [self dissMissView];
    }
    
}

- (void)showDestroyView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{

    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dissMissView{
    [self removeFromSuperview];
}

- (void)tapContent{
    
}
@end
