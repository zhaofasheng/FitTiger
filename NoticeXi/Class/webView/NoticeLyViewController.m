//
//  NoticeLyViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLyViewController.h"

@interface NoticeLyViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation NoticeLyViewController
{
    UILabel *_plaL;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VlistColor);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 22, 44);
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    if ([NoticeTools isWhiteTheme]) {
        [backButton setImage:[UIImage imageNamed:@"liuyimage"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"liuyimageye"] forState:UIControlStateNormal];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 55)];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 55)];
    label.text = [NoticeTools getLocalStrWith:@"yl.saytozuozhe"];
    label.font = XGEightBoldFontSize;
    label.textColor = GetColorWithName(VMainTextColor);
    [view addSubview:label];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame), DR_SCREEN_WIDTH, 200)];
    _backView.backgroundColor = GetColorWithName(VBackColor);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomFirst)];
    _backView.userInteractionEnabled = YES;
    [_backView addGestureRecognizer:tap];
    [self.view addSubview:_backView];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(19, 13, 200, 14)];
    _plaL.text = @"留言只有作者和本人看得到";
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = GetColorWithName(VDarkTextColor);
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,5, DR_SCREEN_WIDTH-15,45)];
    _textView.font = FOURTHTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.backgroundColor = GetColorWithName(VBackColor);
    _textView.delegate = self;
    _textView.textColor = GetColorWithName(VMainTextColor);
    _textView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    _textView.returnKeyType = UIReturnKeyDone;
    [_backView addSubview:_textView];
    [_backView addSubview:_plaL];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_backView.frame)+20, DR_SCREEN_WIDTH-30, 44)];
    button.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [button setTitle:[NoticeTools getLocalStrWith:@"cao.liiuyan"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(liuyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)becomFirst{
    [_textView becomeFirstResponder];
}

- (void)liuyClick{
    if (!_textView.text.length) {
        return;
    }
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_textView.text forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"htmls/%@/dialog",self.htmlId] Accept:@"application/vnd.shengxi.v2.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self backToPageAction];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
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
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 200) {
        height = 200;
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
        _plaL.text = @"留言只有作者和本人看得到";
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

- (void)backToPageAction{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                    withSubType:kCATransitionFromBottom
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
