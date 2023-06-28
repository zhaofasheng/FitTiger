//
//  NoticeManagerTzCell.m
//  NoticeXi
//
//  Created by li lei on 2020/11/18.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerTzCell.h"
#import "UITextField+LXPToolbar.h"
@implementation NoticeManagerTzCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,DR_SCREEN_WIDTH-30,40)];
        self.titleL.font = THRETEENTEXTFONTSIZE;
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:self.titleL];
        
        self.numField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 45, 20)];
        self.numField.backgroundColor = GetColorWithName(VMainThumeColor);
        self.numField.layer.cornerRadius = 2;
        self.numField.layer.masksToBounds = YES;
        self.numField.font = [UIFont systemFontOfSize:9];
        self.numField.delegate = self;
        self.numField.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.numField.textAlignment = NSTextAlignmentCenter;
        self.numField.keyboardType = UIKeyboardTypeNumberPad;
        [self.numField setupToolbarToDismissRightButton];
        [self.contentView addSubview:self.numField];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
        name:@"UITextFieldTextDidChangeNotification" object:self.numField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;

    if (self.finishBlock) {
        self.finishBlock(toBeString, self.bbsM);
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

- (void)setBbsM:(NoticeBBSModel *)bbsM{
    _bbsM = bbsM;
    self.titleL.text = bbsM.title;
    self.numField.hidden = !self.isEdit;
    self.numField.text = bbsM.post_sort;
    if (self.isEdit) {
        self.titleL.frame = CGRectMake(CGRectGetMaxX(self.numField.frame)+5, 0, DR_SCREEN_WIDTH-30-45, 40);
    }else{
        self.titleL.frame = CGRectMake(15,0,DR_SCREEN_WIDTH-30,40);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
