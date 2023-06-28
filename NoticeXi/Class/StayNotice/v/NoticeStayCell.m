//
//  NoticeStayCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeStayCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "DDHAttributedMode.h"

@implementation NoticeStayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        
        self.userInteractionEnabled = YES;
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 16, 40, 40)];
        [self.contentView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,18,36, 36)];
        _iconImageView.layer.cornerRadius = 18;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-7, CGRectGetMaxY(_iconImageView.frame)-14,14, 14)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15,180, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];
        
        self.lelveImageView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame)+2, 15, 46, 21)];
        [self.contentView addSubview:self.lelveImageView];
        self.lelveImageView.hidden = YES;
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-140,14,140, 16)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_timeL];
        
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+1,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-10, 17)];
        _infoL.font = THRETEENTEXTFONTSIZE;
        _infoL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_infoL];
        
        _numL = [[UILabel alloc] init];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.backgroundColor = [[UIColor colorWithHexString:@"#EE4B4E"] colorWithAlphaComponent:1];
        _numL.layer.cornerRadius = 7;
        _numL.layer.masksToBounds = YES;
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.textColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:_numL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 67.5, DR_SCREEN_WIDTH-10-CGRectGetMaxX(_iconImageView.frame), 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _line = line;
        [self.contentView addSubview:line];
        
//        _subImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-12-20, CGRectGetMaxY(_timeL.frame)+3, 20, 20)];
//        _subImageV.image = UIImageNamed(@"Image_vocieclicknew");
//        [self.contentView addSubview:_subImageV];
        
        self.whoBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-80, 20, 80, 30)];
        _whoBtn.layer.cornerRadius = 5;
        _whoBtn.layer.masksToBounds = YES;
        _whoBtn.layer.borderColor = GetColorWithName(VlineColor).CGColor;
        _whoBtn.layer.borderWidth = 1;
        [self.contentView addSubview:_whoBtn];
        [_whoBtn setTitle:@"查看执行人" forState:UIControlStateNormal];
        _whoBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [_whoBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        [_whoBtn addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
        _whoBtn.hidden = YES;
        
        _line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        
        UILongPressGestureRecognizer *textlongPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        textlongPressDeleT.minimumPressDuration = 0.5;
        [self addGestureRecognizer:textlongPressDeleT];
    }
    return self;
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.longtapBlock) {
            self.longtapBlock(self.stay);
        }
    }
}


- (void)setNeedTm:(BOOL)needTm{
    _needTm = needTm;
    if (needTm) {
        _subImageV.image = UIImageNamed(@"jia");
    }else{
        _subImageV.image = UIImageNamed(@"Image_newnext");
    }
}

- (void)setGroupModel:(NoticeManagerGroupReplyModel *)groupModel{
    _groupModel = groupModel;
    _subImageV.hidden = NO;
    _infoL.text = groupModel.created_at;
    _nickNameL.text = groupModel.type.intValue == 1?@"创建社团请求":@"延期请求";
    NSArray *arr = [groupModel.userM.avatar_url componentsSeparatedByString:@"?"];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
}

- (void)setMoveModel:(NoticeMoveMemberModel *)moveModel{
    _subImageV.hidden = YES;
    _numL.frame = CGRectMake(0, 20, 30, 30);
    _numL.backgroundColor = GetColorWithName(VBackColor);
    _numL.textColor = GetColorWithName(VMainTextColor);
    _iconImageView.frame = CGRectMake(30, 10,50, 50);
    _infoL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,CGRectGetMaxY(_nickNameL.frame)+12,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12, 15);
    _whoBtn.hidden = NO;
    _numL.text = moveModel.moveId;
    _moveModel = moveModel;
    _nickNameL.text = [NSString stringWithFormat:@"%@:%@",moveModel.assocM.title,moveModel.typeName];
    _infoL.text = moveModel.created_at;
    NSArray *arr = [moveModel.toUserM.avatar_url componentsSeparatedByString:@"?"];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
}
- (void)lookClick{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = self.moveModel.fromUserM.user_id;
    ctl.isOther = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}
//点击头像
- (void)userInfoTap{
    if (self.moveModel) {//踢人记录
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.moveModel.toUserM.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        return;
    }
    
    if (self.groupModel) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.groupModel.userM.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        return;
    }
    
    if (!self.canTap) {
        return;
    }
    
    if ([_stay.with_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _stay.with_user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}


- (void)setStay:(NoticeStaySys *)stay{
    _stay = stay;

    
    _failButton.hidden = YES;
    
    if ([stay.with_user_id isEqualToString:@"1"] || stay.with_user_id.intValue == 684699 || stay.with_user_id.intValue == 1125) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
    }else{
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(stay.smalllevelImgName);
    }
    
    _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
    _nickNameL.text = stay.with_user_name;
    _nickNameL.frame =  CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 15,GET_STRWIDTH(stay.with_user_name, 16, 21), 21);
    self.lelveImageView.hidden = YES;
    
    if (stay.with_user_level.intValue) {
        self.iconMarkView.hidden = NO;
        
    }
    self.iconMarkView.image = UIImageNamed(_stay.levelImgIconName);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:stay.with_user_avatar_url]
     placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
              options:SDWebImageRefreshCached];
    
    _timeL.text = stay.updated_at;
    _numL.text = stay.un_read_num;

    NSString *str = self.isHUIS ? [NoticeTools getLocalStrWith:@"chat.hs"] : [stay.last_resource_type isEqualToString:@"2"] ? [NoticeTools getLocalStrWith:@"chat.img"] : [NoticeTools getLocalStrWith:@"chat.voice"];
    if (stay.last_resource_type.intValue == 3 && !self.isHUIS) {
        str = [NoticeTools getLocalType] == 1?@"[Text]":@"[文字]";
    }
    
    if (stay.last_resource_type.intValue > 3 && !self.isHUIS) {
        str = [NoticeTools getLocalStrWith:@"chat.shanreOfnr"];
    }
    
    if (stay.topic_type.intValue == 1) {
        NSString *helpStr = [NSString stringWithFormat:@"%@「忘记密码」",str];
        _infoL.attributedText = [DDHAttributedMode setColorString:helpStr setColor:[NoticeTools getWhiteColor:@"#FB5C57" NightColor:@"#ad403d"] setLengthString:@"「忘记密码」" beginSize:4];
    }else{
        if (stay.chat_type.intValue == 3) {
            _infoL.text = [NoticeTools getLocalStrWith:@"chat.ty"];
        }else{
           _infoL.text = str;
        }
    }
    _numL.frame = CGRectMake(DR_SCREEN_WIDTH-((GET_STRWIDTH(stay.un_read_num, 9, 14)+5)>14?(GET_STRWIDTH(stay.un_read_num, 9, 14)+5):14)-15, CGRectGetMaxY(_timeL.frame)+5, ((GET_STRWIDTH(stay.un_read_num, 9, 14)+5)>14?(GET_STRWIDTH(stay.un_read_num, 9, 14)+5):14), 14);
    _numL.hidden = !stay.un_read_num.intValue;
    
    if (self.isSL) {
        NSMutableArray *localArr = [NoticeTools getChatArrarychatId:stay.with_user_id];
        if (localArr.count) {
            self.failButton.hidden = NO;
            NoticeChatSaveModel *saveM = localArr[localArr.count-1];
            if (saveM.type.intValue == 1) {
                _infoL.text = [NoticeTools getLocalStrWith:@"chat.voice"];
            }else{
                _infoL.text = [NoticeTools getLocalStrWith:@"chat.img"];
            }
        }else{
            _failButton.hidden = YES;
        }
    }
    
    if (self.isHUIS) {
        NSMutableArray *localArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",stay.with_user_id,stay.resource_id]];
        if (localArr.count) {
            self.failButton.hidden = NO;
            NoticeChatSaveModel *saveM = localArr[localArr.count-1];
            if (saveM.type.intValue == 1) {
                _infoL.text = [NoticeTools getLocalStrWith:@"chat.voice"];
            }else{
                _infoL.text = [NoticeTools getLocalStrWith:@"chat.img"];
            }
        }else{
            _failButton.hidden = YES;
        }
    }
}

- (UIButton *)failButton{
    if (!_failButton) {
        _failButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _failButton.frame = CGRectMake(self.infoL.frame.origin.x+GET_STRWIDTH([NoticeTools getLocalStrWith:@"chat.voice"], 13, 17)+3, _infoL.frame.origin.y+2, 13, 13);
        [_failButton setImage:UIImageNamed(@"Image_failimg") forState:UIControlStateNormal];
        [self.contentView addSubview:_failButton];
        _failButton.hidden = YES;
    }
    return _failButton;
}

- (void)setTuyaModel:(NoticeStaySys *)tuyaModel{
    _tuyaModel = tuyaModel;
    NoticeStaySys *stay = tuyaModel;
    
    _nickNameL.text = stay.with_user_name;
    NSArray *arr = [stay.with_user_avatar_url componentsSeparatedByString:@"?"];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    _timeL.text = [NSString stringWithFormat:@"%@%@",_tuyaModel.dialog_num,[NoticeTools getLocalStrWith:@"chat.ty"]];
    _timeL.frame = CGRectMake(DR_SCREEN_WIDTH-10-140,0,140, 70);
    _timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    _timeL.font = TWOTEXTFONTSIZE;
    _infoL.text = stay.updated_at;
    _infoL.textColor = [UIColor colorWithHexString:@"#737780"];
    _subImageV.hidden = YES;
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
