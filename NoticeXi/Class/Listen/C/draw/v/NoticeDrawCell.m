//
//  NoticeDrawCell.m
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeDrawTopicListController.h"
#import "NoticeDrawLikeListController.h"
#import "DDHAttributedMode.h"
#import "NoticeXi-Swift.h"
#import "NoticePeolpleDrawController.h"
#import "NoticeDrawViewController.h"
@implementation NoticeDrawCell
{
    UIView *_tapView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = GetColorWithName(VBackColor);
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,15, 40, 40)];
        self.iconImageView.layer.cornerRadius = 20;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(26+_iconImageView.frame.origin.x, 26+_iconImageView.frame.origin.y, 15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,16, DR_SCREEN_WIDTH-15-66-10-CGRectGetMaxX(self.iconImageView.frame), 15)];
        self.nickNameL.textColor = GetColorWithName(VMainTextColor);
        self.nickNameL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.nickNameL];
        
        self.tyBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-66, 13, 66, 20)];
        [self.tyBtn setTitle:[NoticeTools getLocalStrWith:@"em.tuya"] forState:UIControlStateNormal];
        [self.tyBtn setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
        self.tyBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.tyBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"tuya_Image":@"tuya_Imagey") forState:UIControlStateNormal];
        [self.contentView addSubview:self.tyBtn];
        [self.tyBtn addTarget:self action:@selector(tyClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+6,GET_STRWIDTH(@"昨天14点11分", 11, 11), 11)];
        self.timeL.textColor = GetColorWithName(VDarkTextColor);
        self.timeL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.timeL];
        
        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeL.frame)+10, CGRectGetMaxY(self.nickNameL.frame)+6,GET_STRWIDTH(@"测试测试", 11, 11), 13)];
        self.topicL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F90"];
        self.topicL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.topicL];
        self.topicL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTap)];
        [self.topicL addGestureRecognizer:tTap];
        
        self.drawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,65, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
        self.drawImageView.image = UIImageNamed(@"img_empty_img");
        [self.contentView addSubview:self.drawImageView];
        self.drawImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biglook)];
        [self.drawImageView addGestureRecognizer:tapb];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawImageView.frame), DR_SCREEN_WIDTH, 50)];
        self.buttonView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.buttonView];
        
        MCFireworksButton *imageView1 = [[MCFireworksButton alloc] initWithFrame:CGRectMake(15,11,28, 28)];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        imageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey");
        imageView1.particleImage = [UIImage imageNamed:[NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy"];
        imageView1.particleScale = 0.05;
        imageView1.particleScaleRange = 0.02;
        _firstImageView = imageView1;
        [self.buttonView addSubview:imageView1];
        
        _firstL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+7,0,50+30, 50)];
        _firstL.font = TWOTEXTFONTSIZE;
        _firstL.textColor = GetColorWithName(VDarkTextColor);
        _firstL.text = [NoticeTools isSimpleLau] ?@"喜欢":@"喜歡";
        [self.buttonView addSubview:_firstL];
        
        MCFireworksButton *imageView2 = [[MCFireworksButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-67-28)/2,11,28, 28)];
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        imageView2.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawnixh":@"Imagedrawnixhy");
        imageView2.particleImage = [UIImage imageNamed:[NoticeTools isWhiteTheme]?@"Imagedrawnixhs":@"Imagedrawnixhsy"];
        imageView2.particleScale = 0.05;
        imageView2.particleScaleRange = 0.02;
        _firstImageView1 = imageView2;
        [self.buttonView addSubview:imageView2];
        
        _firstL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame)+7,0,60+20, 50)];
        _firstL1.font = TWOTEXTFONTSIZE;
        _firstL1.textColor = GetColorWithName(VDarkTextColor);
        _firstL1.text = [NoticeTools isSimpleLau] ?@"匿名喜欢":@"匿名喜歡";
        [self.buttonView addSubview:_firstL1];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.buttonView.frame), DR_SCREEN_WIDTH, 8)];
        self.line.backgroundColor = GetColorWithName(VlineColor);
        [self.contentView addSubview:self.line];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50)-20-7,30/2,20, 20)];
        imageView3.contentMode = UIViewContentModeScaleAspectFit;
        imageView3.image = GETUIImageNamed(@"moreButtonName");
        _thirdImageView = imageView3;
        [self.buttonView addSubview:imageView3];
        
        _thirdL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50),0,GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50), 50)];
        _thirdL.font = TWOTEXTFONTSIZE;
        _thirdL.textColor = GetColorWithName(VDarkTextColor);
        _thirdL.text = GETTEXTWITE(@"voicelist.more");
        [self.buttonView addSubview:_thirdL];
        
        for (int i = 0; i < 3; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(147*i,0,28+15+50+7+i*10, 50)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapV:)];
            [tapView addGestureRecognizer:tap];
            [self.buttonView addSubview:tapView];
            if (i == 2) {
                tapView.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50)-20-7,0, 20+GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.more"], 12, 50)+27, 50);
            }
        }

        _viewL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-70, self.nickNameL.frame.origin.y-4, 70, 22)];
        _viewL.layer.cornerRadius = 5;
        _viewL.layer.masksToBounds = YES;
        _viewL.layer.borderColor = GetColorWithName(VDarkTextColor).CGColor;
        _viewL.layer.borderWidth = 1;
        _viewL.textColor = GetColorWithName(VDarkTextColor);
        _viewL.font = [UIFont systemFontOfSize:9];
        _viewL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_viewL];
        
        self.buttonEditView = [[UIView alloc] initWithFrame:self.buttonView.frame];
        self.buttonEditView.hidden = YES;
        [self.contentView addSubview:self.buttonEditView];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/2*i, 0, DR_SCREEN_WIDTH/2, 50)];
            [button setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            button.tag = i;
            [button addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                self.priBtn = button;
            }else{
                self.deleteBtn = button;
            }
            [self.buttonEditView addSubview:button];
        }
    }

    return self;
}

- (void)tyClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (!_drawModel.graffiti_num.integerValue) {
        if ([NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]) {
            NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:[NSString stringWithFormat:@"涂鸦功能仅对来到声昔超过24小时的用户开放，当前帐号再过%@就可以使用了",[NoticeComTools canDraw:[[NoticeSaveModel getUserInfo] created_at]]]];
            [pinV showTostView];
            return;
        }
        NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
        ctl.tuyeImage = self.drawImageView.image;
        ctl.drawId = _drawModel.drawId;
        ctl.isTuYa = YES;
        ctl.isFromDrawList = YES;
        if (_drawModel.topic_name) {
            NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
            topM.topic_id = _drawModel.topic_id;
            topM.topic_name = _drawModel.topic_name;
            ctl.topicM = topM;
        }
        
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }

    if (_drawModel.graffiti_num.integerValue) {
        NoticePeolpleDrawController *ctl = [[NoticePeolpleDrawController alloc] init];
        ctl.drawM = _drawModel;
        ctl.tuYaImage = self.drawImageView.image;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)editClick:(UIButton *)button{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.passCode forKey:@"confirmPasswd"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (button.tag == 0) {
        [parm setObject:_drawModel.hide_at.integerValue?@"0":@"1" forKey:@"isHidden"];
        [nav.topViewController showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawModel.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            if (success) {
                [nav showToastWithText:self->_drawModel.hide_at.integerValue? @"已取消仅作者可见":@"已设为仅作者可见"];
                [button setTitle:self->_drawModel.hide_at.integerValue? @"设为仅作者可见":@"已设为仅作者可见" forState:UIControlStateNormal];
                self->_drawModel.hide_at = self->_drawModel.hide_at.integerValue?@"0":@"6879";
                
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }else{
        if (self.isTuYaManager) {
            if ([_tuModel.graffiti_status isEqualToString:@"1"]) {
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/graffitis/%@",_tuModel.graffitiId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [nav showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                        [button setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
                        self->_tuModel.graffiti_status= @"0";
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                [parm setObject:@"1" forKey:@"graffitiStatus"];
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/graffitis/%@",_tuModel.graffitiId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [nav showToastWithText:@"已取消删除"];
                        [button setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
                        self->_tuModel.graffiti_status= @"1";
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
        }else{
            if ([_drawModel.artwork_status isEqualToString:@"1"]) {
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/artwork/%@",_drawModel.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [nav showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                        [button setTitle:[NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
                        self->_drawModel.artwork_status= @"0";
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                [parm setObject:@"1" forKey:@"artworkStatus"];
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawModel.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [nav showToastWithText:@"已取消删除"];
                        [button setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
                        self->_drawModel.artwork_status= @"1";
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }
        }
    }
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.buttonView.hidden = YES;
        self.buttonEditView.hidden = NO;
        self.tyBtn.hidden = YES;
    
    }
}

- (void)setDrawModel:(NoticeDrawList *)drawModel{
    _drawModel = drawModel;
    if ([drawModel.is_private isEqualToString:@"1"]) {
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:drawModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    }
    
    if ([drawModel.identity_type isEqualToString:@"0"] || [drawModel.is_private isEqualToString:@"1"]) {
        self.markImage.hidden = YES;
    }else if ([drawModel.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzb_img");
    }else if ([drawModel.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzb_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    
    if ([drawModel.user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    _nickNameL.text = drawModel.is_private.intValue?[NoticeTools getLocalStrWith:@"hh.nmhuajia"]: drawModel.nick_name;
    _timeL.text = drawModel.created_at;
    self.topicL.text = drawModel.topName;
    self.timeL.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+6,GET_STRWIDTH(drawModel.created_at, 11, 11), 11);
    self.topicL.frame = CGRectMake(CGRectGetMaxX(self.timeL.frame)+10, CGRectGetMaxY(self.nickNameL.frame)+6,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 11);
 
    [self.drawImageView sd_setImageWithURL:[NSURL URLWithString:drawModel.artwork_url] placeholderImage:GETUIImageNamed(@"img_empty") options:SDWebImageRefreshCached];
    
    if (drawModel.isSelf) {
        self.isMyDraw = YES;
        self.tyBtn.hidden = YES;
        if ((drawModel.publicly_like_num.integerValue + drawModel.anonymous_like_num.integerValue) > 0) {
            _jsL.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"有%ld%@",(long)(drawModel.publicly_like_num.integerValue + drawModel.anonymous_like_num.integerValue),[NoticeTools isSimpleLau]?@"位鉴赏家喜欢这幅作品":@"位鑒賞家喜歡這幅作品"];
            _jsL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:WHITEMAINCOLOR] setLengthString:[NSString stringWithFormat:@"%ld",(long)(drawModel.publicly_like_num.integerValue + drawModel.anonymous_like_num.integerValue)] beginSize:1];
        }else{
            _jsL.hidden = YES;
        }
        _firstL.hidden = YES;
        _firstL1.hidden = _firstL.hidden;
        _firstImageView.hidden = _firstL.hidden;
        _firstImageView1.hidden = _firstL.hidden;
        
        if (drawModel.viewed_num.integerValue) {
            _viewL.hidden = NO;
            _viewL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools isSimpleLau]?@"鉴赏":@"鑒賞",_drawModel.viewed_num];
            _viewL.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(_viewL.text, 11, 22)-16, self.nickNameL.frame.origin.y-4, GET_STRWIDTH(_viewL.text, 11, 22)+16, 22);
        }else{
            _viewL.hidden = YES;
        }
        
        
    }else{
        self.isMyDraw = NO;
        self.tyBtn.hidden = NO;
        _viewL.hidden = YES;
        _jsL.hidden = YES;
        _firstL.hidden = NO;
        _firstL1.hidden = _firstL.hidden;
        _firstImageView.hidden = _firstL.hidden;
        _firstImageView1.hidden = _firstL.hidden;
        _firstImageView1.image = UIImageNamed([drawModel.like_type isEqualToString:@"1"]?([NoticeTools isWhiteTheme]?@"Imagedrawnixhs":@"Imagedrawnixhsy"):([NoticeTools isWhiteTheme]?@"Imagedrawnixh":@"Imagedrawnixhy"));
        _firstImageView.image = UIImageNamed([drawModel.like_type isEqualToString:@"2"]?([NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy"):([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
    }
    
    [self.priBtn setTitle:drawModel.hide_at.integerValue? @"已设为仅作者可见" : @"设为仅作者可见" forState:UIControlStateNormal];
    [self.deleteBtn setTitle:[drawModel.artwork_status isEqualToString:@"1"]? [NoticeTools getLocalStrWith:@"groupManager.del"] : [NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
    
    if (self.noNeedTuYa) {
        self.tyBtn.hidden = YES;
    }else{
        if (!drawModel.isSelf) {
            self.tyBtn.hidden = drawModel.graffiti_switch.integerValue? NO : YES;//如果禁止涂鸦，则不显示按钮
              if (drawModel.graffiti_num.integerValue) {
                  [self.tyBtn setTitle:[NSString stringWithFormat:@"涂鸦 x %@",drawModel.graffiti_num] forState:UIControlStateNormal];
              }else{
                  [self.tyBtn setTitle:[NoticeTools getLocalStrWith:@"em.tuya"] forState:UIControlStateNormal];
              }
        }
    }
    
    [self refreshBtn];
}

- (void)setTuModel:(NoticeDrawTuM *)tuModel{
    self.tyBtn.hidden = YES;
    _tuModel = tuModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:tuModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    _nickNameL.text = tuModel.nick_name;
    _timeL.text = tuModel.created_at;
    self.topicL.text = tuModel.topName;
    self.timeL.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+6,GET_STRWIDTH(tuModel.created_at, 11, 11), 11);
    self.topicL.frame = CGRectMake(CGRectGetMaxX(self.timeL.frame)+10, CGRectGetMaxY(self.nickNameL.frame)+6,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 11);
    
    //UIImageNamed(@"img_empty_img")
    [self.drawImageView sd_setImageWithURL:[NSURL URLWithString:tuModel.graffiti_url] placeholderImage:GETUIImageNamed(@"img_empty") options:SDWebImageRefreshCached];
    
    if (tuModel.viewed_num.integerValue && [tuModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//如果是自己的涂鸦，展示鉴赏数量
        _viewL.hidden = NO;
        _viewL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools isSimpleLau]?@"鉴赏":@"鑒賞",tuModel.viewed_num];
        _viewL.frame = CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(_viewL.text, 11, 22)-16, self.nickNameL.frame.origin.y-4, GET_STRWIDTH(_viewL.text, 11, 22)+16, 22);
    }else{
        _viewL.hidden = YES;
    }
    
    if ([tuModel.vote_option isEqualToString:@"1"]) {//你是天使
        _firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
        _firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshic":@"tianshicy");
    }else if ([tuModel.vote_option isEqualToString:@"2"]){//你是恶魔
        _firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"moguic":@"moguicy");
        _firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
    }else{
        _firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
        _firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
    }
    
    if (self.isTuYaManager) {
         self.priBtn.hidden = YES;
        self.deleteBtn.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 50);
         [self.deleteBtn setTitle:[tuModel.graffiti_status isEqualToString:@"1"]? [NoticeTools getLocalStrWith:@"groupManager.del"] : [NoticeTools getLocalStrWith:@"emtion.deleSuc"] forState:UIControlStateNormal];
    }
    _firstL.text = tuModel.vote_option_one.integerValue? [NSString stringWithFormat:@"您是天使 %@",tuModel.vote_option_one] : @"您是天使";
    _firstL1.text = tuModel.vote_option_two.integerValue? [NSString stringWithFormat:@"您是恶魔 %@",tuModel.vote_option_two] : @"您是恶魔";
}

- (void)biglook{
    NSArray *array = [_drawModel.artwork_url componentsSeparatedByString:@"?"];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.drawImageView;
    item.largeImageURL     = [NSURL URLWithString:array[0]];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.drawImageView
                   toContainer:toView
                      animated:YES completion:nil];
}

//鉴赏点击
- (void)jsTap{
    NoticeDrawLikeListController *ctl = [[NoticeDrawLikeListController alloc] init];
    ctl.artId = _drawModel.drawId;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)topicTap{
    if (self.isTopice) {
        return;
    }
    if (!_drawModel.topName) {
        return;
    }
    NoticeDrawTopicListController *ctl = [[NoticeDrawTopicListController alloc] init];
    ctl.topicName = _drawModel.topic_name;
    ctl.topicId = _drawModel.topic_id;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

//点击头像
- (void)userInfoTap{
   
    if (_drawModel.is_private.integerValue) {
        return;
    }
    if (_drawModel.isSelf) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _tuModel ? _tuModel.user_id : _drawModel.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)tapV:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag == 0) {//喜欢
        if (self.isPeopleTuYa) {//您是天使
            if ([_tuModel.vote_option isEqualToString:@"1"]) {
                [self deleLikeWith:@"1"];
                return;
            }
            [self setLikeWith:@"1"];
        }else{
            if ([_drawModel.like_type isEqualToString:@"2"]) {
                [self deleLikeWith:@"2"];
                return;
            }
            _tapView = tap.view;
            [self setLikeWith:@"2"];
        }

    }else if (tap.view.tag == 1){//匿名喜欢
        if (self.isPeopleTuYa) {//您是恶魔
            if ([_tuModel.vote_option isEqualToString:@"2"]) {
                [self deleLikeWith:@"2"];
                return;
            }
            [self setLikeWith:@"2"];
        }else{
            if ([_drawModel.like_type isEqualToString:@"1"]) {
                [self deleLikeWith:@"1"];
                return;
            }
            _tapView = tap.view;
            [self setLikeWith:@"1"];
        }

    }else{
        if (self.isPeopleTuYa) {
            if ([_tuModel.parent_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//作品是自己的
                if ([_tuModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//自己的作品自己的涂鸦
                    [self deleteSelfTuya];
                }else{//自己的作品别人的涂鸦
                    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                        if (buttonIndex == 2){
                            LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"hh.deltuya"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                                if (buttonIndex1 == 1) {
                                    [self deleteDraw];
                                }
                            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                            [sheet1 show];
                        }
                    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                    sheet.delegate = self;
                    self.tuyaSheet = sheet;
                    [sheet show];
                }
            }else{
                if ([_tuModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//别人的作品自己的涂鸦
                    [self deleteSelfTuya];
                }else{//别人的作品别人的涂鸦
                    
                    if ([NoticeTools isManager]) {//如果是管理员
                        LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"],@"删除用户涂鸦"]];
                        sheet1.delegate = self;
                        [sheet1 show];
                        self.tuyaSheet = sheet1;
                    }else{
                        LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                      
                        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
                        sheet1.delegate = self;
                        self.tuyaSheet = sheet1;
                        [sheet1 show];
                    }
                }
            }
            return;
        }
        if (!_drawModel.isSelf) {
            if ([NoticeTools isManager]) {
                [self managerTap];
                return;
            }
            [self jubao];
        }else{
            NSString *str = _drawModel.graffiti_switch.integerValue?([NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.cannottuy"]:@"禁止塗鴉"):([NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.cantuya"]:@"允許塗鴉");
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self setis_privateWith:self->_drawModel.is_private.integerValue?@"0":@"1"];
                }else if (buttonIndex == 3){
                    
                    LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:@"确定删除作品?" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                        if (buttonIndex1 == 1) {
                            [self deleteDraw];
                        }
                    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
                    [sheet1 show];
                }
            } otherButtonTitleArray:@[_drawModel.is_private.integerValue?[NoticeTools getLocalStrWith:@"hh.canniming"]:[NoticeTools getLocalStrWith:@"hh.setnim"],str,[NoticeTools getLocalStrWith:@"groupManager.del"]]];
            self.tuyaSwitchSheet = sheet;
            sheet.delegate = self;
            [sheet show];
        }
    }
}

//自己的作品自己的涂鸦和别人的作品自己的涂鸦
- (void)deleteSelfTuya{
    
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
         if (buttonIndex == 1){
            
            LCActionSheet *sheet1 = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"hh.deltuya"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex1) {
                if (buttonIndex1 == 1) {
                    [self deleteDraw];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
            [sheet1 show];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"]]];
    [sheet show];
}

//管理员操作
- (void)managerTap{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"删除作品",@"设为仅作者可见",@"查看作者封面",[NoticeTools getLocalStrWith:@"chat.jubao"]]];
    sheet.delegate = self;
    self.isManagerSheet = sheet;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.isManagerSheet) {
        if (buttonIndex == 1){
            self.magager.type = @"删除作品";
            [self.magager show];
        }else if (buttonIndex == 2){
            self.magager.type = @"设为仅作者可见";
            [self.magager show];
        }else if (buttonIndex == 3){
            self.magager.type = @"查看作者封面";
            [self.magager show];
        }else if (buttonIndex == 4){
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self->_drawModel.drawId;
            juBaoView.reouceType = @"5";
            [juBaoView showView];
        }
    }else if (actionSheet == self.isjubaoSheet){
        if (buttonIndex == 1) {
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = _drawModel.drawId;
            juBaoView.reouceType = @"5";
            [juBaoView showView];
            
        }
    }else if (actionSheet == self.tuyaSheet){
        if (buttonIndex == 1) {
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = _tuModel.graffitiId;
            juBaoView.reouceType = @"6";
            [juBaoView showView];
            
        } else if (buttonIndex == 2){
            if (![_tuModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] && ![_tuModel.parent_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
                self.magager.type = @"删除用户涂鸦";
                [self.magager show];
            }
        }
    }else if (actionSheet == self.tuyaSwitchSheet){
        if (buttonIndex == 2) {
            [self setTUYE];
        }
        
    }
}

- (void)setTUYE{//设置是否可以涂鸦
    if (_drawModel.graffiti_switch.integerValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.surejinzhi"]:@"確定禁止塗鴉嗎?" message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.jinzhitosat" ]:@"如果當前作品下有塗鴉，也會壹並刪除" sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [self setNotuye];
            }
        };
        [alerView showXLAlertView];
    }else{
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.changtuya"]:@"當前禁止塗鴉，是否改為允許塗鴉?" sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [self setNotuye];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)setNotuye{//设置是否可以涂鸦
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (_drawModel.graffiti_switch.integerValue) {
        [parm setObject:@"0" forKey:@"graffitiSwitch"];
    }else{
        [parm setObject:@"1" forKey:@"graffitiSwitch"];
    }
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/artwork/%@",_drawModel.user_id,_drawModel.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
         [nav.topViewController hideHUD];
        if (success) {
            self->_drawModel.graffiti_num = @"0";
            [nav.topViewController showToastWithText:self->_drawModel.graffiti_switch.integerValue?[NoticeTools getLocalStrWith:@"hh.ccan"]:[NoticeTools getLocalStrWith:@"hh.cno"]];
            self->_drawModel.graffiti_switch = self->_drawModel.graffiti_switch.integerValue? @"0":@"1";
            if (self.isMyDraw) {
               [self refreshBtn];
            }
            
        }
    } fail:^(NSError *error) {
         [nav.topViewController hideHUD];
    }];
}

- (void)refreshBtn{//刷新我作品底部UI
    if (self.isMyDraw || [_drawModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NSString *likeNmuber = [NSString stringWithFormat:@"%ld",(long)(_drawModel.publicly_like_num.integerValue+_drawModel.anonymous_like_num.integerValue)];
        self.likeNumBtn.hidden = likeNmuber.integerValue ? NO:YES;
        self.tyNumBtn.hidden = _drawModel.graffiti_num.integerValue ? NO:YES;
        if (self.isMyDraw && !_drawModel.graffiti_switch.integerValue) {
            self.tyNumBtn.hidden = NO;
        }
        if (likeNmuber.integerValue) {
            self.likeNumBtn.frame = CGRectMake(15, 15, 66, 20);
        }
        [self.likeNumBtn setTitle:[NSString stringWithFormat:@"%@x%@",[NoticeTools isSimpleLau]?@"喜欢":@"喜歡",likeNmuber] forState:UIControlStateNormal];
        
        
        self.tyNumBtn.frame = CGRectMake(likeNmuber.integerValue ? (66+30) : 15, 15, 66, 20);
        if (_drawModel.graffiti_switch.integerValue) {
            [self.tyNumBtn setTitle:[NSString stringWithFormat:@"%@x%@",[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"em.tuya"]:@"塗鴉",_drawModel.graffiti_num] forState:UIControlStateNormal];
            [_tyNumBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_drawtunum":@"Image_drawtunumy") forState:UIControlStateNormal];
            [_tyNumBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        }else{
            [self.tyNumBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"hh.cannottuy"]:@"禁止塗鴉" forState:UIControlStateNormal];
            [_tyNumBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_cannott":@"Image_cannotty") forState:UIControlStateNormal];
            [_tyNumBtn setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#B0B0B0":@"#72727F"] forState:UIControlStateNormal];
        }
    }else{
        _likeNumBtn.hidden = YES;
        _tyNumBtn.hidden = YES;
    }
}

- (void)sureManagerClick:(NSString *)code{

    if ([self.magager.type isEqualToString:@"删除作品"]) {
        [self managerDeleteWith:code];
    }else if ([self.magager.type isEqualToString:@"设为仅作者可见"]){
        [self setOnlySelfWith:code];
    }else if ([self.magager.type isEqualToString:@"查看作者封面"]){
        [self mangaerLookUserWith:code];
    }else if ([self.magager.type isEqualToString:@"删除用户涂鸦"]){
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:code forKey:@"confirmPasswd"];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/graffitis/%@",_tuModel.graffitiId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [nav.topViewController hideHUD];
            
            if (success) {
                [self.magager removeFromSuperview];
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSucessWith:)]) {
                    [self.delegate deleteSucessWith:self.index];
                }
            }
        } fail:^(NSError *error) {
            [nav.topViewController hideHUD];
        }];
    }

}

- (void)deleteDraw{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:self.isPeopleTuYa ? [NSString stringWithFormat:@"graffitis/%@",_tuModel.graffitiId] : [NSString stringWithFormat:@"users/%@/artwork/%@",_drawModel.user_id,_drawModel.drawId] Accept:self.isPeopleTuYa ? @"application/vnd.shengxi.v4.1+json" : @"application/vnd.shengxi.v3.6+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSucessWith:)]) {
                [self.delegate deleteSucessWith:self.index];
            }
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

//管理员删除作品
- (void)managerDeleteWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/artwork/%@",_drawModel.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [nav.topViewController showToastWithText:@"操作已执行"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSucessWith:)]) {
                [self.delegate deleteSucessWith:self.index];
            }
            [self.magager removeFromSuperview];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
  
}

//管理员设置仅作者可见
- (void)setOnlySelfWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [parm setObject:@"1" forKey:@"isHidden"];

    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawModel.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            [nav.topViewController showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)mangaerLookUserWith:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
            ctl.userId = self->_drawModel.user_id;
            ctl.isOther = YES;
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)setis_privateWith:(NSString *)type{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:type forKey:@"isPrivate"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/artwork/%@",_drawModel.user_id,_drawModel.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
         [nav.topViewController hideHUD];
        if (success) {
            self->_drawModel.is_private = type;
            
            [nav.topViewController showToastWithText:[type isEqualToString:@"1"]?[NoticeTools getLocalStrWith:@"hh.hasnim"]:[NoticeTools getLocalStrWith:@"hh.qxnimin"]];
        }
    } fail:^(NSError *error) {
         [nav.topViewController hideHUD];
    }];
}

- (void)jubao{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

    } otherButtonTitleArray:@[[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"chat.jubao"]:@"舉報"]];
    self.isjubaoSheet = sheet;
    sheet.delegate = self;
    [sheet show];
}

- (void)deleLikeWith:(NSString *)type{
    if (self.isPeopleTuYa) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"graffitiVotes/%@",_tuModel.vote_id] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                
                self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
                self->_firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
                self->_tuModel.vote_option = @"0";
                if ([type isEqualToString:@"1"]) {
                    if (self->_tuModel.vote_option_one.integerValue > 1) {
                        self.firstL.text = [NSString stringWithFormat:@"您是天使 %ld",(long)(self->_tuModel.vote_option_one.integerValue-1)];
                    }else{
                        self.firstL.text = @"您是天使";
                    }
                    self->_tuModel.vote_option_one = (self->_tuModel.vote_option_one.integerValue > 1) ? [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_one.integerValue-1)] : @"0";
                }else{
                    if (self->_tuModel.vote_option_two.integerValue > 1) {
                        self.firstL1.text = [NSString stringWithFormat:@"您是恶魔 %ld",(long)(self->_tuModel.vote_option_two.integerValue-1)];
                    }else{
                        self.firstL1.text = @"您是恶魔";
                    }
                    self->_tuModel.vote_option_two = (self->_tuModel.vote_option_two.integerValue > 1) ? [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_two.integerValue-1)] : @"0";
                }
            }
        } fail:^(NSError *error) {
            
        }];
    }else{
        if (self.isMyDraw) {
            return;
        }
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:type forKey:@"likeType"];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawModel.user_id,_drawModel.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                self->_firstImageView.image = UIImageNamed(([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
                self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawnixh":@"Imagedrawnixhy");
                self->_drawModel.like_type = @"0";
   
            }
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)setLikeWith:(NSString *)type{
    if (self.isMyDraw) {
        return;
    }
    _tapView.userInteractionEnabled = NO;
    NSMutableDictionary *parm = [NSMutableDictionary new];
    if (self.isPeopleTuYa) {
        [parm setObject:type forKey:@"voteOption"];
        [parm setObject:_tuModel.graffitiId forKey:@"graffitiId"];
    }else{
        [parm setObject:type forKey:@"likeType"];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isPeopleTuYa? @"graffitiVotes" : [NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawModel.user_id,_drawModel.drawId] Accept:self.isPeopleTuYa ? @"application/vnd.shengxi.v4.1+json" : @"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if (self.isPeopleTuYa) {
                NoticeDrawTuM *modelVote = [NoticeDrawTuM mj_objectWithKeyValues:dict[@"data"]];//特别注意，这里的id指的是投票id,不是涂鸦id
                self->_tuModel.vote_id = modelVote.graffitiId;
                if ([type isEqualToString:@"1"]) {
                    self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"mogui":@"moguiy");
                    self->_firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshic":@"tianshicy");
                    self.firstL.text = [NSString stringWithFormat:@"您是天使 %ld",(long)(self->_tuModel.vote_option_one.integerValue+1)];
                    [self->_firstImageView popInsideWithDuration:0.5];
                    //[self->_firstImageView animate];
                    self->_tuModel.vote_option_one = [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_one.integerValue+1)];
                    
                    if ([self->_tuModel.vote_option isEqualToString:@"2"]) {//如果之前投票了您是恶魔
                        if (self->_tuModel.vote_option_two.integerValue > 1) {
                            self.firstL1.text = [NSString stringWithFormat:@"您是恶魔 %ld",(long)(self->_tuModel.vote_option_two.integerValue-1)];
                        }else{
                            self.firstL1.text = @"您是恶魔";
                        }
                        self->_tuModel.vote_option_two = (self->_tuModel.vote_option_two.integerValue > 1) ? [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_two.integerValue-1)] : @"0";
                    }
                    
                    self->_tuModel.vote_option = @"1";
                }else{
                    self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"moguic":@"moguicy");
                    self->_firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"tianshi":@"tianshiy");
                    self.firstL1.text = [NSString stringWithFormat:@"您是恶魔 %ld",(long)(self->_tuModel.vote_option_two.integerValue+1)];
                    [self->_firstImageView1 popInsideWithDuration:0.5];
                    //[self->_firstImageView1 animate];
                    if ([self->_tuModel.vote_option isEqualToString:@"1"]) {//如果之前已经投票了你是天使
                        if (self->_tuModel.vote_option_one.integerValue > 1) {
                            self.firstL.text = [NSString stringWithFormat:@"您是天使 %ld",(long)(self->_tuModel.vote_option_one.integerValue-1)];
                        }else{
                            self.firstL.text = @"您是天使";
                        }
                        self->_tuModel.vote_option_one = (self->_tuModel.vote_option_one.integerValue > 1) ? [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_one.integerValue-1)] : @"0";
                    }
                    
                    self->_tuModel.vote_option = @"2";
                    self->_tuModel.vote_option_two = [NSString stringWithFormat:@"%ld",(long)(self->_tuModel.vote_option_two.integerValue+1)];
                    
                }
            }else{
                self->_drawModel.like_type = type;
                if ([type isEqualToString:@"2"]) {
                    [self->_firstImageView popInsideWithDuration:0.5];
                    self->_firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy");
                    self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawnixh":@"Imagedrawnixhy");
                }else{
                    [self->_firstImageView1 popInsideWithDuration:0.5];
                    self->_firstImageView.image = UIImageNamed(([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
                    self->_firstImageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagedrawnixhs":@"Imagedrawnixhsy");
                }
            }
            
            self->_tapView.userInteractionEnabled = YES;
        }
    } fail:^(NSError *error) {
        self->_tapView.userInteractionEnabled = YES;
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (UIButton *)likeNumBtn{
    if (!_likeNumBtn) {
        _likeNumBtn = [[UIButton alloc] init];
        [_likeNumBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_dralikenum":@"Image_dralikenumy") forState:UIControlStateNormal];
        [_likeNumBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _likeNumBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_likeNumBtn addTarget:self action:@selector(jsTap) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:_likeNumBtn];
        _likeNumBtn.hidden = YES;
    }
    return _likeNumBtn;
}

- (UIButton *)tyNumBtn{
    if (!_tyNumBtn) {
        _tyNumBtn = [[UIButton alloc] init];
        [_tyNumBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _tyNumBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_tyNumBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_drawtunum":@"Image_drawtunumy") forState:UIControlStateNormal];
        [_tyNumBtn addTarget:self action:@selector(pelpeoTyClick) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:_tyNumBtn];
        _tyNumBtn.hidden = YES;
    }
    return _tyNumBtn;
}

- (void)pelpeoTyClick{
    if (!_drawModel.graffiti_switch.integerValue) {
        [self setTUYE];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseNavigationController *nav = nil;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticePeolpleDrawController *ctl = [[NoticePeolpleDrawController alloc] init];
    ctl.drawM = _drawModel;
    ctl.tuYaImage = self.drawImageView.image;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
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
