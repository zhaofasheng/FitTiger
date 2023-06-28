//
//  NoticeChoicePhotoCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/26.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoicePhotoCell.h"
#import "BaseNavigationController.h"
#import "NoticerTopicSearchResultNewController.h"
#import "NoticeTabbarController.h"
#import "NoticePlayerVideoController.h"
@implementation NoticeChoicePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (DR_SCREEN_WIDTH-30-10)/3, (DR_SCREEN_WIDTH-30-10)/3)];
        self.choiceImageView.layer.cornerRadius = 8;
        self.choiceImageView.layer.masksToBounds = YES;
        self.choiceImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.choiceImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.choiceImageView];
        self.choiceImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.choiceImageView addGestureRecognizer:tap];
        
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.choiceImageView.frame.size.width-30, 0, 30, 30)];
        [button setImage:UIImageNamed(@"btn_img_close") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self.choiceImageView addSubview:button];
        self.deleteBtn = button;
    }
    return self;
}

- (UIImageView *)videoImageView{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _videoImageView.image = UIImageNamed(@"Image_videoimg");
        [self.choiceImageView addSubview:_videoImageView];
        _videoImageView.hidden = YES;
        _videoImageView.center = _choiceImageView.center;
    }
    return _videoImageView;
}

- (void)deleteImageClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImageWith:)]) {
        [self.delegate deleteImageWith:self.index];
    }
}

- (void)tapAction{
    if (self.isVideo) {
        NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
        ctl.videoUrl = self.videoPath;
        ctl.islocal = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.choiceImageView;
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    __weak typeof(self) weakSelf = self;
    view.hideKeybord = ^(BOOL hideKeyBord) {
        if (weakSelf.hideKeybord) {
            weakSelf.hideKeybord(hideKeyBord);
        }
    };
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.choiceImageView
                   toContainer:toView
                      animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
