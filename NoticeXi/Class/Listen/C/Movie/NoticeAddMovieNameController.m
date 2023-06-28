//
//  NoticeAddMovieNameController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddMovieNameController.h"
#import "DDHAttributedMode.h"
@interface NoticeAddMovieNameController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, assign) NSInteger strNum;
@end

@implementation NoticeAddMovieNameController
{
    UILabel *_plaL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  [NoticeTools getLocalStrWith:@"movie.addmoviename"];
    if (self.type == 1) {
        self.navigationItem.title =  [NoticeTools getLocalStrWith:@"movie.addbookname"];
    }else if (self.type == 2){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addsongname"];
    }else if (self.type == 3){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addgeshou"];
    }else if (self.type == 4){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addallzj"];
    }else if (self.type == 5){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addzjnmae"];
    }else if (self.type == 9){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addintro"];
    }else if (self.type == 6){
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addzuozhe"];
    }

    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 150)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, DR_SCREEN_WIDTH-40-20, 30)];
    
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.backgroundColor = backView.backgroundColor;
    if (self.movieName.length) {
        self.nameField.text = self.movieName;
        
        CGRect frame = self.nameField.frame;
        float height;
        height = [self heightForTextView:self.nameField WithText:self.nameField.text];
        if (height > 120) {
            height = 120;
        }
        frame.size.height = height;
        self.nameField.frame = frame;
    }
    
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.nameField becomeFirstResponder];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+15, 200, 15)];
    if (self.movieName.length && self.movieName) {
        _plaL.text = @"";
    }else{
        _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputdyname"];
        if (self.type == 1) {
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputbookname"];
        }else if (self.type == 2){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputsongname"];
        }else if (self.type == 3){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputgeshouname"];
        }else if (self.type == 4){
            _plaL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.inpusuozhuanji"]:@"输入所屬專輯";
        }else if (self.type == 5){
            _plaL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.inputzjming"]:@"输入專輯名";
        }else if (self.type == 9){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputjianjie"];
        }else if (self.type == 6){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputzuozhename"];
        }
    }
    
    self.strNum = (self.type == 9 ? 500 : (self.type == 5?20: 100));
    
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#737780"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(backView.frame)+10,70, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.numL.font = THRETEENTEXTFONTSIZE;
    self.numL.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.movieName.length,(long)self.strNum];
    [self.view addSubview:self.numL];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(backView.frame)+70, DR_SCREEN_WIDTH-140, 50)];
    btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    btn.layer.cornerRadius = 25;
    btn.layer.masksToBounds = YES;
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)fifinshClick{
    NSString *str = self.nameField.text.length > self.strNum ? [self.nameField.text substringToIndex:self.strNum] :self.nameField.text;
    if (self.movieNameBlock) {
        self.movieNameBlock(str);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    if (height > 120) {
        height = 120;
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
        _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputdyname"];
        if (self.type == 1) {
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputbookname"];
        }else if (self.type == 2){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputsongname"];
        }else if (self.type == 3){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputgeshouname"];
        }else if (self.type == 4){
            _plaL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.inpusuozhuanji"]:@"输入所屬專輯";
        }else if (self.type == 5){
            _plaL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.inputzjming"]:@"输入專輯名";
        }else if (self.type == 9){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputjianjie"];
        }else if (self.type == 6){
            _plaL.text = [NoticeTools getLocalStrWith:@"movie.inputzuozhename"];
        }
    }
    
    if (textView.text.length > self.strNum) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/%ld",textView.text.length,self.strNum] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
    }else{
        self.numL.text = [NSString stringWithFormat:@"%lu/%ld",textView.text.length,(long)self.strNum];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


@end
