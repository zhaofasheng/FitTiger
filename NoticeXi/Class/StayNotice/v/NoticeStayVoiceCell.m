//
//  NoticeStayVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeStayVoiceCell.h"
#import "DDHAttributedMode.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
@implementation NoticeStayVoiceCell
{
    
    UIButton *_refyseButton;
    UILabel *_biaobL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,DR_SCREEN_WIDTH-30-25, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _nickNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCenterTap)];
        [_nickNameL addGestureRecognizer:tap];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_nickNameL.frame)+2,DR_SCREEN_WIDTH-30, 16)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        [self.contentView addSubview:_timeL];
        
        _biaobL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_timeL.frame),CGRectGetMaxY(_nickNameL.frame)+10,DR_SCREEN_WIDTH-15-CGRectGetMaxY(_timeL.frame), 12)];
        _biaobL.font = TWOTEXTFONTSIZE;
        _biaobL.textAlignment = NSTextAlignmentRight;
        _biaobL.hidden = YES;
        _biaobL.textColor = _timeL.textColor;
        [self.contentView addSubview:_biaobL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(60, 67.5,DR_SCREEN_WIDTH-60, 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        _line = line;
        [self.contentView addSubview:line];
        
        _agreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-60, 31/2, 60, 32)];
        _agreenBtn.layer.cornerRadius = 7;
        _agreenBtn.layer.masksToBounds = YES;
        _agreenBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [_agreenBtn addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_agreenBtn];
        
        _refyseButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-60-10-60, 31/2, 60, 32)];
        _refyseButton.layer.cornerRadius = 7;
        _refyseButton.layer.masksToBounds = YES;
        _refyseButton.layer.borderColor = GetColorWithName(VDarkTextColor).CGColor;
        _refyseButton.layer.borderWidth = 1;
        [_refyseButton setTitle:@"忽略" forState:UIControlStateNormal];
        [_refyseButton setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        _refyseButton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [_refyseButton addTarget:self action:@selector(refreClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_refyseButton];
    }
    return self;
}

- (void)agreeClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(agreaaFriendWith:)]) {
        [self.delegate agreaaFriendWith:self.index];
    }
}

- (void)refreClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refusFriendWith:)]) {
        [self.delegate refusFriendWith:self.index];
    }
}

- (void)userCenterTap{
    if ((_other.type.intValue >= 19000 && _other.type.intValue <= 19002)){
        return;
    }
    if ([_other.type isEqualToString:@"23"] || [_nickNameL.text isEqualToString:[NoticeTools getLocalStrWith:@"each.newMsg"]]) {
        return;
    }
    if ([_other.type isEqualToString:@"18"] && _other.like_type.intValue==1) {
        return;
    }
    if (_other.type.integerValue == 35) {
        return;
    }
    if (![_other.type isEqualToString:@"4"] && ![_other.type isEqualToString:@"8"]) {//只要不是表白，点击昵称进入用户信息页
        NSString *userId = _message? _message.from_user_id : _other.from_user_id;
        if ([userId isEqualToString:@"0"] || !userId.length || !userId) {
            return;
        }
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = userId;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}


- (void)setOther:(NoticeMessage *)other{
    _other = other;
    _nickNameL.font = FIFTHTEENTEXTFONTSIZE;
    _biaobL.hidden = YES;
    _timeL.text = other.created_at;
    _refyseButton.hidden = YES;
    self.voitImagView.hidden = YES;
    if ([other.type isEqualToString:@"4"]) {
        _agreenBtn.hidden = YES;
        if ([other.open_at isEqualToString:@"0"]) {
            _biaobL.hidden = YES;
            _nickNameL.text =[NoticeTools getLocalStrWith:@"each.thinkYouGood"];
        }else{
            _biaobL.hidden = NO;
            if (other.open_at.integerValue < 8) {
                _nickNameL.text = [NoticeTools getLocalStrWith:@"each.thinkgoodOpen"];
               // _biaobL.text = [NSString stringWithFormat:@"%@%@",other.open_at,GETTEXTWITE(@"sx3.5th")];

            }else{
           //     _biaobL.text = GETTEXTWITE(@"sx3.1.ckdf");
                _nickNameL.text = [NoticeTools getLocalStrWith:@"each.thinkgoodOpen"];
            }
        }
    }else{
        _agreenBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-20, 24, 20, 20);
        [_agreenBtn setImage:UIImageNamed(@"nightto") forState:UIControlStateNormal];
        _agreenBtn.enabled = NO;
        _agreenBtn.hidden = NO;
        NSString *nickName = other.nick_name;
        if ([other.type isEqualToString:@"3"]) {//点赞
            if (other.is_anonymous.boolValue) {
                _nickNameL.text = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.sendYou"]];
            }else{
                _nickNameL.attributedText = [DDHAttributedMode setJiaCuString:[NSString stringWithFormat:@"%@ %@",nickName,[NoticeTools getLocalStrWith:@"each.sendYou"]] setSize:15 setLengthString:nickName beginSize:0] ;
            }
            self.voitImagView.hidden = NO;
            self.voitImagView.frame = CGRectMake(15+GET_STRWIDTH(_nickNameL.text, 15, 21), 16, 20, 20);
            self.voitImagView.image = UIImageNamed(@"Image_songbg");
        }else if ([other.type isEqualToString:@"5"]){
            if ([other.friend_from isEqualToString:@"2"]) {
                _nickNameL.text = [NSString stringWithFormat:@"%@%@",nickName,@"通过Cheers和你成为学友了~"];
            }
        }else if ([other.type isEqualToString:@"8"]){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"each.artcleReply"];
        }else if ([other.type isEqualToString:@"14"]){
            NSString *str = [other.tips stringByReplacingOccurrencesOfString:other.nick_name withString:@" "];
            NSString *str1 = @"天后自动解除欣赏";
            NSString *str2 = [NSString stringWithFormat:@" %@%@",other.days,str1];
            _nickNameL.text = [NSString stringWithFormat:@"%@%@",nickName,str];
            if (other.days.integerValue) {
                _timeL.text = [NSString stringWithFormat:@"%@%@",other.created_at,str2];
            }
        }else if ([other.type isEqualToString:@"16"]) {
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.pyForTc"]];
            _nickNameL.attributedText = [DDHAttributedMode setJiaCuString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }
        else if ([other.type isEqualToString:@"17"]) {
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.likeYourPy"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if ([other.type isEqualToString:@"18"]) {
            if (other.like_type.intValue == 1) {
                _nickNameL.text = [NoticeTools getLocalStrWith:@"each.likeYourDraw"];
            }else{
                self.voitImagView.hidden = NO;
                self.voitImagView.image = UIImageNamed(@"Image_songbg");
                NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.sendBgDraw"]];
                NSString *allStr = [NSString stringWithFormat:@"%@%@",nickName,str];
                _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
                self.voitImagView.frame = CGRectMake(15+GET_STRWIDTH(allStr, 15, 15), 16, 18, 18);
            }
        }else if ([other.type isEqualToString:@"25"]) {
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.collectYourDraw"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if ([other.type isEqualToString:@"27"]) {
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.sendYouDraw"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if ([other.type isEqualToString:@"16300"]) {
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.likeyourSong"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }
        else if ([other.type isEqualToString:@"19"]){
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.tuyaToYou"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
            NSString *allStr = [NSString stringWithFormat:@"%@%@",nickName,str];
            self.voitImagView.frame = CGRectMake(15+GET_STRWIDTH(allStr, 13, 13), 13, 18, 18);
        }
        else if ([other.type isEqualToString:@"20"]){
      
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.likeYourTY"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }
        else if ([other.type isEqualToString:@"22"]){
            self.voitImagView.hidden = NO;
            self.voitImagView.image = UIImageNamed(@"Image_songbg");
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.bgToYourPy"]];
            NSString *allStr = [NSString stringWithFormat:@"%@%@",nickName,str];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
            self.voitImagView.frame = CGRectMake(15+GET_STRWIDTH(allStr, 15, 15), 16, 18, 18);
        }
        else if ([other.type isEqualToString:@"23"]){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"each.pyPick"];
        }else if ([other.type isEqualToString:@"26"]){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"each.drawPick"];
        }else if (other.type.intValue == 48100){
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.comPy"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 48101){
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.replyPyCom"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 48102){
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.zanPyCom"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 501){
            NSString *str = [NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"each.scTc"]];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 16301){
            NSString *str = [NSString stringWithFormat:@" %@%@",[NoticeTools chinese:@"喜欢这首" english:@"liked " japan:@"が気に入る"],other.song_title];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 16301){
            NSString *str = [NSString stringWithFormat:@" %@%@",[NoticeTools chinese:@"喜欢这首" english:@"liked " japan:@"が気に入る"],other.song_title];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 19000){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"help.hotpeol"];
        }else if (other.type.intValue == 19002){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"help.agreez"];
        }else if (other.type.intValue == 19001){
            _nickNameL.text = [NoticeTools getLocalStrWith:@"help.hotpeorep"];
        }else if (other.type.intValue == 35){
            _nickNameL.text = [NoticeTools getLocalType]==1?@"Author replies you": ([NoticeTools getLocalType]==2?@"著者はあなたに返信します": @"每日一阅的作者回复你了");
        }else if (other.type.intValue == 19010){
            NSString *str = [NoticeTools chinese:@" 给你播客留言了" english:@" commented your podcast" japan:@" があなたにコメントしました"];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 19011){
            NSString *str = [NoticeTools chinese:@" 回复了你的播客留言" english:@" replied to your comment" japan:@"  があなたのコメントに返信しました"];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 19012){
            NSString *str = [NoticeTools chinese:@" 赞了你的播客留言" english:@" likes your comment" japan:@" がコメントを気に入りました"];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }else if (other.type.intValue == 19013){
            NSString *str = [NoticeTools chinese:@" 赞了你的播客回复" english:@"likes your reply" japan:@"があなたの返信を気に入りました"];
            _nickNameL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",nickName,str] setSize:15 setLengthString:nickName beginSize:0];
        }

        else{
            _nickNameL.text = [NoticeTools getLocalStrWith:@"each.newMsg"];
        }
    }
}

- (UIImageView *)voitImagView{
    if (!_voitImagView) {
        _voitImagView = [[UIImageView alloc] init];
        [self.contentView addSubview:_voitImagView];
    }
    return _voitImagView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
