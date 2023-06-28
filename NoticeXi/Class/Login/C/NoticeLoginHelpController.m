//
//  NoticeLoginHelpController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeLoginHelpController.h"

@interface NoticeLoginHelpController ()

@end

@implementation NoticeLoginHelpController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"Login.help"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,20+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 22)];
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.font = SIXTEENTEXTFONTSIZE;
    label.text = [NoticeTools getLocalStrWith:@"dl.zenmb"];
    [self.view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(label.frame)+15, DR_SCREEN_WIDTH-40, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:line];
    
    NSString *str = [NoticeTools getLocalStrWith:@"dl.show"];
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame)+19, DR_SCREEN_WIDTH-40, [NoticeTools getHeightWithLineHight:10 font:14 width:DR_SCREEN_WIDTH-40 string:str])];
    markL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    markL.numberOfLines = 0;
    markL.font = FOURTHTEENTEXTFONTSIZE;
    markL.attributedText = [NoticeTools getStringWithLineHight:10 string:str];
    [self.view addSubview:markL];
    
    NSArray *imgNameArr = @[@"Image_wbhelp",@"Image_qqhelp"];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(markL.frame)+28+42*i, 20, 20)];
        imageV.image = UIImageNamed(imgNameArr[i]);
        [self.view addSubview:imageV];
        
        UILabel *tlabelL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+8, imageV.frame.origin.y, 200, 20)];
        tlabelL.font = FOURTHTEENTEXTFONTSIZE;
        tlabelL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        if (i==0) {
            tlabelL.text = [NoticeTools getLocalStrWith:@"dl.wb"];
        }else{
            tlabelL.text = [NoticeTools getLocalStrWith:@"dl.qq"];
        }
        [self.view addSubview:tlabelL];
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(markL.frame)+28+42+30, DR_SCREEN_WIDTH-40, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:line1];
    
    UILabel *markL1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame)+25, DR_SCREEN_WIDTH-40, 22)];
    markL1.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    markL1.font = SIXTEENTEXTFONTSIZE;
    markL1.text = @"被封号声昔钱包的余额怎么办？";
    [self.view addSubview:markL1];
    
    UILabel *markL2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(markL1.frame)+15, DR_SCREEN_WIDTH-40, 22)];
    markL2.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    markL2.font = FOURTHTEENTEXTFONTSIZE;
    markL2.text = @"1.添加下面的声昔官方微信账号，申请退款";
    [self.view addSubview:markL2];
    
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(markL2.frame)+10, 200, 200)];
    imageV1.image = UIImageNamed(@"kefweixin");
    [self.view addSubview:imageV1];

}



@end
