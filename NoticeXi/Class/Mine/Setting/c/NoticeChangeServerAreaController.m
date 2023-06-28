//
//  NoticeChangeServerAreaController.m
//  NoticeXi
//
//  Created by li lei on 2019/5/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeServerAreaController.h"
#import "NoticeNoticenterModel.h"
@interface NoticeChangeServerAreaController ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger oldIndex;
@end

@implementation NoticeChangeServerAreaController
{
    NSMutableArray *_buttonArr;
    UIButton *_oldBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"set.outsea"];
    
    
    NSString *str = [NoticeTools getLocalStrWith:@"set.seaoutmark"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,78+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-80,GET_STRHEIGHT(str, 14, DR_SCREEN_WIDTH-56)+20)];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    label.attributedText = attributedString;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    _buttonArr = [NSMutableArray new];
    NSArray *biaotarr = @[[NoticeTools getLocalStrWith:@"set.guonei"],@"Virginia (US)",@"Tokyo (JP)",[NoticeTools getLocalStrWith:@"set.usa"]];
    for (int i = 0; i < biaotarr.count; i++) {
        UIButton *Ebtn = [[UIButton alloc] initWithFrame:CGRectMake(40,CGRectGetMaxY(label.frame)+40+70*i,DR_SCREEN_WIDTH-80, 50)];
        Ebtn.titleLabel.font = XGTwentyBoldFontSize;
        [Ebtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [Ebtn setTitle:biaotarr[i] forState:UIControlStateNormal];
        Ebtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        Ebtn.layer.cornerRadius = 25;
        Ebtn.layer.masksToBounds = YES;
        Ebtn.tag = i;
        [_buttonArr addObject:Ebtn];
        [Ebtn addTarget:self action:@selector(waiClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:Ebtn];
    }

    [self requestServer];
}

- (void)waiClick:(UIButton *)button{

    [_oldBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    _oldBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _oldBtn = button;
    
    self.index = button.tag;
    
    [self waiClick1];

}

- (void)waiClick1{
    
    if (self.index != self.oldIndex) {
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:@"bucketId"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.oldIndex = self.index;
                [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.save"]];
            }else{
                [self showToastWithText:dict[@"msg"]];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
}

- (void)requestServer{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v2.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
     
            NoticeNoticenterModel *noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            if (!noticeM.bucket_id.integerValue) {
                UIButton *button = self->_buttonArr[0];
                button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                self->_oldBtn = button;
                self.oldIndex = 0;
            }else if (noticeM.bucket_id.integerValue == 1){
                UIButton *button = self->_buttonArr[1];
                button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                self->_oldBtn = button;
                self.oldIndex = 1;
            }else if (noticeM.bucket_id.integerValue == 2){
                UIButton *button = self->_buttonArr[2];
                button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                self->_oldBtn = button;
                self.oldIndex = 2;
            }else if (noticeM.bucket_id.integerValue == 3){
                UIButton *button = self->_buttonArr[3];
                button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
                [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
                self->_oldBtn = button;
                self.oldIndex = 3;
            }
             self.index = self.oldIndex;
        }
    } fail:^(NSError *error) {
    }];
}

@end
