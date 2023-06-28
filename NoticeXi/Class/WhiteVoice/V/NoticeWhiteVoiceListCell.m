//
//  NoticeWhiteVoiceListCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWhiteVoiceListCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSearchPersonViewController.h"
@implementation NoticeWhiteVoiceListCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        

        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressicon = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longIconPressGestureRecognized:)];
        longPressicon.minimumPressDuration = 0.5;
        [self.contentView addGestureRecognizer:longPressicon];
        
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (DR_SCREEN_WIDTH-40)/2-10, (DR_SCREEN_WIDTH-40)/2/162*212-10)];
        [self.contentView addSubview:self.cardImageView];
        self.cardImageView.layer.cornerRadius = 8;
        self.cardImageView.layer.masksToBounds = YES;
        self.cardImageView.userInteractionEnabled = YES;
        
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(10,0, self.cardImageView.frame.size.width-20, 30)];
        self.numL.textAlignment = NSTextAlignmentRight;
        self.numL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        [self.cardImageView addSubview:self.numL];
    
    }
    return self;
}

- (void)setWhiteVoiceM:(NoticeWhiteVoiceListModel *)whiteVoiceM{
    _whiteVoiceM = whiteVoiceM;
    self.numL.text = [NSString stringWithFormat:@"x%@",whiteVoiceM.card_num];
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:whiteVoiceM.card_url] placeholderImage:GETUIImageNamed(@"img_empty")];

    if (self.isSendChat) {
        [self.selectButton setImage:UIImageNamed(whiteVoiceM.isChoiceed?@"Image_signmark_b":@"Image_nocuanze") forState:UIControlStateNormal];
        self.fgView.hidden = (self.isFullMax && !whiteVoiceM.isChoiceed)?NO:YES;
    }
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc] initWithFrame:self.cardImageView.bounds];
        _fgView.layer.cornerRadius = 8;
        _fgView.layer.masksToBounds = YES;
        _fgView.backgroundColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:0.8];
        [self.cardImageView addSubview:_fgView];
        [self.cardImageView bringSubviewToFront:self.selectButton];
    }
    return _fgView;
}

- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self.cardImageView addSubview:_selectButton];
        [_selectButton addTarget:self action:@selector(choiceClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)choiceClick{
    if (self.choiceModelBlock) {
        self.choiceModelBlock(self.whiteVoiceM);
    }
}

- (void)longIconPressGestureRecognized:(UILongPressGestureRecognizer *)tap{
    if (self.noLongTap || self.isSendChat) {
        return;
    }
    if (tap.state == UIGestureRecognizerStateBegan) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        NoticeSearchPersonViewController *ctl = [[NoticeSearchPersonViewController alloc] init];
        ctl.sendWhite = YES;
        ctl.cardNo = self.whiteVoiceM.card_no;
        ctl.olnySearsh = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}
@end
