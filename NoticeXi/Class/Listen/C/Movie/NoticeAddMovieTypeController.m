//
//  NoticeAddMovieTypeController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddMovieTypeController.h"
#import "DDHAttributedMode.h"
@interface NoticeAddMovieTypeController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeAddMovieTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.movieType isEqualToString:[NoticeTools getLocalStrWith:@"movie.noadd"]]) {
        self.movieType = @"";
    }
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addleibie"];
    if (self.type == 1) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"movie.addzuozhe"];
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 40)];
    self.nameField.text = self.movieType.length?self.movieType:@"";
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"movie.inputtype"]:@"输入類別" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#737780"]}];
    self.nameField.placeholder = [NoticeTools getLocalStrWith:@"movie.inputtype"];
    if (self.type == 1) {
        self.nameField.placeholder = [NoticeTools getLocalStrWith:@"movie.inputzuozhename"];
    }
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.delegate = self;
    self.nameField.font =THRETEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.nameField.layer.cornerRadius = 5;
    self.nameField.layer.masksToBounds = YES;
    [self.nameField becomeFirstResponder];
    self.nameField.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    [self.view addSubview:self.nameField];
    
    //光标右移
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(15,0,7,40)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nameField.leftView = leftView;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameField.frame)+10, 100, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#737780"];
    self.numL.font = THRETEENTEXTFONTSIZE;
    self.numL.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)self.movieType.length];
    [self.view addSubview:self.numL];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(self.numL.frame)+70, DR_SCREEN_WIDTH-140, 50)];
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
    if (self.movieTypeBlock) {
        self.movieTypeBlock(self.nameField.text.length > 10? [self.nameField.text substringToIndex:10] :self.nameField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length > 10) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
    }else{
        self.numL.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}


@end
