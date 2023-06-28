//
//  NoticeEditFoot.m
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditFoot.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeEditFoot

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 8)];
        line.backgroundColor = GetColorWithName(VBigLineColor);
        [self addSubview:line];
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = GetColorWithName(VBackColor);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 100, 42)];
        label.text = [NoticeTools isSimpleLau]?@"身份设置":@"身份設置";
        label.font = TWOTEXTFONTSIZE;
        label.textColor = GetColorWithName(VMainTextColor);
        [self addSubview:label];
        
        NSArray *arr = @[@"identfiImg1",@"identfiImg2"];
        NSArray *titleArr = @[[NoticeTools isSimpleLau]?@"自我对话者":@"自我對話者",[NoticeTools isSimpleLau]?@"灵感收集者":@"靈感收集者",[NoticeTools isSimpleLau]?@"观望者":@"觀望者"];

        _Xarr = [NSMutableArray new];
        _Yarr = [NSMutableArray new];
        
        for (int i = 0; i < 3; i++) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+(73+15)*i, 73, 73)];
            imgView.layer.cornerRadius = 5;
            imgView.layer.masksToBounds = YES;
            imgView.backgroundColor = GetColorWithName(VBigLineColor);
            if (i < 2) {
                imgView.image = UIImageNamed(arr[i]);
            }
            
            UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+15, imgView.frame.origin.y+2+(73-14)/2,GET_STRWIDTH(titleArr[i], 14, 14), 14)];
            markL.textColor = GetColorWithName(VMainTextColor);
            markL.font = FOURTHTEENTEXTFONTSIZE;
            markL.text = titleArr[i];
            markL.userInteractionEnabled = YES;
            
            if (i == 2) {
                 UILabel *choiceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame)+15, markL.frame.origin.y-3, 66, 20)];
                choiceL.textColor = [UIColor whiteColor];
                choiceL.font = [UIFont systemFontOfSize:9];
                choiceL.textAlignment = NSTextAlignmentCenter;
                choiceL.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
                choiceL.text = @"当前选择";
                choiceL.layer.cornerRadius = 5;
                choiceL.layer.masksToBounds = YES;
                [self addSubview:choiceL];
                _choiceL = choiceL;
            }

            [self addSubview:markL];
            [self addSubview:imgView];
            
            UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+(73+15)*i, DR_SCREEN_WIDTH-30, 73)];
            tapV.userInteractionEnabled = YES;
            tapV.tag = i;
            [self addSubview:tapV];
            
             [_Xarr addObject:[NSString stringWithFormat:@"%f",CGRectGetMaxX(markL.frame)+15]];
             [_Yarr addObject:[NSString stringWithFormat:@"%f",markL.frame.origin.y-3]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceIdentfi:)];
            [tapV addGestureRecognizer:tap];
        }
        
        NSString *str = [NoticeTools isSimpleLau]?@"「记录者」和「交流者」头像右下角表示身份:":@"「記錄者」和「交流者」頭像右下角表示身份:";
        CGFloat width = GET_STRWIDTH(str, 11, 11);
        
        UILabel *footL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-width-40)/2, frame.size.height-24-11, width, 11)];
        footL.text = str;
        footL.textColor = GetColorWithName(VDarkTextColor);
        footL.font = ELEVENTEXTFONTSIZE;
        [self addSubview:footL];
        
        NSArray *imgArr1 = @[[NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img",[NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1"];
        for (int i = 0; i < 2; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(footL.frame)+5+20*i,footL.frame.origin.y-2, 15, 15)];
            imgView.image = UIImageNamed(imgArr1[i]);
            [self addSubview:imgView];
        }
        if ([[[NoticeSaveModel getUserInfo] identity_type] isEqualToString:@"0"]) {
            _choiceL.frame = CGRectMake([_Xarr[2] floatValue], [_Yarr[2] floatValue], 66, 20);
        }else if ([[[NoticeSaveModel getUserInfo] identity_type] isEqualToString:@"1"]){
            _choiceL.frame = CGRectMake([_Xarr[0] floatValue], [_Yarr[0] floatValue], 66, 20);
        }else{
            _choiceL.frame = CGRectMake([_Xarr[1] floatValue], [_Yarr[1] floatValue], 66, 20);
        }
       
    }
    return self;
}

- (void)choiceIdentfi:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:tapV.tag == 0?@"1":(tapV.tag == 1?@"2":@"0") forKey:@"identityType"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
            [UIView animateWithDuration:0.3 animations:^{
                self->_choiceL.frame = CGRectMake([self->_Xarr[tapV.tag] floatValue], [self->_Yarr[tapV.tag] floatValue], 66, 20);
            }];
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

@end
